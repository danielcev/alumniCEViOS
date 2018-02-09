//
//  EventsViewController.swift
//  AlumniCev
//
//  Created by Daniel Plata on 22/1/18.
//  Copyright © 2018 Victor Serrano. All rights reserved.
//

import UIKit
import SimpleAnimation
import Alamofire

class EventsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableEvents: UITableView!
    
    @IBOutlet weak var segmentedTypes: UISegmentedControl!
    
    @IBOutlet weak var searchTxF: UITextField!
    
    @IBOutlet weak var withoutResults: UILabel!
    
    @IBOutlet weak var ocultView: UIView!
    @IBOutlet weak var cancelBtn: UIButton!
    
    @IBOutlet weak var filterBtn: UIButton!
    var selectedtypebtn:UIButton?
    
    @IBOutlet weak var allTypesBtn: UIButton!
    
    @IBOutlet weak var typeEventLbl: UILabel!
    var idType:Int = 0
    
    @IBOutlet weak var menuView: UIView!
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return events.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 170
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "myCell", for: indexPath) as! EventTableViewCell
        
        cell.titleLbl.text = events[indexPath.row]["title"] as? String
        cell.descriptionLbl.text = events[indexPath.row]["description"] as? String
        
        var typeEvent = ""
        var color:UIColor?
        
        switch(events[indexPath.row]["id_type"] as? String){
            
        case "1"?:
            typeEvent = "Evento"
            color = UIColor.red.withAlphaComponent(0.4)
            
        case "2"?:
            typeEvent = "Oferta de trabajo"
            color = UIColor.purple.withAlphaComponent(0.4)
        case "3"?:
            typeEvent = "Notificación"
            color = UIColor.blue.withAlphaComponent(0.4)
        case "4"?:
            typeEvent = "Noticia"
            color = UIColor.yellow.withAlphaComponent(0.4)
        default:
            typeEvent = ""
            color = UIColor.red.withAlphaComponent(0.4)
        }
        
        if events[indexPath.row]["image"] as? String != nil{
            //Añadir imagen
            let remoteImageURL = URL(string: (events[indexPath.row]["image"] as? String)!)!
            
            Alamofire.request(remoteImageURL).responseData { (response) in
                if response.error == nil {
                    print(response.result)
                    
                    if let data = response.data {
                        cell.imageEventView.image = UIImage(data: data)
                    }
                }
            }
        }else{
            switch(events[indexPath.row]["id_type"] as? String){
                
            case "1"?:
                cell.imageEventView.image = UIImage(named: "eventimage")
            case "2"?:
                cell.imageEventView.image = UIImage(named: "jobofferimage")
            case "3"?:
                cell.imageEventView.image = UIImage(named: "notificationimage")
            case "4"?:
                cell.imageEventView.image = UIImage(named: "newsimage")
            default:
                cell.imageEventView.image = UIImage(named: "eventimage")
            }
        }
        
        cell.imageEventView.contentMode = .scaleAspectFill
        cell.imageEventView.layer.masksToBounds = true
        
        cell.typeLbl.text = typeEvent
        //cell.typeLbl.backgroundColor = color
        cell.backgroundCell.backgroundColor = color
        cell.typeLbl.layer.cornerRadius = 15.0
        cell.typeLbl.layer.masksToBounds = true
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("He pulsado la celda \(indexPath.row)")
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "DetailEventViewController") as! DetailEventViewController
        vc.idReceived = indexPath.row
        
        self.present(vc, animated: true, completion: nil)
    }
    
    @IBAction func goToCreate(_ sender: Any) {
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "CreateEventPageViewController") as! CreateEventPageViewController
        
        self.present(vc, animated: true, completion: nil)
    }
    
    func reloadTable(){
        tableEvents.reloadData()
        tableEvents.isHidden = false
        withoutResults.isHidden = true
    }
    
    @IBAction func changeTextAction(_ sender: Any) {
        
        if (sender as! UITextField).text! == ""{
            requestEvents(type: idType, controller: self)
        }else{
            requestFindEvents(search: (sender as! UITextField).text!,type: idType, controller: self)
        }
        
    }
    
    func notResults(){
        withoutResults.isHidden = false
        tableEvents.isHidden = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        selectedtypebtn = allTypesBtn
        
        allTypesBtn.backgroundColor = cevColor
        allTypesBtn.setTitleColor(UIColor.white, for: .normal)
        typeEventLbl.text = "Todos"
        
        menuView.isHidden = true
        ocultView.isHidden = true
        
        menuView.layer.cornerRadius = 15.0
        menuView.layer.masksToBounds = true
        cancelBtn.layer.cornerRadius = 15.0
        cancelBtn.layer.masksToBounds = true
        filterBtn.layer.cornerRadius = 15.0
        filterBtn.layer.masksToBounds = true
        
        withoutResults.isHidden = true
        
        tableEvents.rowHeight = UITableViewAutomaticDimension
        tableEvents.estimatedRowHeight = 209
        
        requestEvents(type: idType, controller: self)
        
        tableEvents.separatorStyle = .none

        // Do any additional setup after loading the view.
    }

    
    override func viewWillAppear(_ animated: Bool) {
        requestEvents(type: idType, controller: self)
    }
    @IBAction func filterAction(_ sender: Any) {
        menuView.isHidden = false
        menuView.bounceIn(from: .top)
        
        ocultView.isHidden = false
        
    }
    
    @IBAction func changeType(_ sender: UIButton) {
        
        if selectedtypebtn != nil{
            selectedtypebtn!.tintColor = cevColor
            selectedtypebtn!.backgroundColor = UIColor.white
            selectedtypebtn!.setTitleColor(cevColor, for: .normal)
        }
        
        selectedtypebtn = sender
        
        idType = sender.tag
        sender.backgroundColor = cevColor
        sender.setTitleColor(UIColor.white, for: .normal)
        
        if searchTxF.text == ""{
            requestEvents(type: idType, controller: self)
        }else{
            requestFindEvents(search: searchTxF.text!, type: idType, controller: self)
        }

        var textTypeEvent = ""
        
        switch(idType){
        case 0:
            textTypeEvent = "Todos"
        case 1:
            textTypeEvent = "Eventos"
        case 2:
            textTypeEvent = "Ofertas de trabajo"
        case 3:
            textTypeEvent = "Notificaciones"
        case 4:
            textTypeEvent = "Noticias"
        default:
            textTypeEvent = ""
        }
        
        typeEventLbl.text = textTypeEvent
        
        closeMenu(sender)
        
    }
    
    @IBAction func closeMenu(_ sender: Any) {
        menuView.bounceOut(to: .top)
        //menuView.isHidden = true
        ocultView.isHidden = true
    }

    //función para ocultar el teclado cuando pulsas fuera de él
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }

}
