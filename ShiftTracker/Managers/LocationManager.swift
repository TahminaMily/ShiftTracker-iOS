//
//  LocationManager.swift
//  ShiftTracker
//
//  Created by Tahmina Khanam on 5/3/18.
//  Copyright © 2018 Deputy. All rights reserved.
//

import Foundation
import CoreLocation

class LocationManager: NSObject {
    static let shared = LocationManager()
    
    var authorizationStatus = CLAuthorizationStatus.notDetermined
    var lastUpdatedLocation: CLLocation? = nil
    
    typealias FetchLocationCompletion = (CLLocation?, Error?) -> Void
    var completion:FetchLocationCompletion? = nil
    
    private let locationManager = CLLocationManager()
    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyThreeKilometers
    }
    
    public func fetchLocation(completion: @escaping FetchLocationCompletion) {
        self.completion = completion
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
    }
    
}

extension LocationManager: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        lastUpdatedLocation = locations.last
        self.completion?(lastUpdatedLocation, nil)
        self.completion = nil
    }
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        authorizationStatus = status
        switch status {
        case .authorizedWhenInUse, .authorizedAlways:
            locationManager.requestLocation()
        case .notDetermined:
            break
        default:
            self.completion?(nil, "No access to location service")
            self.completion = nil
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        self.completion?(nil, error)
        self.completion = nil
    }
}
