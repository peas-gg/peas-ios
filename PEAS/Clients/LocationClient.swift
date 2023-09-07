//
//  LocationClient.swift
//  PEAS
//
//  Created by Kingsley Okeke on 2023-09-05.
//

import CoreLocation
import Foundation

class LocationClient: NSObject, ObservableObject, CLLocationManagerDelegate {
	static let shared: LocationClient = LocationClient()
	
	let manager = CLLocationManager()
	
	@Published var location: CLLocationCoordinate2D?
	
	var permissionState: PermissionState {
		switch manager.authorizationStatus {
		case .notDetermined: return .undetermined
		case .restricted, .denied: return .denied
		case .authorizedAlways: return .allowed
		case .authorizedWhenInUse: return .allowed
		@unknown default:
			return .denied
		}
	}
	
	override init() {
		super.init()
		manager.delegate = self
	}
	
	func requestForPermission() {
		manager.requestWhenInUseAuthorization()
	}
	
	func requestLocation() {
		manager.desiredAccuracy = kCLLocationAccuracyBest
		manager.requestLocation()
	}
	
	func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
		self.location = locations.first?.coordinate
	}
	
	func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
		print(error.localizedDescription)
	}
}
