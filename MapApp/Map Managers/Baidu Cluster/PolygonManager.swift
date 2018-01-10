//
//  PolygonManager.swift
//  MapApp
//
//  Created by Valeev Anatoliy on 17/11/2017.
//  Copyright © 2017 User. All rights reserved.
//

import Foundation
import MapKit
import UIKit
import CoreLocation
class PolygonManager {
    
    private var apexs:[CLLocationCoordinate2D] = [CLLocationCoordinate2D]()
    var apexsSource:[Any] = [Any]()
    
    var apexLimit:Int = 3
    
    static private let _pl:PolygonManager = PolygonManager()
    
    static var shared: PolygonManager {
        get{
            return _pl
        }
    }
    var apexCount:Int {
        get
        {
            return apexs.count
        }
        
    }
    
    private init(){
    }
    
    
    
    func replaceApex (old:CLLocationCoordinate2D, new:CLLocationCoordinate2D) {
        if let index = apexs.index(where: { (a) -> Bool in
            a == old
        }){
            apexs[index] = new
        }
    }
    
    func editAndReplaceApex(old: CLLocationCoordinate2D, offset:CLLocationCoordinate2D){
        
    }
    
    func getMKShape (_ mapZoom:Double = 1.0) -> MKOverlay?{
        var overlay:MKOverlay? = nil
        convertToApexs()
        switch apexs.count {
        case 1:
            overlay = MKCircle(center: apexs[0], radius: 200.0 * mapZoom)
        case 2:
            overlay = MKPolyline(coordinates: &apexs, count: apexs.count)
        default:
            overlay = MKPolygon(coordinates: &apexs, count: apexs.count)
        }
    
        return overlay
    }
    
    private func convertToApexs (){
        apexs.removeAll()
        for obj in apexsSource{
            if obj is MapMark{
                let ann = obj as! MKAnnotation
                apexs.append(ann.coordinate)
            }
        }
    }
    
    func getBMKShape (_ mapZoom:Double = 1.0) -> BMKOverlay?{
        var overlay:BMKOverlay? = nil
        convertToApexs()
        switch apexs.count {
        case 1:
            overlay = BMKCircle(center: apexs[0], radius: 200.0 * mapZoom)
        case 2:
            overlay = BMKPolyline(coordinates: &apexs, count: UInt(apexs.count))
        default:
            overlay = BMKPolygon(coordinates: &apexs, count: UInt(apexs.count))
        }
        
        return overlay
    }
    func cleanApexs (){
        apexs.removeAll()
    }
    
    func mayAdded () -> Bool {
        return true
    }
    func addApex (coordinate: CLLocationCoordinate2D){
        if mayAdded() {
            //apexs.sort(by: { $0.distance(to: coordinate.location) < $1.distance(to: coordinate.location) })
            apexs.insert(coordinate, at: 0)
        }
    }
    
    
    
}
    

