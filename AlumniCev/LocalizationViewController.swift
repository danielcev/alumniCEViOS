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

class LocalizationViewController: UIViewController, MKMapViewDelegate {
    
    @IBOutlet weak var titleLocalizationLbl: UILabel!
    
    @IBOutlet weak var mapRoute: MKMapView!
    
    var transportType: MKDirectionsTransportType?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleLocalizationLbl.text = "howToGo".localized()
        
        self.transportType = .walking
        
        mapRoute.delegate = self
        
        if CLLocationManager.locationServicesEnabled() {
            switch CLLocationManager.authorizationStatus() {
            case .notDetermined, .restricted, .denied:
                mapRoute.isHidden = true
                
                UIApplication.shared.open(URL(string: UIApplicationOpenSettingsURLString)!, completionHandler: {(Bool) in
                    
                })

                
            case .authorizedAlways, .authorizedWhenInUse:
                
                print("aceptado")
                setRoute()
            }
        } else {
            print("Location services are not enabled")
        }
        
    }
    
    func setRoute(){
        
        let latitude:CLLocationDegrees = CLLocationDegrees(40.437628)
        let longitude:CLLocationDegrees = CLLocationDegrees(-3.715484)
        
        let latDelta:CLLocationDegrees = 0.01
        let longDelta:CLLocationDegrees = 0.01
        
        let span:MKCoordinateSpan = MKCoordinateSpanMake(latDelta, longDelta)
        let location:CLLocationCoordinate2D = CLLocationCoordinate2DMake(latitude, longitude)
        
        let region:MKCoordinateRegion = MKCoordinateRegionMake(location, span)
        
        mapRoute.setRegion(region, animated: true)
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = location
        annotation.title = "CEV"
        annotation.subtitle = "Calle Gaztambide 65, 28015 Madrid"
        
        mapRoute.addAnnotation(annotation)
        
        //////
        
        requestRoute()
    }
    
    func requestRoute(){
        let coordenadasOrigen = CLLocationCoordinate2DMake(40.4283791, -3.6975719)
        let coordenadasDestino = CLLocationCoordinate2DMake(40.437628,-3.715484)
        
        let origen = MKMapItem(placemark: MKPlacemark(coordinate: coordenadasOrigen))
        let destino = MKMapItem(placemark: MKPlacemark(coordinate: coordenadasDestino))
        
        let peticion = MKDirectionsRequest()
        peticion.transportType = self.transportType!
        
        peticion.source = origen
        peticion.destination = destino
        let indicaciones = MKDirections(request: peticion)
        indicaciones.calculate { (respuesta, error) in
            if let error = error {
                print(error.localizedDescription)
            } else {
            self.mapRoute.add((respuesta?.routes[0].polyline)!)
                
                self.zoomToPolyLine(map: self.mapRoute, polyLine: (respuesta?.routes[0].polyline)!, animated: true)
                
                print(respuesta?.routes[0].expectedTravelTime)
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
        switch sender.selectedSegmentIndex {
        case 0:
            self.transportType = .walking
        case 1:
            self.transportType = .automobile
        default:
            self.transportType = .walking
        }
        self.mapRoute.removeOverlays(self.mapRoute.overlays)
        requestRoute()
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay:
        MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(overlay: overlay)
        renderer.strokeColor = UIColor.red
        renderer.lineWidth = 3
        return renderer
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}
