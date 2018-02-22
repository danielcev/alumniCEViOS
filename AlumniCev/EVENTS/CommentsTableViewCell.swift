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
    
    var controller:CommentsViewController?
    var idComment:Int?
    
    @IBOutlet weak var deleteBtn: UIButton!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    @IBAction func deleteCommentAction(_ sender: Any) {
        
        let alert = UIAlertController(title: "Borrar comentario", message: "¿Seguro que quieres borrar el comentario?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancelar", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Borrar", style: .destructive, handler: { (nil) in
            
            requestDeleteComment(id_comment: self.idComment!, action: {
                
                
                self.controller?.reloadTable()
                //self.controller?.dismiss(animated: true, completion: nil)
            })
        }))
        
        controller?.present(alert, animated: true)


    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
