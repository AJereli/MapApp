//
//  ViewController.swift
//  MapApp
//
//  Created by Valeev Anatoliy on 17/11/2017.
//  Copyright © 2017 User. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import PromiseKit
import CoreGraphics

class AppleMapController: UIViewController, UIGestureRecognizerDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var numberTextField: UITextField!
    @IBOutlet weak var editByTapLabel: UILabel!
    
    @IBOutlet weak var roadLoadSpiner: UIActivityIndicatorView!
    
    @IBOutlet weak var meBtn: UIButton!
    @IBOutlet weak var cleanBtn: UIButton!
    @IBOutlet weak var changeLanguageBtn: UIButton!
    
    /// MANAGERS
    let locationManager = CLLocationManager()
    let polygonManager:PolygonManager = PolygonManager.shared
    let routeManager:RouteManager = RouteManager()
    ///
    
    
    private var _kbShow:Bool = false
    private var _isEditTap:Bool = false
    private var _isEditableByTap:Bool = false
    private var _isRouteLoading:Bool = false
    private var _isRouteBuild:Bool = true
    
    private let _circleScale:Double = 2000.0 /*magic const for scale*/
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setFields()
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        tapGestureRecognizer.delegate = self
        mapView.addGestureRecognizer(tapGestureRecognizer)
        
        //        let panGestureRecognizer = UIPanGestureRecognizer(target:self, action: #selector(self.didDragMap(gestureRecognizer:)))
        //        panGestureRecognizer.delegate = self
        // mapView.addGestureRecognizer(panGestureRecognizer)
        
        numberTextField.setPlaceholder(text:"Numer", color: UIColor.white)
        
        mapView.showsUserLocation = true
        mapView.delegate = self
        mapView.removeAnnotations(mapView.annotations)
        
        initLocationManager()
        requestLocationAccess()
        
        
    }
    
    
    func setFields (){
        cleanBtn.setTitle("Clean".localize, for: .normal)
        meBtn.setTitle("Me".localize, for: .normal)
        changeLanguageBtn.setTitle("Change language".localize, for: .normal)
        editByTapLabel.text = "By tap".localize
        
    }
    
    private func addRoute (){
        if !_isRouteBuild, _isRouteLoading {
            return
        }
        let apxs:[CLLocationCoordinate2D] = mapView.annotations.filter{return $0 is MapMark}.map{
            return $0.coordinate
        }
        let cnt = apxs.count
        
        if cnt > 1 {
            _isRouteLoading = true
            roadLoadSpiner.startAnimating()
            routeManager.getRoutePolyline(from: apxs[cnt - 2], to: apxs[cnt - 1], completion: {
                route -> Void in
                self.mapView.add(route)
                self._isRouteLoading = false
                self.roadLoadSpiner.stopAnimating()
            }, errorHandler: { error -> Void in
                self._isRouteLoading = false
                self.roadLoadSpiner.stopAnimating()
                self.showAlertMessage(title: "Error", message: error.localizedDescription)
                self.cleanMap()
            })
            
        }
        
    }
    
    private func addOverlay(){
        if _isRouteBuild {
            return
        }
        print("ann.cnt: \(mapView.annotations.count)")
        polygonManager.apexsSource = mapView.annotations
        
        mapView.add(polygonManager.getMKShape(mapView.camera.altitude / _circleScale)!)
        //mapView.removeOverlays(mapView.overlays)
        
        
    }
    
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    @objc func handleTap(gestureRecognizer: UILongPressGestureRecognizer) {
        
        let location = gestureRecognizer.location(in: mapView)
        let coordinate = mapView.convert(location,toCoordinateFrom: mapView)
        let annotation = MapMark(title: coordinate.toString(), discipline: "", coordinate: coordinate)
        
        
        
        
        
        if _isRouteBuild {
            routeManager.addApex(coordinate: coordinate)
        }
        if _isRouteLoading {
            return
        }
        
        mapView.addAnnotation(annotation)
        addOverlay()
        addRoute()
    }
    
    
    
    private func cleanMap (){
        mapView.removeAnnotations(mapView.annotations)
        mapView.removeOverlays(mapView.overlays)
        PolygonManager.shared.cleanApexs()
        
        _isEditTap = false
    }
    
    @IBAction func editByTapAct(_ sender: Any) {
        _isEditableByTap = (sender as! UISwitch).isOn
    }
    @IBAction func meBtnAction(_ sender: Any) {
        mapView.centerMapOnLocation(location: locationManager.location!)
    }
    @IBAction func cleanAct(_ sender: Any) {
        cleanMap()
    }
    @IBAction func changeLanguageAct(_ sender: Any) {
        let loc = Localizator.instance
        loc.currentLanguage = loc.currentLanguage == "en" ? "Russian" : "English"
        setFields()
    }
    
    @IBAction func buttonAct(_ sender: Any) {
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

extension AppleMapController : CLLocationManagerDelegate{
    
    
    func initLocationManager () {
        if (CLLocationManager.locationServicesEnabled())
        {
            
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.requestAlwaysAuthorization()
            
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation])
    {
        
        let location = locations.last! as CLLocation
        let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        mapView.centerMapOnLocation(location: center.location)
        
    }
    
    
    
    func requestLocationAccess() {
        let status = CLLocationManager.authorizationStatus()
        
        switch status {
        case .authorizedAlways, .authorizedWhenInUse:
            return
            
        case .denied, .restricted:
            showAlertMessage(title: "location access denied", message: "location access denied")
        default:
            locationManager.requestWhenInUseAuthorization()
        }
    }
    
}

extension AppleMapController : MKMapViewDelegate{
    
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        var annotationView:MKPinAnnotationView? = nil
        if annotation is MapMark {
            annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "myPin")
            
            annotationView?.pinTintColor = .black
            annotationView?.isDraggable = true
            annotationView?.animatesDrop = true
            
        }
        
        return annotationView
        
    }
    
    
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, didChange newState: MKAnnotationViewDragState, fromOldState oldState: MKAnnotationViewDragState) {
        addOverlay()
        
        switch newState {
            
        case .starting:
            print("starting")
            view.dragState = .dragging
        case .dragging:
            print("dragging")
            
        case .ending:
            print("ending")
            view.dragState = .none
        case .canceling:
            print("canceling")
        //view.dragState = .none
        default: break
        }
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        print("sel")
        
    }
    
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        
        var renderer: MKOverlayPathRenderer = MKOverlayPathRenderer()
        
        switch overlay{
        case is MKPolyline:
            renderer = MKPolylineRenderer(overlay: overlay)
        case is MKCircle:
            renderer = MKCircleRenderer(overlay: overlay)
        case is MKPolygon:
            renderer = MKPolygonRenderer(overlay: overlay)
        default:
            return MKOverlayRenderer()
        }
        
        renderer.fillColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.3)
        renderer.lineWidth = 1
        renderer.strokeColor = UIColor.black
        
        return renderer
    }
    
}

