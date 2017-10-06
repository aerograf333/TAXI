//
//  PassengerAnnotation.swift
//  TAXI
//
//  Created by Rkhorenko on 9/29/17.
//  Copyright © 2017 Rkhorenko. All rights reserved.
//

import Foundation
import MapKit

class PassengerAnnotation: NSObject, MKAnnotation {
    dynamic var coordinate: CLLocationCoordinate2D
    var key: String
    
    init(coordinate: CLLocationCoordinate2D, key: String) {
        self.coordinate = coordinate
        self.key = key
        super.init()
    }
}
