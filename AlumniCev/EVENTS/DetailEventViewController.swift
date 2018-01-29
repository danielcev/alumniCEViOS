//
//  DetailEventViewController.swift
//  AlumniCev
//
//  Created by alumnos on 23/1/18.
//  Copyright © 2018 Victor Serrano. All rights reserved.
//

import UIKit

class DetailEventViewController: UIViewController {
    
    var idReceived: Int = 0

    @IBOutlet weak var titleLbl: UILabel!
    
    @IBOutlet weak var descriptionLbl: UILabel!

    @IBOutlet weak var localizationbtn: UIButton!
    
    var lat:Float?
    var lon:Float?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(events[idReceived])
        
        lat = Float(events[idReceived]["lat"] as! String)
        lon = Float(events[idReceived]["lon"] as! String)
        
        addressFromPosition(lat: lat!, lon: lon!, controller: self)

        // Do any additional setup after loading the view.
    }
    
    func setEvent(address:Address){
        titleLbl.text = events[idReceived]["title"] as? String
        descriptionLbl.text = events[idReceived]["description"] as? String
        
        localizationbtn.setTitle(address.formatted_address, for: .normal)
        
    }
    
    
    @IBAction func goToLocalization(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "EventLocalizationViewController") as! EventLocalizationViewController
        
        vc.lat = self.lat!
        vc.lon = self.lon!
        
        self.present(vc, animated: true, completion: nil)
    }
    
    
    @IBAction func backAction(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}


