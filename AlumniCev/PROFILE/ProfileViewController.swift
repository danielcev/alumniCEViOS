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
    @IBOutlet weak var nameLbl: UILabel!

    @IBOutlet weak var usernameLbl: UILabel!

    @IBOutlet weak var descriptionTxV: UITextView!
    
    @IBOutlet weak var logoutBtn: UIButton!
    
    @IBOutlet weak var phonePrivacityLbl: UILabel!
    @IBOutlet weak var localizationPrivacityLbl: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imgProfile.contentMode = .scaleAspectFill
        imgProfile.layer.masksToBounds = true

        logoutBtn.layer.cornerRadius = logoutBtn.layer.frame.height / 2

    }
    
    override func viewWillAppear(_ animated: Bool) {
        setValues()
        cheeckPrivacity()
    }
    
    func cheeckPrivacity(){
        let phonePrivacity = getDataInUserDefaults(key: "phoneprivacity") == "1" ? "Sí" : "No"
        phonePrivacityLbl.text = phonePrivacity
        
        let localizationPrivacity = getDataInUserDefaults(key: "localizationprivacity") == "1" ? "Sí" : "No"
        localizationPrivacityLbl.text = localizationPrivacity
        
    }

    
    func setValues(){
        
        let name = getDataInUserDefaults(key: "name")
        nameLbl.text = name
        
        let username = getDataInUserDefaults(key: "username")
        usernameLbl.text = username

        if getDataInUserDefaults(key: "description") == nil{
            print("Description nula")
            descriptionTxV.text = "defaulDesc".localized()
        }else{
            print("Description no nula")
            descriptionTxV.text = getDataInUserDefaults(key: "description")
        }
    
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
