//
//  UserDetailViewController.swift
//  AlumniCev
//
//  Created by Daniel Plata on 7/2/18.
//  Copyright © 2018 Victor Serrano. All rights reserved.
//

import UIKit
import Alamofire

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
        
        requestUserById(id: Int(user?["id"] as! String)!) {
            self.setBtn()
        }
        
        addFriendsBtn.setTitle("addFriend".localized(), for: .normal)
        nameTitle.text = "myName".localized()
        DescripTitlfe.text = "myDescrip".localized()
        direcTitle.text = "myMail".localized()
        phoneTitle.text = "myNum".localized()
        localTitle.text = "myLoc".localized()
        userTitle.text = "myUserName".localized()
        
        usernameLbl.text = user?["name"] as? String
        nameLB.text = user?["name"] as? String
        direcLB.text = user?["email"] as? String
        userLB.text = user?["username"] as? String
        
        if user!["photo"] as? String != nil{
            //Añadir imagen
            let remoteImageURL = URL(string: (user!["photo"] as? String)!)!
            
            Alamofire.request(remoteImageURL).responseData { (response) in
                if response.error == nil {
                    print(response.result)
                    
                    if let data = response.data {
                        self.imgUser.image = UIImage(data: data)
                    }
                }
            }
        }else{
            imgUser.image = #imageLiteral(resourceName: "userdefaulticon")
        }
        
        imgUser.contentMode = .scaleAspectFill
        imgUser.layer.cornerRadius = imgUser.bounds.height/2
        imgUser.layer.masksToBounds = true
        
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
    
    func setBtn(){
        
        if friend != nil{
            if friend!["state"] as! String == "2" {
                
                addFriendsBtn.setTitle("Eliminar amistad", for: .normal)
                
            }else{
                
                if friend!["id_user_send"] as? Int == Int((user?["id"] as? String)!){
                    addFriendsBtn.setTitle("Aceptar petición", for: .normal)
                }else{
                    addFriendsBtn.setTitle("Cancelar petición enviada", for: .normal)
                }
                
            }
        }else{
            addFriendsBtn.setTitle("Enviar petición de amistad", for: .normal)
        }
        
    }
    
    @IBAction func backAction(_ sender: Any) {
        friend = nil
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func addFriend(_ sender: Any) {
        
        
        let newFriend = user?["id"] as! String
        
        sendRequestFriend(id_user: Int(newFriend)!) {
            self.addFriendsBtn.setTitle("Petición enviada", for: .normal)
        }
        
        
    }

}
