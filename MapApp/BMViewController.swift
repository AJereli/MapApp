//
//  BaiduMapController.swift
//  MapApp
//
//  Created by Valeev Anatoliy on 24/11/2017.
//  Copyright © 2017 User. All rights reserved.
//

import UIKit


class BMViewController: UIViewController, UIGestureRecognizerDelegate, BMKLocationServiceDelegate {

    @IBOutlet weak var changeLangBtn: UIButton!
    @IBOutlet weak var cleanBtn: UIButton!
    @IBOutlet weak var meBtn: UIButton!
    @IBOutlet weak var viewForMap: UIView!
    
    var mapView: BMKMapView?
    
    private var _isEditTap:Bool = false
    private var _isEditableByTap:Bool = false
    
    private let _circleScale:Double = 2000.0 /*magic const for scale*/
    
    var selectedAnnotation:MapMark? = nil
    
    
    var locationService: BMKLocationService!
    var polygonManager:PolygonManager = PolygonManager.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView = BMKMapView(frame: viewForMap.frame)
        self.view.addSubview(mapView!)
       
        
        locationService = BMKLocationService()
      
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        tapGestureRecognizer.delegate = self
        mapView?.addGestureRecognizer(tapGestureRecognizer)
        
    }
    
   
    
    @objc func handleTap(gestureRecognizer: UILongPressGestureRecognizer) {
        
        if let mapView = mapView {
            let location = gestureRecognizer.location(in: mapView)
            let coordinate = mapView.convert(location,toCoordinateFrom: mapView)
            let annotation = MapMark(title: coordinate.toString(), discipline: "", coordinate: coordinate)
            mapView.addAnnotation(annotation)
            addOverlay()
            
        }
        
       
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        mapView?.viewWillAppear()
        mapView?.delegate = self
        locationService.delegate = self
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        BMKMapView.enableCustomMapStyle(false)
        mapView?.viewWillDisappear()
        mapView?.delegate = nil
    }
    
    
    func setFields(){
        cleanBtn.setTitle("Clean".localize, for: .normal)
        meBtn.setTitle("Me".localize, for: .normal)
        changeLangBtn.setTitle("Change language".localize, for: .normal)
    }
    
   
    @IBAction func meAction(_ sender: Any) {
        
        mapView?.centerMapOnLocation(location: locationService.userLocation.location)
    }
    
    @IBAction func cleanAction(_ sender: Any) {
        if let mapView = self.mapView{
            mapView.removeOverlays(mapView.overlays)
            mapView.removeAnnotations(mapView.annotations)
        }
        PolygonManager.shared.cleanApexs()
        _isEditTap = false
    }
   
    @IBAction func changeLanguageAct(_ sender: Any) {
        let loc = Localizator.instance
        loc.currentLanguage = loc.currentLanguage == "en" ? "Russian" : "English"
        setFields()
    }
}


extension BMViewController : BMKMapViewDelegate{
    
    func mapView(_ mapView: BMKMapView!, viewFor overlay: BMKOverlay!) -> BMKOverlayView {
        var overlayView: BMKOverlayGLBasicView = BMKOverlayGLBasicView()
        
        switch overlay{
        case is BMKPolyline:
            overlayView = BMKPolylineView(overlay: overlay)
        case is BMKCircle:
            overlayView = BMKCircleView(overlay: overlay)
        case is BMKPolygon:
            overlayView = BMKPolygonView(overlay: overlay)
          
        default:
            return BMKOverlayView()
        }

        overlayView.strokeColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1)
        overlayView.fillColor  = UIColor(red: 0, green: 0, blue: 0, alpha: 0.3)
        overlayView.lineWidth = 1
        return overlayView
        
        
    }
    
   
    func mapView(_ mapView: BMKMapView!, didSelect view: BMKAnnotationView!) {
      
    }
    
  
    func mapView(_ mapView: BMKMapView!, didDeselect view: BMKAnnotationView!) {
        print("Uncheck the callout")
    }
    
    // 0 - not selected
    // 1 - selected
    // 2 - drag
    // 3 - hz
    // 4 - drop
    func mapView(_ mapView: BMKMapView!, annotationView view: BMKAnnotationView!, didChangeDragState newState: UInt, fromOldState oldState: UInt) {
        
        switch newState {
        case 2:
            addOverlay()
        default:
            break
        }
        
    }
    
    private func addOverlay(){
        if let mapView = self.mapView{
            polygonManager.apexsSource = mapView.annotations
            mapView.removeOverlays(mapView.overlays)
            mapView.add(PolygonManager.shared.getBMKShape(123))
            
        }
    }
    
    
    func mapView(_ mapView: BMKMapView!, viewFor annotation: BMKAnnotation!) -> BMKAnnotationView! {
        var annotationView:BMKAnnotationView? = nil
        if annotation is MapMark {
            annotationView = BMKPinAnnotationView(annotation: annotation, reuseIdentifier: "myPin")
            annotationView!.tintColor = .black
            annotationView!.isDraggable = true
            
            
        }

        return annotationView
    }
}



