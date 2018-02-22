//
//  UserDetailViewController.swift
//  AlumniCev
//
//  Created by Daniel Plata on 7/2/18.
//  Copyright © 2018 Victor Serrano. All rights reserved.
//

import UIKit
import Alamofire
import MessageUI
import CoreLocation


class UserDetailViewController: UIViewController, MFMailComposeViewControllerDelegate {
    
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
        requestUserById(id: Int(user?["id"] as! String)!) {
            self.setBtn()
            
            if self.user?["phone"] as? String != nil && privacityUser!["phone"] == "1"{
                self.phoneLB.text = self.user?["phone"] as? String
            }else{
                self.PhoneBtn.isEnabled = false
            }
            
            if self.user?["lat"] as? String != nil && self.user?["lon"] as? String != nil && privacityUser!["localization"] == "1"{
                self.DistanceFriend()
            }else{
                self.localBtn.isEnabled = false
            }
            
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
        
    
        if user?["description"] as? String == nil{
            descripTxt.text =  "defaulDesc".localized()
        }else{
            descripTxt.text = user?["description"] as! String
        }

    }
//
//    func setInfo(){
//
//        nameTitle.text = "myName".localized()
//        DescripTitlfe.text = "myDescrip".localized()
//        direcTitle.text = "myMail".localized()
//        phoneTitle.text = "myNum".localized()
//        localTitle.text = "myLoc".localized()
//        userTitle.text = "myUserName".localized()
//
//        usernameLbl.text = user?["name"] as? String
//        nameLB.text = user?["name"] as? String
//        direcLB.text = user?["email"] as? String
//        userLB.text = user?["username"] as? String
//
//
//        imgUser.contentMode = .scaleAspectFill
//        imgUser.layer.cornerRadius = imgUser.bounds.height/2
//        imgUser.layer.masksToBounds = true
//
//        if user?["phone"] as? String != nil{
//            phoneLB.text = user?["phone"] as? String
//        }
//
//        if user?["description"] as? String == nil{
//            descripTxt.text =  "defaulDesc".localized()
//        }else{
//            descripTxt.text = user?["description"] as! String
//        }
//
//        if user?["lat"] as? String != nil && user?["lon"] as? String != nil {
//
//        }
//    }
    
    func setBtn(){
        
        if friend != nil{
            if Int(friend!["state"] as! String) == 2 {
                
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
    
    @IBAction func addFriend(_ sender: Any) {
        
        let newFriend = user?["id"] as! String
        
        if friend == nil{
            
            sendRequestFriend(id_user: Int(newFriend)!) {
                self.addFriendsBtn.setTitle("Eliminar petición enviada", for: .normal)
            }
            
        }else{
            
            if friend!["state"] as! String == "2" {
        
                //Eliminar amistad
                requestDeleteFriend(id_user: Int(newFriend)!, action: {
                    self.viewDidLoad()
                })
               
            }else{
                
                if friend!["id_user_send"] as? Int == Int((user?["id"] as? String)!){
                    //Aceptar petición
                    requestResponseFriend(id_user: Int(newFriend)!, type: 2, action: {
                        self.viewDidLoad()
                    })
                }else{
                    //Cancelar petición enviada
                    
                }
                
            }
            
        }
    
    }
    
    @IBAction func mailSender(_ sender: Any) {
        let mailComposeViewController = configuredMailComposeViewController()
        if MFMailComposeViewController.canSendMail() {
            self.present(mailComposeViewController, animated: true, completion: nil)
        } else {
            self.showSendMailErrorAlert()
        }
        
    }
    func configuredMailComposeViewController() -> MFMailComposeViewController {
        let mailComposerVC = MFMailComposeViewController()
        mailComposerVC.mailComposeDelegate = self as? MFMailComposeViewControllerDelegate // Extremely important to set the --mailComposeDelegate-- property, NOT the --delegate-- property
        
        mailComposerVC.setToRecipients([direcLB.text!])

        mailComposerVC.setSubject("IOS test")
        mailComposerVC.setMessageBody("Hello word!", isHTML: false)
        
        return mailComposerVC
    }
    
    func showSendMailErrorAlert() {
        let sendMailErrorAlert = UIAlertView(title: "Unable to Send Email", message: "Your device could not send e-mail.  Please check e-mail configuration and try again.", delegate: self, cancelButtonTitle: "OK")
        sendMailErrorAlert.show()
        self.dismiss(animated: true, completion: nil)
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
        
    }
    
    @IBAction func OpendWhatsappAction(_ sender: Any) {
        var thePhone =  phoneLB.text
        print("***************************")
        print(thePhone)
        if  phoneLB.text != ""{
            UIApplication.shared.openURL(URL(string:"https://api.whatsapp.com/send?phone=34\(thePhone!)")!)
        }else{
            print("Este usuario no tiene numero de telefono")
        }
    }
    
    
    @IBAction func backAction(_ sender: Any) {
        friend = nil
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func OpendTheChat(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "ChatViewController") as! ChatViewController
        self.present(vc, animated: true)
    }
    
    func DistanceFriend(){
        if user?["privacity"] as? String != "" {
            
            let Friendcoordinate = CLLocation(latitude: (user?["lat"] as! NSString).doubleValue , longitude: (user?["lon"] as! NSString).doubleValue)
            let Mycoordinate = CLLocation(latitude: (getDataInUserDefaults(key: "lat") as! NSString).doubleValue , longitude: (getDataInUserDefaults(key: "lon")as! NSString).doubleValue)
            var distanceInMeters = Friendcoordinate.distance(from: Mycoordinate) // result is in meters≤
            
            let formatter = NumberFormatter()
            formatter.numberStyle = .decimal
            formatter.maximumFractionDigits = 2
            formatter.roundingMode = .up
            
            if distanceInMeters > 1000{
                var distanceKilom = distanceInMeters / 1000
                let distance = formatter.string(from: (distanceKilom as? NSNumber)!)
                print("\(user?["name"]) a \(distance) km de distancia de ti")
                localLB.text = String(describing: distance!) + " km de distancia de ti"
            }else{
                let distance = formatter.string(from: (distanceInMeters as? NSNumber)!)
                print("\(user?["name"]) a \(distance) m de distancia de ti")
                localLB.text = String(describing: distance!) + " m de distancia de ti"
            }
        }
    }
    @IBAction func localizationAction(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "EventLocalizationViewController") as! EventLocalizationViewController
        
        vc.lat = Float(user?["lat"] as! String)!
        vc.lon = Float(user?["lon"] as! String)!
        
        self.present(vc, animated: true, completion: nil)
    }

    

}
