//
//  LocationManager.swift
//  Trallet
//
//  Created by Nicholas on 10/05/21.
//

import Foundation
import MapKit
import CoreLocation

struct Location {
    let title: String
    let coordinates: CLLocationCoordinate2D
}

class LocationManager: NSObject {
    static let shared = LocationManager()
    
    let manager = CLLocationManager()
    
    public func findLocations(with query: String, completion: @escaping (([Location]) -> Void)) {
        
    }
}

class LocationAnnotation: NSObject, MKAnnotation {
    let title: String?
    let subtitle: String?
    let coordinate: CLLocationCoordinate2D
    
    init(title: String?, locationName: String, coordinate: CLLocationCoordinate2D) {
        self.title = title
        self.subtitle = locationName
        self.coordinate = coordinate
        
        super.init()
    }
    
    init(object: MKMapItem) {
        self.title = object.name
        self.subtitle = object.placemark.title
        self.coordinate = object.placemark.coordinate
        
        super.init()
    }
}
