//
//  MapMark.swift
//  MapApp
//
//  Created by Valeev Anatoliy on 17/11/2017.
//  Copyright © 2017 User. All rights reserved.
//

import Foundation


import MapKit

class MapMark: NSObject, MKAnnotation, BMKAnnotation {
    let aTitle: String?
    
    let discipline: String
    var coordinate: CLLocationCoordinate2D
    let img: UIImage?
    
    init(title: String, discipline: String, coordinate: CLLocationCoordinate2D) {
        self.aTitle = title
        self.discipline = discipline
        self.coordinate = coordinate
        img = nil
        super.init()
    }
    
   
}
