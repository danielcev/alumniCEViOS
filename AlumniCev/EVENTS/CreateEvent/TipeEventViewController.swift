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
        return 78
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "typesCell", for: indexPath) as! TypesTableViewCell
        
        cell.nameTypeLbl.text = types[indexPath.row]["name"]
        cell.idType = Int(types[indexPath.row]["id"]!)
   
        return cell
    }

    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let cell = tableView.cellForRow(at: indexPath) as? TypesTableViewCell {
            eventCreated?.idTypeEvent = cell.idType
        }
        
    }
    
    func rechargeTable(){
        typesTable.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        requestTypes(controller:self)
    
        // Do any additional setup after loading the view.
    }
   


}
