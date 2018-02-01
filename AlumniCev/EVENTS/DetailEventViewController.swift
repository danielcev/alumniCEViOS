//
//  DetailEventViewController.swift
//  AlumniCev
//
//  Created by alumnos on 23/1/18.
//  Copyright © 2018 Victor Serrano. All rights reserved.
//

import UIKit
import Alamofire

class DetailEventViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var idReceived: Int = 0

    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var secondTitleLbl: UILabel!
    
    @IBOutlet weak var descriptionText: UITextView!
    
    @IBOutlet weak var imageViewEvent: UIImageView!
    
    @IBOutlet weak var localizationbtn: UIButton!
    
    @IBOutlet weak var urlBtn: UIButton!
    
    var lat:Float?
    var lon:Float?
    
    @IBOutlet weak var tableComments: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        requestEvent(id:Int(events[idReceived]["id"] as! String)!, controller:self)
        
        imageViewEvent.clipsToBounds = true
        imageViewEvent.contentMode = .scaleAspectFit
        
        //Solo se muestra la información de localización si el evento la tiene
        if((events[idReceived]["lat"] as? String) != nil && (events[idReceived]["lon"] as? String) != nil){
        
            lat = Float(events[idReceived]["lat"] as! String)
            lon = Float(events[idReceived]["lon"] as! String)
            
            addressFromPosition(lat: lat!, lon: lon!, controller: self)
        }else{
            localizationbtn.isHidden = true
            
            setInfoEvent()
        }
        
        if events[idReceived]["url"] as? String == nil{
            urlBtn.isHidden = true
        }
        
        if events[idReceived]["image"] as? String == nil{
            switch events[idReceived]["id_type"] as! String {
            case "1":
                imageViewEvent.image = UIImage(named: "eventimage")
            case "2":
                imageViewEvent.image = UIImage(named: "jobofferimage")
            case "3":
                imageViewEvent.image = UIImage(named: "notificationimage")
            case "4":
                imageViewEvent.image = UIImage(named: "newsimage")
            default:
                imageViewEvent.image = UIImage(named: "eventimage")
            }
        }else{
            requestImage(url: (events[idReceived]["image"] as? String)!)
        }
        
        switch events[idReceived]["id_type"] as! String {
        case "1":
            titleLbl.text = "Event"
        case "2":
            titleLbl.text = "Job offer"
        case "3":
            titleLbl.text = "Notification"
        case "4":
            titleLbl.text = "Notice"
        default:
            titleLbl.text = "Event"
        }

        // Do any additional setup after loading the view.
    }
    
    func setEvent(address:Address){
    
        localizationbtn.setTitle(address.formatted_address, for: .normal)
        
        urlBtn.setTitle(events[idReceived]["url"] as? String, for: .normal)
        setInfoEvent()
    }
    
    func setInfoEvent(){
        secondTitleLbl.text = events[idReceived]["title"] as? String
        descriptionText.text = events[idReceived]["description"] as? String
    }
    
    
    @IBAction func goToLocalization(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "EventLocalizationViewController") as! EventLocalizationViewController
        
        vc.lat = self.lat!
        vc.lon = self.lon!
        vc.titleEvent = (events[idReceived]["title"] as? String)!
        
        self.present(vc, animated: true, completion: nil)
    }
    
    
    @IBAction func backAction(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func requestImage(url:String){
        let remoteImageURL = URL(string: url)!
        
        // Use Alamofire to download the image
        Alamofire.request(remoteImageURL).responseData { (response) in
            if response.error == nil {
                print(response.result)
                
                if let data = response.data {
                    self.imageViewEvent.image = UIImage(data: data)
                }
            }
        }
    }
    
    //TABLE COMMENTS
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if comments != nil{
            return comments!.count
        }else{
            return 0
        }
 
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 169
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "commentCell", for: indexPath) as! DetailCommentsTableViewCell
        
        var comment:Dictionary<String,Any> = (comments![String(describing: indexPath.row + 1)]! as! Dictionary<String,Any>)
        
        if(comments != nil){
            cell.titleComment.text = comment["title"] as? String
            
            cell.descriptionComment.text = comment["description"] as? String
        }
        
        return cell
    }
    
    func reloadTable(){
        tableComments.reloadData()
    }
    
}


