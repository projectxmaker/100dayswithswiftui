//
//  LocationFetcher.swift
//  FaceNote
//
//  Created by Pham Anh Tuan on 11/8/22.
//

import CoreLocation

class LocationFetcher: NSObject, CLLocationManagerDelegate, ObservableObject {
    let manager = CLLocationManager()
    var lastKnownLocation: CLLocationCoordinate2D?

    @Published var authorizationStatus = CLAuthorizationStatus.notDetermined
    @Published var isAuthorized = false
    @Published var authorizationMessage = ""
    
    override init() {
        super.init()
        manager.delegate = self
    }

    func start() {
        manager.requestWhenInUseAuthorization()
        manager.startUpdatingLocation()
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        lastKnownLocation = locations.first?.coordinate
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        authorizationStatus = manager.authorizationStatus
        
        switch manager.authorizationStatus {
        case .notDetermined, .restricted, .denied:
            isAuthorized = false
            authorizationMessage = "No access"
        case .authorizedAlways, .authorizedWhenInUse:
            manager.startUpdatingLocation()

            isAuthorized = true
            authorizationMessage = "Access"
        @unknown default:
            isAuthorized = false
            authorizationMessage = "Unknown status"
            break
        }
    }
}
