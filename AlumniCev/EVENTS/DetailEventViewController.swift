//
//  DetailEventViewController.swift
//  AlumniCev
//
//  Created by alumnos on 23/1/18.
//  Copyright © 2018 Victor Serrano. All rights reserved.
//

import UIKit
import GoogleMaps

class DetailEventViewController: UIViewController {
    
    var idReceived: Int = 0

    @IBOutlet weak var titleLbl: UILabel!
    
    @IBOutlet weak var descriptionLbl: UILabel!
    
    @IBOutlet weak var map: GMSMapView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setEvent()
        
        
        

    
        // Do any additional setup after loading the view.
    }
    
    func setEvent(){
        titleLbl.text = events[idReceived]["title"] as? String
        descriptionLbl.text = events[idReceived]["description"] as? String
        
        if let lt = events[idReceived]["lat"] as? String{
            if let ln = events[idReceived]["lon"] as? String{
                
                let lat = Float(lt)
                let lon = Float(ln)
            
                let camera = GMSCameraPosition.camera(withLatitude: CLLocationDegrees(lat!), longitude: CLLocationDegrees(lon!), zoom: 15)
                map.camera = camera
                
                let marker = GMSMarker()
                marker.position = camera.target
                marker.title = events[idReceived]["title"] as? String
                marker.snippet = events[idReceived]["description"] as? String
                marker.map = map
            }else{
                map.isHidden = true
            }
            
        }else{
            map.isHidden = true
        }
        
        
    }
    
    
    @IBAction func backAction(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}


