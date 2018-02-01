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
import SwiftSpinner

class LocalizationCreateEventViewController: UIViewController, MKMapViewDelegate {

    @IBOutlet weak var addLocalizationLbl: UILabel!
    
    @IBOutlet weak var localizationTxF: UITextField!
    
    @IBOutlet weak var addressLbl: UILabel!
    
    @IBOutlet weak var map: MKMapView!
    
    var lat:Float?
    var lon:Float?
    
    @IBOutlet weak var deleteBtn: UIButton!
    
    @IBOutlet weak var addBtn: UIButton!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        addressLbl.isHidden = true
        map.isHidden = true
        deleteBtn.isHidden = true
        addBtn.isHidden = true

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func createEventAction(_ sender: Any) {
        
        if eventCreated!.idTypeEvent == nil{
            createAlert(type: "error", title: "Faltan datos", message: "Falta selecciona el tipo de evento")
            return
        }
        
        if eventCreated!.idsGroups.count == 0{
            createAlert(type: "error", title: "Faltan datos", message: "Falta seleccionar los grupos")
            return
        }
        
        if eventCreated?.titleEvent == nil{
            createAlert(type: "error", title: "Faltan datos", message: "Es necesario el título del evento")
            return
        }
        
        if (eventCreated?.titleEvent?.count)! > 100{
            createAlert(type: "error", title: "Exceso caracteres", message: "El título es demasiado largo")
            return
        }
        
        if (eventCreated?.descriptionEvent?.count)! > 1000{
            createAlert(type: "error", title: "Exceso caracteres", message: "La descripción es demasiado larga")
            return
        }
        
        if eventCreated?.descriptionEvent == nil{
            createAlert(type: "error", title: "Faltan datos", message: "Es necesario la descripción del evento")
            return
        }
        
        
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
            SwiftSpinner.show("...")
            
            createEventRequest(title: eventCreated!.titleEvent!, description: eventCreated!.descriptionEvent!, idType: eventCreated!.idTypeEvent!, idGroup: eventCreated!.idsGroups, controller: self,lat: nil, lon: nil, image: image, urlEvent: url)
            
            
        }else{
            SwiftSpinner.show("...")
            
            createEventRequest(title: eventCreated!.titleEvent!, description: eventCreated!.descriptionEvent!, idType: eventCreated!.idTypeEvent!, idGroup: eventCreated!.idsGroups, controller: self, lat: eventCreated!.lat!, lon: (eventCreated?.lon)!, image: image, urlEvent: url)
        }

    }
    
    func receiveAddress(addressReceived:Address){
        
        self.lat = addressReceived.lat
        self.lon = addressReceived.lon
        
        addressLbl.text = addressReceived.formatted_address
        
        let latitude:CLLocationDegrees = CLLocationDegrees((addressReceived.lat)!)
        let longitude:CLLocationDegrees = CLLocationDegrees((addressReceived.lon)!)
        
        let latDelta:CLLocationDegrees = 0.01
        let longDelta:CLLocationDegrees = 0.01
        
        let span:MKCoordinateSpan = MKCoordinateSpanMake(latDelta, longDelta)
        let location:CLLocationCoordinate2D = CLLocationCoordinate2DMake(latitude, longitude)
        
        let region:MKCoordinateRegion = MKCoordinateRegionMake(location, span)
        
        map.setRegion(region, animated: true)
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = location
        annotation.title = addressReceived.formatted_address
        
        map.addAnnotation(annotation)
        
        addressLbl.isHidden = false
        map.isHidden = false
        deleteBtn.isHidden = false
        addBtn.isHidden = false
    }
    
    @IBAction func searchAction(_ sender: Any) {
        
        if(localizationTxF.text != ""){
            requestAddress(address: localizationTxF.text!, controller: self)
        }else{
            let alert = CPAlertViewController()
            alert.showError(title: "Error", message: "Debes introducir la dirección" , buttonTitle: "OK")
        }
 
    }
    
    @IBAction func addUbication(_ sender: Any) {
        eventCreated?.lat = self.lat
        eventCreated?.lon = self.lon
        
        var alert = CPAlertViewController()
        
        alert.showSuccess(title: "Ubicación agregada", message: "Localización añadida al evento" , buttonTitle: "OK")
    }
    
    @IBAction func deleteAction(_ sender: Any) {
        eventCreated?.lat = nil
        eventCreated?.lon = nil
        
        self.lat = nil
        self.lon = nil
        
        addressLbl.isHidden = true
        deleteBtn.isHidden = true
        addBtn.isHidden = true
        map.isHidden = true
        localizationTxF.text = ""
    }
    
    func createAlert(type:String, title:String, message:String){
        let alert = CPAlertViewController()
        
        SwiftSpinner.hide()
        
        if type == "success"{
            alert.showSuccess(title: title, message: message , buttonTitle: "OK") { (nil) in
                self.dismiss(animated: true, completion: nil)
            }
        }else{
            alert.showError(title: title, message: message , buttonTitle: "OK")
            
        }
        
    }
    
    //función para ocultar el teclado cuando pulsas fuera de él
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}
