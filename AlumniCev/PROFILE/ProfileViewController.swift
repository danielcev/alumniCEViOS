//
//  ProfileViewController.swift
//  AlumniCev
//
//  Created by Daniel Plata on 22/1/18.
//  Copyright © 2018 Victor Serrano. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {
    
    @IBOutlet weak var imgProfile: UIImageView!
    
    @IBOutlet weak var nameTitleLbl: UILabel!
    @IBOutlet weak var nameLbl: UILabel!
    
    @IBOutlet weak var usernameTitleLbl: UILabel!
    @IBOutlet weak var usernameLbl: UILabel!
    
    @IBOutlet weak var emailTitleLbl: UILabel!
    @IBOutlet weak var emailLbl: UILabel!
    
    @IBOutlet weak var phoneTitleLbl: UILabel!
    @IBOutlet weak var phoneLbl: UILabel!
    
    @IBOutlet weak var descriptionTitleLbl: UILabel!
    @IBOutlet weak var descriptionTxV: UITextView!
    
    @IBOutlet weak var logoutBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imgProfile.contentMode = .scaleAspectFill
        imgProfile.layer.masksToBounds = true

        logoutBtn.layer.cornerRadius = logoutBtn.layer.frame.height / 2
        
        

    }
    
    override func viewWillAppear(_ animated: Bool) {
        setTitles()
        setValues()
    }
    
    func setValues(){
        
        let name = getDataInUserDefaults(key: "name")
        nameLbl.text = name
        
        let username = getDataInUserDefaults(key: "username")
        usernameLbl.text = username
        
        let email = getDataInUserDefaults(key: "email")
        emailLbl.text = email
        
        let phone = getDataInUserDefaults(key: "phone")
        phoneLbl.text = phone
        
        if getDataInUserDefaults(key: "description") == nil{
            descriptionTxV.text = "defaulDesc".localized()
        }else{
            descriptionTxV.text = getDataInUserDefaults(key: "description")
        }
    
    }
    
    func setTitles(){
        nameTitleLbl.text = "fullName".localized()
        usernameTitleLbl.text = "username".localized()
        emailTitleLbl.text = "emailSettings".localized()
        phoneTitleLbl.text = "MyPhone".localized()
        descriptionTitleLbl.text = "descriptSettings".localized()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        getPhoto()
    }
    
    func getPhoto(){
        
        if getDataInUserDefaults(key: "photo") != nil{
            imgProfile.image = UIImage(data: Data(base64Encoded: getDataInUserDefaults(key: "photo")!)!)
        }else{
            
            imgProfile.image = #imageLiteral(resourceName: "userdefaulticon")
        }
        
        imgProfile.layer.cornerRadius = imgProfile.frame.size.height/2
        imgProfile.layer.masksToBounds = true
    
    }
    
    @IBAction func goToSettings(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "SettingsViewController") as! SettingsViewController
        vc.modalTransitionStyle = .flipHorizontal
        self.present(vc, animated: true)
    }

    @IBAction func logoutAction(_ sender: UIButton) {
        clearUserDefaults()
        self.view.window!.rootViewController?.dismiss(animated: true, completion: nil)
        
    }

}
