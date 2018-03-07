//
//  LocalizationViewController.swift
//  AlumniCev
//
//  Created by Daniel Plata on 22/1/18.
//  Copyright © 2018 Victor Serrano. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import CPAlertViewController
import SwiftSpinner

class LocalizationViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    
    @IBOutlet weak var titleLocalizationLbl: UILabel!
    
    @IBOutlet weak var mapRoute: MKMapView!
    
    @IBOutlet weak var segmentedTransport: UISegmentedControl!
    
    var transportType: MKDirectionsTransportType?
    
    let manager = CLLocationManager()
    
    var lon:Float = 0.0
    var lat:Float = 0.0
    let userAnnotation = MKPointAnnotation()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyKilometer

        mapRoute.delegate = self
        
        titleLocalizationLbl.text = "howToGo".localized()
        userAnnotation.title = "Tú ubicación"
        self.transportType = .walking
        // chincheta cev
        
        let latitude:CLLocationDegrees = CLLocationDegrees(40.437628)
        let longitude:CLLocationDegrees = CLLocationDegrees(-3.715484)
        let location:CLLocationCoordinate2D = CLLocationCoordinate2DMake(latitude, longitude)
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = location
        annotation.title = "CEV"
        annotation.subtitle = "Calle Gaztambide 65, 28015 Madrid"
        mapRoute.addAnnotation(annotation)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        SwiftSpinner.show("Accediendo a tu localización")
        if CLLocationManager.locationServicesEnabled() {
            switch CLLocationManager.authorizationStatus() {
                
            case .notDetermined:
                manager.requestAlwaysAuthorization()
                
            case .restricted, .denied:
                
                let alert = UIAlertController(title: "Localización necesaria", message: "Es necesario acceder a la localización", preferredStyle: .alert)
                
                alert.addAction(UIAlertAction(title: "OK, ir a ajustes", style: .default, handler: { (alert) in
                    UIApplication.shared.open(URL(string: UIApplicationOpenSettingsURLString)!, completionHandler: nil
                    )
                }))
                
                alert.addAction(UIAlertAction(title: "No quiero permitir localización", style: .cancel, handler: {(alert) in
                    self.mapRoute.removeOverlays(self.mapRoute.overlays)
                    self.setMark()
                    self.segmentedTransport.isHidden = true
                }))
                
                self.present(alert, animated: true)
                
            case .authorizedAlways, .authorizedWhenInUse:
                self.segmentedTransport.isHidden = false
                manager.startUpdatingLocation()
                //getLocation()
                
            }
        } else {
            
            let alert = UIAlertController(title: "Localización necesaria", message: "Es necesario acceder a la localización", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "OK, ir a ajustes", style: .default, handler: { (alert) in
                UIApplication.shared.open(URL(string: UIApplicationOpenSettingsURLString)!, completionHandler: nil
                )
            }))
            
            alert.addAction(UIAlertAction(title: "No quiero permitir localización", style: .cancel, handler: {(alert) in
                self.mapRoute.removeOverlays(self.mapRoute.overlays)
                self.setMark()
                self.segmentedTransport.isHidden = true
            }))
            
            self.present(alert, animated: true)
        }
    }
    

    func setMark(){
        
        let latitude:CLLocationDegrees = CLLocationDegrees(40.437628)
        let longitude:CLLocationDegrees = CLLocationDegrees(-3.715484)
        let location:CLLocationCoordinate2D = CLLocationCoordinate2DMake(latitude, longitude)
        
        let latDelta:CLLocationDegrees = 0.01
        let longDelta:CLLocationDegrees = 0.01
        
        let span:MKCoordinateSpan = MKCoordinateSpanMake(latDelta, longDelta)
        
        
        let region:MKCoordinateRegion = MKCoordinateRegionMake(location, span)
        
        mapRoute.setRegion(region, animated: true)
    }
    
    
    func requestRoute(){
        let coordenadasOrigen = CLLocationCoordinate2DMake(CLLocationDegrees(self.lat), CLLocationDegrees(self.lon))
        let coordenadasDestino = CLLocationCoordinate2DMake(40.437628,-3.715484)
        
        let origen = MKMapItem(placemark: MKPlacemark(coordinate: coordenadasOrigen))
        let destino = MKMapItem(placemark: MKPlacemark(coordinate: coordenadasDestino))
        
        let peticion = MKDirectionsRequest()
        peticion.transportType = self.transportType!
        
        peticion.source = origen
        peticion.destination = destino
        let indicaciones = MKDirections(request: peticion)
        let alert = CPAlertViewController()
        indicaciones.calculate { (response, error) in
            SwiftSpinner.hide()
            // quitar ruta anterior
            self.mapRoute.removeOverlays(self.mapRoute.overlays)
            if let error = error {
                // dejar de actualizar la posicion si no puede calcular la ruta
                self.manager.stopUpdatingLocation()
                // alert no se puede calcular la ruta
                alert.showError(title: "Error", message: error.localizedDescription, buttonTitle: "OK", action: {(nil) in
                    self.setMark()
                })
            } else {
                
                //print((response?.routes[0].expectedTravelTime)!/60/60)
                
                self.mapRoute.removeAnnotation(self.userAnnotation)
                // ubicacion usuario
                self.userAnnotation.coordinate = CLLocationCoordinate2DMake(CLLocationDegrees(self.lat), CLLocationDegrees(self.lon))
                self.mapRoute.addAnnotation(self.userAnnotation)
                
                // ruta
                self.mapRoute.add((response?.routes[0].polyline)!)
                self.zoomToPolyLine(map: self.mapRoute, polyLine: (response?.routes[0].polyline)!, animated: true)
                
            }
        }
    }
    
    func zoomToPolyLine(map : MKMapView, polyLine : MKPolyline, animated : Bool)
    {
        
        var regionRect = polyLine.boundingMapRect
        
        let wPadding = regionRect.size.width * 0.25
        let hPadding = regionRect.size.height * 0.25
        
        //Add padding to the region
        regionRect.size.width += wPadding
        regionRect.size.height += hPadding
        
        //Center the region on the line
        regionRect.origin.x -= wPadding / 2
        regionRect.origin.y -= hPadding / 2
        
        map.setRegion(MKCoordinateRegionForMapRect(regionRect), animated: true)
        
    }
    
    @IBAction func changeTransport(_ sender: UISegmentedControl) {
        manager.stopUpdatingLocation()
        SwiftSpinner.show("Accediendo a tu localización")
        switch sender.selectedSegmentIndex {
        case 0:
            self.transportType = .walking
        case 1:
            self.transportType = .automobile
        case 2:
            self.transportType = .transit
        default:
            self.transportType = .walking
        }
        manager.startUpdatingLocation()
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay:
        MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(overlay: overlay)
        renderer.strokeColor = cevColor
        renderer.lineWidth = 3
        return renderer
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            SwiftSpinner.hide()
            self.lon = Float(location.coordinate.longitude)
            self.lat = Float(location.coordinate.latitude)
            // calcular ruta
            SwiftSpinner.show("Calculando ruta")
            requestRoute()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Failed to find user's location: \(error.localizedDescription)")
        
        self.manager.stopUpdatingLocation()
        self.mapRoute.removeOverlays(self.mapRoute.overlays)
        let alert = CPAlertViewController()
        alert.showError(title: "Error", message: "No se puede obtener tu localizacion, intentalo mas tarde", buttonTitle: "OK", action: {(nil) in
            self.setMark()
        })
        SwiftSpinner.hide()
        
    }
    
    
}
