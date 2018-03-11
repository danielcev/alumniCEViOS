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
    
    @IBOutlet weak var shareLocalizationLbl: UILabel!
    @IBOutlet weak var sharePhoneLbl: UILabel!
    @IBOutlet weak var editNavBarBtn: UINavigationItem!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imgProfile.contentMode = .scaleAspectFill
        imgProfile.layer.masksToBounds = true

        logoutBtn.layer.cornerRadius = logoutBtn.layer.frame.height / 2
        
        shareLocalizationLbl.text = "localizSettings".localized()
        sharePhoneLbl.text = "phoneSettings".localized()
        
        
        //editBtn.setTitle("edit".localized(), for: .normal)

    }
    
    override func viewWillAppear(_ animated: Bool) {
        setValues()
        cheeckPrivacity()
    }
    
    func cheeckPrivacity(){
        let phonePrivacity = getDataInUserDefaults(key: "phoneprivacity") == "1" ? "yes".localized() : "no".localized()
        phonePrivacityLbl.text = phonePrivacity
        
        let localizationPrivacity = getDataInUserDefaults(key: "localizationprivacity") == "1" ? "yes".localized() : "no".localized()
        localizationPrivacityLbl.text = localizationPrivacity
        
    }

    
    func setValues(){
        
        let name = getDataInUserDefaults(key: "name")
        nameLbl.text = name
        
        let username = getDataInUserDefaults(key: "username")
        usernameLbl.text = username

        if getDataInUserDefaults(key: "description") == nil{
            descriptionTxV.text = "defaulDesc".localized()
        }else{
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
    
    @objc func goToSettings() {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "SettingsViewController") as! SettingsViewController
        vc.modalTransitionStyle = .flipHorizontal
        self.present(vc, animated: true)
    }

    @IBAction func logoutAction(_ sender: UIButton) {
        clearUserDefaults()
        self.view.window!.rootViewController?.dismiss(animated: true, completion: nil)
        
    }

}
