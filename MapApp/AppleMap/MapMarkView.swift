//
//  MapMarkView.swift
//  MapApp
//
//  Created by Valeev Anatoliy on 17/11/2017.
//  Copyright © 2017 User. All rights reserved.
//

import Foundation
import MapKit


class MapMarkerMarkerView: MKAnnotationView {
    
    override var annotation: MKAnnotation? {
    willSet {

//      canShowCallout = true
//      calloutOffset = CGPoint(x: -5, y: 5)
//      let mapsButton = UIButton(frame: CGRect(origin: CGPoint.zero,
//        size: CGSize(width: 30, height: 30)))
//      mapsButton.setBackgroundImage(UIImage(named: "Maps-icon"), for: UIControlState())
//      rightCalloutAccessoryView = mapsButton
//      rightCalloutAccessoryView = UIButton(type: .detailDisclosure)

      
      image = UIImage(named: "polygon")
      
        
    }
  }
    
}
