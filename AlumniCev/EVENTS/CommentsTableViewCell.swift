//
//  CommentsTableViewCell.swift
//  AlumniCev
//
//  Created by Daniel Plata on 8/2/18.
//  Copyright © 2018 Victor Serrano. All rights reserved.
//

import UIKit

class CommentsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var imageUser: UIImageView!
    @IBOutlet weak var usernameLbl: UILabel!
    @IBOutlet weak var descriptionTxV: UITextView!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
