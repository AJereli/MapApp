//
//  RouteManager.swift
//  MapApp
//
//  Created by Valeev Anatoliy on 28/12/2017.
//  Copyright © 2017 User. All rights reserved.
//

import Foundation
import MapKit
import UIKit
import CoreLocation


class RouteCoords{
    var coords:[CLLocationCoordinate2D] = []
    var start:CLLocationCoordinate2D?
    var terminate:CLLocationCoordinate2D?
    
    init () { }
    init (start:CLLocationCoordinate2D, terminate:CLLocationCoordinate2D){
        self.start = start
        self.terminate = terminate
    }
    func complete () -> Bool{
        if let _ = start, let _ = terminate{
            return true
        }
        return false
    }
}



class RouteManager {
    private var _routeApexs:[CLLocationCoordinate2D] = [CLLocationCoordinate2D]()
    private var _fullRoutePolyline:[MKPolyline] = [MKPolyline]()
    
    var fullRoute:[MKPolyline] {get {return _fullRoutePolyline}}
    
    
    func getRoutePolyline (from:CLLocationCoordinate2D, to:CLLocationCoordinate2D, transportType:MKDirectionsTransportType = .any,
                           completion: @escaping (_ polyline:MKPolyline ) -> (), errorHandler: @escaping (_ error:Error) -> () ) {
        
        let fromMapItem = MKMapItem(placemark: MKPlacemark(coordinate: from, addressDictionary: nil))
        let toMapItem = MKMapItem(placemark: MKPlacemark(coordinate: to, addressDictionary: nil))
        
        let directionRequest = MKDirectionsRequest()
        
        directionRequest.source = fromMapItem
        directionRequest.destination = toMapItem
        
        directionRequest.transportType = transportType
        
        
        // Calculate the direction
        let directions = MKDirections(request: directionRequest)
        
        //var resultRoute:MKPolyline? = nil
        
        directions.calculate {
            (response, error) -> Void in
            
            guard let response = response else {
                if let error = error {
                    print("Error: \(error)")
                    errorHandler(error)
                }
                
                return
            }
            self._fullRoutePolyline.append(response.routes[0].polyline)
            completion(response.routes[0].polyline)
            
        }
    }
    
    func cleanApexs (){
        _routeApexs.removeAll()
       
    }
    
    var mayAdded:Bool {get {return true }}
    
    
    
    func addApex (coordinate: CLLocationCoordinate2D) -> Bool {
        if mayAdded {
            _routeApexs.append(coordinate)
        }
        return mayAdded
    }
    
}
