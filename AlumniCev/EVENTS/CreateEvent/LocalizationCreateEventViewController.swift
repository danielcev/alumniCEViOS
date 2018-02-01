//
//  LocalizationCreateEventViewController.swift
//  AlumniCev
//
//  Created by alumnos on 24/1/18.
//  Copyright © 2018 Victor Serrano. All rights reserved.
//

import UIKit
import CPAlertViewController
import MapKit

class LocalizationCreateEventViewController: UIViewController, MKMapViewDelegate {

    @IBOutlet weak var addLocalizationLbl: UILabel!
    
    @IBOutlet weak var localizationTxF: UITextField!
    
    @IBOutlet weak var addressLbl: UILabel!
    
    @IBOutlet weak var map: MKMapView!
    
    @IBOutlet weak var deleteBtn: UIButton!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        addressLbl.isHidden = true
        map.isHidden = true
        deleteBtn.isHidden = true

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func createEventAction(_ sender: Any) {
        
        var image:Data?
        var url:String?
        
        if eventCreated!.imageEvent != nil{
            image = eventCreated?.imageEvent
        }else{
            image = nil
        }
        
        if eventCreated!.url != nil{
            url = eventCreated!.url
        }else{
            url = nil
        }

        if(eventCreated?.lat == nil && eventCreated?.lon == nil){
            
            createEventRequest(title: eventCreated!.titleEvent!, description: eventCreated!.descriptionEvent!, idType: eventCreated!.idTypeEvent!, idGroup: eventCreated!.idsGroups, controller: self,lat: nil, lon: nil, image: image, url: url)
            
        }else{
            createEventRequest(title: eventCreated!.titleEvent!, description: eventCreated!.descriptionEvent!, idType: eventCreated!.idTypeEvent!, idGroup: eventCreated!.idsGroups, controller: self, lat: eventCreated!.lat!, lon: (eventCreated?.lon)!, image: image, url: url)
        }

    }
    
    func receiveAddress(addressReceived:Address){
        
        eventCreated?.lat = addressReceived.lat
        eventCreated?.lon = addressReceived.lon
        
        addressLbl.text = addressReceived.formatted_address
        
        let latitude:CLLocationDegrees = CLLocationDegrees((eventCreated?.lat)!)
        let longitude:CLLocationDegrees = CLLocationDegrees((eventCreated?.lon)!)
        
        let latDelta:CLLocationDegrees = 0.01
        let longDelta:CLLocationDegrees = 0.01
        
        let span:MKCoordinateSpan = MKCoordinateSpanMake(latDelta, longDelta)
        let location:CLLocationCoordinate2D = CLLocationCoordinate2DMake(latitude, longitude)
        
        let region:MKCoordinateRegion = MKCoordinateRegionMake(location, span)
        
        map.setRegion(region, animated: true)
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = location
        annotation.title = "Prueba"
        annotation.subtitle = "Esto es una prueba"
        
        map.addAnnotation(annotation)
        
        addressLbl.isHidden = false
        map.isHidden = false
        deleteBtn.isHidden = false
        
    }
    
    @IBAction func searchAction(_ sender: Any) {
        
        if(localizationTxF.text != ""){
            requestAddress(address: localizationTxF.text!, controller: self)
        }else{
            let alert = CPAlertViewController()
            alert.showError(title: "Error", message: "Debes introducir la dirección" , buttonTitle: "OK")
        }
 
    }
    
    
    @IBAction func deleteAction(_ sender: Any) {
        eventCreated?.lat = nil
        eventCreated?.lon = nil
        
        addressLbl.isHidden = true
        deleteBtn.isHidden = true
        map.isHidden = true
        localizationTxF.text = ""
    }
    
    func createAlert(){
        let alert = CPAlertViewController()
        alert.showSuccess(title: "Evento creado!!", message: "El evento \(eventCreated!.titleEvent!) ha sido creado" , buttonTitle: "OK") { (nil) in
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    //función para ocultar el teclado cuando pulsas fuera de él
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}
