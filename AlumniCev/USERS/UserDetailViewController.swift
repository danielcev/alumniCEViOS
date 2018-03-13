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
import SwiftSpinner
import CPAlertViewController





class UserDetailViewController: UIViewController, MFMailComposeViewControllerDelegate {
    
    var alert = CPAlertViewController()
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
    @IBOutlet weak var imageViewer: UIView!
    @IBOutlet weak var imageFromIMGVW: UIImageView!
    
    var user:Dictionary<String,Any>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // cambiar titulo boton de amistad
        self.addFriendsBtn.layer.cornerRadius = addFriendsBtn.bounds.size.height/2
        self.setBtn()
    // sacar usuario por id
        requestUserById(id: Int(user?["id"] as! String)!) {
            // privacidad
            if self.user?["phone"] as? String != nil && privacityUser!["phone"] == "1"{
                self.phoneLB.text = self.user?["phone"] as? String
            }else{
                self.PhoneBtn.isEnabled = false
            }
            // localizacion
            if self.user?["lat"] as? String != nil && self.user?["lon"] as? String != nil && privacityUser!["localization"] == "1"{
                self.DistanceFriend()
            }else{
                self.localBtn.isEnabled = false
            }
            // descripcion
            if self.user?["description"] as? String == nil{
                self.descripTxt.text =  "defaulDesc".localized()
            }else{
                self.descripTxt.text = self.user?["description"] as! String
            }
            // otros campos
            //self.usernameLbl.text = self.user?["name"] as? String
            self.nameLB.text = self.user?["name"] as? String
            self.direcLB.text = self.user?["email"] as? String
            self.userLB.text = self.user?["username"] as? String
        }
        
    
        
        //addFriendsBtn.setTitle("addFriend".localized(), for: .normal)
        //addFriendsBtn.setTitle("addFriend".localized(), for: .normal)
        
    // actualizar textos
        nameTitle.text = "myName".localized()
        DescripTitlfe.text = "myDescrip".localized()
        direcTitle.text = "myMail".localized()
        phoneTitle.text = "myNum".localized()
        localTitle.text = "myLoc".localized()
        userTitle.text = "myUserName".localized()
        
        
    
    // imagen de perfil
        self.imageFromIMGVW.image = #imageLiteral(resourceName: "userdefaulticon")
        self.imgUser.image = #imageLiteral(resourceName: "userdefaulticon")
    // configuracion fotos (escalado posicion etc)
        imgUser.contentMode = .scaleAspectFill
        imgUser.layer.cornerRadius = imgUser.bounds.height/2
        imgUser.layer.masksToBounds = true
        
        imageFromIMGVW.contentMode = .scaleAspectFit
        imageFromIMGVW.layer.masksToBounds = true
        
        if user!["photo"] as? String != nil
        {
            let remoteImageURL = URL(string: (user!["photo"] as? String)!)!
            Alamofire.request(remoteImageURL).responseData
                { (response) in
                if response.error == nil {
                    print(response.result)
                    if let data = response.data {
                        self.imgUser.image = UIImage(data: data)
                        self.imageFromIMGVW.image = UIImage(data: data)
                    }
                }
            }
        }

    }
    
    func setBtn(){
        requestUserById(id: Int(user?["id"] as! String)!){
            if friend != nil
            {
                if Int(friend!["state"] as! String) == 2
                {
                    self.addFriendsBtn.setTitle("Eliminar amistad", for: .normal)
                    self.addFriendsBtn.backgroundColor = UIColor(named: "Orange")
                    //addFriendsBtn.backgroundColor = UIColor(displayP3Red: 241, green: 90, blue: 36, alpha: 1)
                }else
                {
                    if friend!["id_user_send"] as? Int == Int((self.user?["id"] as? String)!)
                    {
                        self.addFriendsBtn.setTitle("Aceptar petición", for: .normal)
                        self.addFriendsBtn.backgroundColor = UIColor(named: "Turques")
                    }else
                    {
                        self.addFriendsBtn.setTitle("Cancelar petición enviada", for: .normal)
                        self.addFriendsBtn.backgroundColor = UIColor(named: "Orange")
                    }
                }
            }else
            {
                self.addFriendsBtn.setTitle("Enviar petición de amistad", for: .normal)
                self.addFriendsBtn.backgroundColor = UIColor(named: "Turques")
            }
            // activar boton
            self.addFriendsBtn.isEnabled = true
        }
        
    }
    
    @IBAction func addFriend(_ sender: Any) {
        
        //addFriendsBtn.isEnabled = false
        let idNewFriend = user?["id"] as! String
        if friend == nil
        {
            // si no hay peticion creada se crea una nueva
            sendRequestFriend(id_user: Int(idNewFriend)!) {message,code in
                // actualizar boton
                self.setBtn()
                self.showAlert(message: message)
            }
        }else
        {
            // si hay peticion y esta en 2 (amigo) se borra de amigo (borrar peticion)
            if friend!["state"] as! String == "2" {
                //Eliminar amistad
                print(idNewFriend)
                let alert = UIAlertController(title: "Borrar amigo", message: "¿Seguro que quieres dejar de ser amigo?", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Cancelar", style: .cancel, handler: nil))
                alert.addAction(UIAlertAction(title: "Borrar", style: .destructive, handler: { (nil) in
                    requestDeleteFriend(id_user: Int(idNewFriend)!)
                    {message,code in
                        self.setBtn()
                        self.showAlert(message: message)
                        if code == 200{
                            // borrar amistad de local
                            friend = nil
                        }
                    }
                }))
                self.present(alert, animated: true)
                
                
            }else{
                // si esta en 1 (peticion pendiente)
                
                //Aceptar petición si el que la envia es el usuario del detalle
                if friend!["id_user_send"] as? Int == Int((user?["id"] as? String)!)
                {
                    requestResponseFriend(id_user: Int(idNewFriend)!, type: 2){message,code in
                        self.setBtn()
                        self.showAlert(message: message)
                    }
                }else
                {
                    //Cancelar petición enviada, porque la ha enviado el usuario logeado
                    requestCancelRequest(id_user: Int(idNewFriend)!){message,code in
                        // actualizar boton
                        self.setBtn()
                        self.showAlert(message: message)
                    }
                    
                }
            }
        }
        
        
    }
    
    func showAlert(message:String){
        
        let alert = UIAlertController(title: message, message: "", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        self.present(alert, animated: true)
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
        //self.navigationController?.popViewController(animated: true)
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
        
    }
    
    @IBAction func OpendWhatsappAction(_ sender: Any) {
        var thePhone =  phoneLB.text
        
        if  phoneLB.text != ""{
            UIApplication.shared.openURL(URL(string:"https://api.whatsapp.com/send?phone=34\(thePhone!)")!)
        }else{
            print("Este usuario no tiene numero de telefono")
        }
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
                localLB.text = String(describing: distance!) + " km de distancia de ti"
            }else{
                let distance = formatter.string(from: (distanceInMeters as? NSNumber)!)
                localLB.text = String(describing: distance!) + " m de distancia de ti"
            }
        }
    }
    @IBAction func localizationAction(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "EventLocalizationViewController") as! EventLocalizationViewController
        
        vc.lat = Float(user?["lat"] as! String)!
        vc.lon = Float(user?["lon"] as! String)!
        
        self.navigationController?.pushViewController(vc, animated: true)
        //self.present(vc, animated: true, completion: nil)
    }
    @IBAction func dismisImageViewer(_ sender: Any) {
        imageViewer.isHidden = true
    }
    
    @IBAction func showImageViewer(_ sender: Any) {
        imageViewer.isHidden = false
        
    }
    
    
}
