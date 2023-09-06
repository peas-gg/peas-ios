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

	func requestLocation() -> CLLocationCoordinate2D? {
		manager.requestLocation()
		return self.location
	}
	
	func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
		self.location = locations.first?.coordinate
	}
}
