//
//  MapUtils.swift
//  MapApp
//
//  Created by Valeev Anatoliy on 17/11/2017.
//  Copyright © 2017 User. All rights reserved.
//

import Foundation
import MapKit
import CoreLocation


extension MKMapView{
    func centerMapOnLocation(location: CLLocation, regionRadius: CLLocationDistance =  1000) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate,
                                                                  regionRadius, regionRadius)
        self.setRegion(coordinateRegion, animated: true)
    }

}

extension BMKMapView{
    func centerMapOnLocation(location: CLLocation, regionRadius: CLLocationDistance =  1000) {
        let coordinateRegion = BMKCoordinateRegionMakeWithDistance(location.coordinate,
                                                                  regionRadius, regionRadius)
        self.setRegion(coordinateRegion, animated: true)
    }
    
    
    
 var convertAnnotations:[BMKAnnotation]{
        get{
            var ann:[BMKAnnotation] = [BMKAnnotation]()
            for obj in self.annotations{
                ann.append(obj as! BMKAnnotation)
            }
            return ann
            
        }
    }
    
}

extension CLLocationCoordinate2D{
    
 
    
    static func ==(_ first: CLLocationCoordinate2D, _ second: CLLocationCoordinate2D) -> Bool{
        return (first.latitude == second.latitude) && (first.longitude == first.longitude)
    }
    static func !=(_ first: CLLocationCoordinate2D, _ second: CLLocationCoordinate2D) -> Bool{
        return !(first == second)
    }
    
    var location: CLLocation {
        return CLLocation(latitude: self.latitude, longitude: self.longitude)
    }
    
    mutating func addOffset (_ offset: CLLocationCoordinate2D){
        self.latitude += offset.latitude
        self.longitude += offset.longitude
    }
    
    func distance(to location: CLLocation) -> CLLocationDistance {
        return location.distance(from: self.location)
    }
    
    func toString () -> String{
        let latitude = NSString(format: "%.4f", self.latitude)
        let longitude = NSString(format: "%.4f", self.longitude)
        return "lat: \(latitude) long: \(longitude)"
    }
}
