//
//  DriverAnotation.swift
//  TAXI
//
//  Created by Rkhorenko on 9/29/17.
//  Copyright © 2017 Rkhorenko. All rights reserved.
//

import Foundation
import MapKit


class DriverAnnotation: NSObject, MKAnnotation {
  
   dynamic var coordinate: CLLocationCoordinate2D
    var key: String
    
    init(coordinate: CLLocationCoordinate2D, WithKey key: String ) {
        self.coordinate = coordinate
        self.key = key
        super.init()
        
    }
    func update(annotationPosition annotation: DriverAnnotation, withCoordinate coordinate: CLLocationCoordinate2D){
        var location = self.coordinate
        location.latitude = coordinate.latitude
        location.latitude = coordinate.longitude
        UIView.animate(withDuration: 0.2){
        self.coordinate = coordinate
        }
    }
}
