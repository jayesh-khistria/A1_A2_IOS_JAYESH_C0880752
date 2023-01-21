//
//  City.swift
//  A1_A2_IOS_JAYESH_C0880752
//
//  Created by Jayesh Khistria on 2023-01-20.
//

import Foundation
import MapKit

class City: NSObject, MKAnnotation {
    var title: String?
    var subtitle: String?
    var coordinate: CLLocationCoordinate2D
    
    init(title: String?, subtitle: String?, coordinate: CLLocationCoordinate2D) {
        self.title = title
        self.subtitle = subtitle
        self.coordinate = coordinate
    }
}
