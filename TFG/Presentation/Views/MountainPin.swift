//
//  MountainPin.swift
//  TFG
//
//  Created by Andrés Pizá on 19/4/15.
//  Copyright (c) 2015 Tovkal. All rights reserved.
//

import UIKit
import MapKit

class MountainPin : NSObject, MKAnnotation {
    
    var coordinate: CLLocationCoordinate2D
    var title: String
    var subtitle: String
    var pinColor: MKPinAnnotationColor
    
    /**
    Initialitzer
    
    :param: coordinate Coordinates for the pin
    :param: title      Title for the pin
    :param: subtitle   Subtitle for the pin
    
    :returns: MKAnnotation pin
    */
    init(coordinate: CLLocationCoordinate2D, title: String, subtitle: String) {
        self.coordinate = coordinate
        self.title = title
        self.subtitle = subtitle
        self.pinColor = MKPinAnnotationColor.Green
    }
}
