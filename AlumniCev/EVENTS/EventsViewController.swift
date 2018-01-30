//
//  EventsViewController.swift
//  AlumniCev
//
//  Created by Daniel Plata on 22/1/18.
//  Copyright © 2018 Victor Serrano. All rights reserved.
//

import UIKit

class EventsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableEvents: UITableView!
    
    @IBOutlet weak var segmentedTypes: UISegmentedControl!
    
    @IBOutlet weak var withoutResults: UILabel!
    
    var idType:Int = 1
    
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
        
        switch(events[indexPath.row]["id_type"] as? String){
            
        case "1"?:
            typeEvent = "Evento"
        case "2"?:
            typeEvent = "Oferta de trabajo"
        case "3"?:
            typeEvent = "Notificación"
        case "4"?:
            typeEvent = "Noticia"
        default:
            typeEvent = ""
        }
        
        cell.typeLbl.text = typeEvent
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("He pulsado la celda \(indexPath.row)")
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "DetailEventViewController") as! DetailEventViewController
        vc.idReceived = indexPath.row
        
        self.present(vc, animated: true, completion: nil)
    }
    
    @IBAction func changedSegmented(_ sender: Any) {
        
        switch((sender as! UISegmentedControl).selectedSegmentIndex){
        case 0:
            idType = 1
        case 1:
            idType = 2
        case 2:
            idType = 3
        case 3:
            idType = 4
        default:
            idType = 1
        }
        requestEvents(type: idType, controller: self)
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

        requestFindEvents(search: (sender as! UITextField).text!, controller: self)
    }
    
    func notResults(){
        withoutResults.isHidden = false
        tableEvents.isHidden = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        withoutResults.isHidden = true
        
        tableEvents.rowHeight = UITableViewAutomaticDimension
        tableEvents.estimatedRowHeight = 209
        
        requestEvents(type: idType, controller: self)

        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
        requestEvents(type: idType, controller: self)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
