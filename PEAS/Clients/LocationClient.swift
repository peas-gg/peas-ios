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
	
	override init() {
		super.init()
		manager.delegate = self
	}
	
	func checkForAuthorization() {
		switch manager.authorizationStatus {
		case .notDetermined:
			manager.requestWhenInUseAuthorization()
		case .restricted:
			return
		case .denied:
			return
		case .authorizedAlways:
			return
		case .authorizedWhenInUse:
			return
		@unknown default:
			return
		}
	}
	
	func requestLocation() {
		checkForAuthorization()
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
