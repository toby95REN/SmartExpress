//
//  FencedAnnotation.swift
//  Assignment1
//
//  Created by yikeren on 2/9/18.
//  Copyright © 2018 Monash University. All rights reserved.
//

import UIKit
import MapKit

//annotation class, get idea from tutorial file
class FencedAnnotation: NSObject, MKAnnotation {
    var coordinate: CLLocationCoordinate2D
    var title: String?
    var subtitle: String?
    
    init(newTitle: String, newSubtitle: String, newLatitude: Double,newLongitude: Double) {
        title = newTitle
        subtitle = newSubtitle
        coordinate = CLLocationCoordinate2D()
        coordinate.latitude = newLatitude
        coordinate.longitude = newLongitude
    }
}
