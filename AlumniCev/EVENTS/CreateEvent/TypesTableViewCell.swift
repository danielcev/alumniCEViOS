//
//  TypesTableViewCell.swift
//  AlumniCev
//
//  Created by alumnos on 25/1/18.
//  Copyright © 2018 Victor Serrano. All rights reserved.
//

import UIKit

class TypesTableViewCell: UITableViewCell {
    
    @IBOutlet weak var nameTypeLbl: UILabel!
    
    @IBOutlet weak var typeImage: UIImageView!
    
    var idType:Int?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setWhite(){
        nameTypeLbl.textColor = UIColor.white
    }
    
    func setGreen(){
        nameTypeLbl.textColor = cevColor
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        if selected{
            nameTypeLbl.textColor = cevColor
        }else{
            nameTypeLbl.textColor = UIColor.white
        }
        
    }
    

}
