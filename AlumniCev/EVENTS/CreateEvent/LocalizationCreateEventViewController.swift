//
//  LocalizationCreateEventViewController.swift
//  AlumniCev
//
//  Created by alumnos on 24/1/18.
//  Copyright © 2018 Victor Serrano. All rights reserved.
//

import UIKit
import CPAlertViewController

class LocalizationCreateEventViewController: UIViewController {

    @IBOutlet weak var addLocalizationLbl: UILabel!
    
    @IBOutlet weak var localizationTxF: UITextField!
    
    @IBOutlet weak var addressLbl: UILabel!
    
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func createEventAction(_ sender: Any) {

        createEventRequest(title: eventCreated!.titleEvent!, description: eventCreated!.descriptionEvent!, idType: eventCreated!.idTypeEvent!, idGroup: eventCreated!.idsGroups, controller: self, lat: eventCreated!.lat!, lon: (eventCreated?.lon)!)
        
    }
    
    func receiveAddress(addressReceived:Address){
        
        eventCreated?.lat = addressReceived.lat
        eventCreated?.lon = addressReceived.lon
        
        addressLbl.text = addressReceived.formatted_address
        
    }
    
    @IBAction func searchAction(_ sender: Any) {
        
        if(localizationTxF.text != ""){
            requestAddress(address: localizationTxF.text!, controller: self)
        }else{
            let alert = CPAlertViewController()
            alert.showError(title: "Error", message: "Debes introducir la dirección" , buttonTitle: "OK")
        }
 
    }
    
    func createAlert(){
        let alert = CPAlertViewController()
        alert.showSuccess(title: "Evento creado!!", message: "El evento \(eventCreated!.titleEvent!) ha sido creado" , buttonTitle: "OK") { (nil) in
            self.dismiss(animated: true, completion: nil)
        }
    }
}
