//
//  Locator.swift
//  Location
//
//  Created by student on 3/18/25.
//

import SwiftUI
import MapKit
import CoreLocation

@Observable
class Locator: NSObject, CLLocationManagerDelegate {
    var locationManager: CLLocationManager
    var position: MapCameraPosition
    
    override init() {
        locationManager = CLLocationManager()
        position = MapCameraPosition.region(MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 33.812029, longitude: -117.919006), span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)))
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest //tell device to do whatever it needs to do to get the most accurate location
        locationManager.requestWhenInUseAuthorization()
    }
    
    func start() {
        locationManager.startUpdatingLocation()
    }
    
    func stop() {
        locationManager.stopUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        // _ is argument label
        if let newLocation = locations.last {
            position = MapCameraPosition.region(MKCoordinateRegion(center: newLocation.coordinate, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)))
        }
        
    }
}
