//
//  UserDetailViewController.swift
//  AlumniCev
//
//  Created by Daniel Plata on 7/2/18.
//  Copyright © 2018 Victor Serrano. All rights reserved.
//

import UIKit

class UserDetailViewController: UIViewController {
    
    @IBOutlet weak var usernameLbl: UILabel!
    @IBOutlet weak var imgUser: UIImageView!
    @IBOutlet weak var nameTitle: UILabel!
    @IBOutlet weak var nameLB: UILabel!
    @IBOutlet weak var DescripTitlfe: UILabel!
    @IBOutlet weak var descripTxt: UITextView!
    @IBOutlet weak var direcTitle: UILabel!
    @IBOutlet weak var direcLB: UILabel!
    @IBOutlet weak var mailBtn: UIButton!
    @IBOutlet weak var phoneTitle: UILabel!
    @IBOutlet weak var phoneLB: UILabel!
    @IBOutlet weak var PhoneBtn: UIButton!
    @IBOutlet weak var localTitle: UILabel!
    @IBOutlet weak var localLB: UILabel!
    @IBOutlet weak var localBtn: UIButton!
    @IBOutlet weak var userTitle: UILabel!
    @IBOutlet weak var userLB: UILabel!
    @IBOutlet weak var userBtn: UIButton!
    @IBOutlet weak var addFriendsBtn: UIButton!
    
    var user:Dictionary<String,Any>?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addFriendsBtn.setTitle("addFriend".localized(), for: .normal)
        nameTitle.text = "myName".localized()
        DescripTitlfe.text = "myDescrip".localized()
        direcTitle.text = "myMail".localized()
        phoneTitle.text = "myNum".localized()
        localTitle.text = "myLoc".localized()
        userTitle.text = "myUserName".localized()
        
        
        print("Este es el diccionario de usuarios: \(String(describing: user))")
        
        usernameLbl.text = user?["username"] as? String
        nameLB.text = user?["username"] as? String
        direcLB.text = user?["email"] as? String
        userLB.text = user?["username"] as? String
        
        if user?["phone"] as? String != nil{
            phoneLB.text = user?["phone"] as? String
        }
        
        if user?["description"] as? String == nil{
            descripTxt.text =  "defaulDesc".localized()
        }else{
            descripTxt.text = user?["description"] as! String
        }
        
        
        if user?["lat"] as? String != nil && user?["lon"] as? String != nil {
            
            
        }
        
        
    }
    
    @IBAction func backAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func addFriend(_ sender: Any) {
        
        
        let newFriend = user?["id"] as! String
        
        sendRequestFriend(id_user: Int(newFriend)!) {
            self.addFriendsBtn.setTitle("Petición enviada", for: .normal)
        }
        
        
    }

}
