//
//  ProfileViewController.swift
//  AlumniCev
//
//  Created by Daniel Plata on 22/1/18.
//  Copyright © 2018 Victor Serrano. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {
    
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var emailLb: UILabel!
    @IBOutlet weak var imgProfile: UIImageView!
    @IBOutlet weak var phoneLB: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()

        let name = getDataInUserDefaults(key: "name")
        nameLbl.text = name
        
        let email = getDataInUserDefaults(key: "email")
        emailLb.text = email
        
        let phone = getDataInUserDefaults(key: "phone")
        phoneLB.text = phone
        
        
        getPhoto()
        
        // Do any additional setup after loading the view.
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

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
