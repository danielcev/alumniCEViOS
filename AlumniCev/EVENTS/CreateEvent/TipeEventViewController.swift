//
//  TipeEventViewController.swift
//  AlumniCev
//
//  Created by alumnos on 24/1/18.
//  Copyright © 2018 Victor Serrano. All rights reserved.
//

import UIKit

class TipeEventViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var typeLbl: UILabel!
    
    @IBOutlet weak var typesTable: UITableView!

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return types.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 127
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "typesCell", for: indexPath) as! TypesTableViewCell
        
        cell.nameTypeLbl.text = types[indexPath.row]["name"]
        cell.idType = Int(types[indexPath.row]["id"]!)

        switch Int(types[indexPath.row]["id"]!) {
        case 1?:
            cell.typeImage.image = UIImage(named: "eventimage")
            cell.setSelected(true, animated: false)
            cell.setGreen()
        case 2?:
            cell.typeImage.image = UIImage(named: "jobofferimage")
        case 3?:
            cell.typeImage.image = UIImage(named: "notificationimage")
        case 4?:
            cell.typeImage.image = UIImage(named: "newsimage")
        default:
            cell.typeImage.image = UIImage(named: "eventimage")
        }
   
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let cell = tableView.cellForRow(at: indexPath) as? TypesTableViewCell {
            eventCreated?.idTypeEvent = cell.idType
            cell.setGreen()
        }

    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) as? TypesTableViewCell {
            cell.setWhite()
        }
    }
    
    func rechargeTable(){
        typesTable.reloadData()
    }
    
    @IBAction func backAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        requestTypes(controller:self)
        
        typeLbl.text = "typeEvent".localized()
       
    }
   
}
