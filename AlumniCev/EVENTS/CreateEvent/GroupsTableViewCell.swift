//
//  GroupsTableViewCell.swift
//  AlumniCev
//
//  Created by alumnos on 25/1/18.
//  Copyright © 2018 Victor Serrano. All rights reserved.
//

import UIKit
import M13Checkbox

class GroupsTableViewCell: UITableViewCell {

    @IBOutlet weak var checkbox: M13Checkbox!
    
    @IBOutlet weak var groupLbl: UILabel!
    
    var idGroup:Int?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    @IBAction func checkAction(_ sender: M13Checkbox) {
        
        if sender.checkState == M13Checkbox.CheckState.checked{
            eventCreated?.idsGroups.append(self.idGroup!)
        }else{
            
            if let firstIndex = eventCreated?.idsGroups.index(of: self.idGroup!) {
                
                eventCreated?.idsGroups.remove(at: firstIndex)
            }
            
        }
    }
    
}
