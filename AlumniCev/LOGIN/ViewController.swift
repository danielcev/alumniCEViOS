//
//  ViewController.swift
//  AlumniCev
//
//  Created by Victor Serrano on 8/1/18.
//  Copyright © 2018 Victor Serrano. All rights reserved.
//

import UIKit
import Alamofire
import CoreLocation
import CPAlertViewController
import SwiftSpinner
import JHTAlertController

class ViewController: UIViewController, CLLocationManagerDelegate {
    
    @IBOutlet weak var passwordLoginTextField: UITextField!
    @IBOutlet weak var emailLoginTextField: UITextField!
    @IBOutlet weak var forgetPasswordLogin: UIButton!
    @IBOutlet weak var enterButtomlogin: UIButton!
    @IBOutlet weak var registerBtn: UIButton!
    
    @IBOutlet weak var notAccountLbl: UILabel!
    let manager = CLLocationManager()
    
    var lon:Float = 0.0
    var lat:Float = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Login"
        // Do any additional setup after loading the view, typically from a nib.
        manager.delegate = self
        updateElements()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        if getDataInUserDefaults(key: "isLoged") != nil{
            if(getDataInUserDefaults(key: "isLoged")! == "true"){
                //self.goToMain()
                self.createLoginRequest(email: getDataInUserDefaults(key: "email")!, password: getDataInUserDefaults(key: "password")!)
            }
        }
        
    }
    
    func styleTxF(textfield:UITextField){
        
        let border = CALayer()
        let width = CGFloat(2.0)
        border.borderColor = UIColor.white.cgColor
        border.frame = CGRect(x: 0, y: textfield.frame.size.height - width, width:  textfield.frame.size.width, height: textfield.frame.size.height)
        
        border.borderWidth = width
        textfield.layer.addSublayer(border)
        textfield.layer.masksToBounds = true
        
        textfield.setValue(UIColor.init(red: 255/255, green: 255/255, blue: 255/255, alpha: 0.5), forKeyPath: "_placeholderLabel.textColor")
        
    }
    
    override func viewDidLayoutSubviews(){
        styleTxF(textfield:emailLoginTextField)
        styleTxF(textfield:passwordLoginTextField)
    }
    func updateElements(){
        
        enterButtomlogin.layer.borderColor = UIColor.white.cgColor
        enterButtomlogin.layer.borderWidth = 2
        enterButtomlogin.layer.cornerRadius = enterButtomlogin.layer.frame.height / 2
        
        registerBtn.layer.borderColor = UIColor.white.cgColor
        registerBtn.layer.borderWidth = 2
        registerBtn.layer.cornerRadius = registerBtn.layer.frame.height / 2
        
        //SET TEXTS
        emailLoginTextField.placeholder = "email".localized()
        passwordLoginTextField.placeholder = "password".localized()
        notAccountLbl.text = "notAccount".localized()
        forgetPasswordLogin.setTitle("forgetPass".localized(), for: .normal)
        enterButtomlogin.setTitle("enter".localized(), for: .normal)
    }
    @IBAction func changeScreen(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "RegisterViewController") as! RegisterViewController
        //vc.modalTransitionStyle = .flipHorizontal
        self.navigationController?.pushViewController(vc, animated: true)
        //self.present(vc, animated: true)
    }
    
    @IBAction func goToForgot(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "ForgotViewController") as! ForgotViewController
        //vc.modalTransitionStyle = .flipHorizontal
        self.navigationController?.pushViewController(vc, animated: true)
        //self.present(vc, animated: true)
    }
    
    
    @IBAction func enterLoginButtom(_ sender: UIButton) {
        
        let alert = CPAlertViewController()
        
        if passwordLoginTextField.text != "" && emailLoginTextField.text != ""{
            
            if isValidEmail(YourEMailAddress: emailLoginTextField.text!) {
                SwiftSpinner.show("...")
                manager.requestWhenInUseAuthorization()
                self.createLoginRequest(email: emailLoginTextField.text!, password: passwordLoginTextField.text!)
            }else{
                alert.showError(title: "wrongEmail".localized(), buttonTitle: "OK")
            }
            
        }else{
            alert.showError(title: "allFieldsRequired".localized(), buttonTitle: "OK")
        }
    }
    
    func createLoginRequest(email:String, password:String){
        
        let url = URL(string: URL_GENERAL + "users/login.json")
        
        let parameters: Parameters = ["email":email,"password":password, "lon": self.lon , "lat": self.lat]
        
        Alamofire.request(url!, method: .post, parameters: parameters).responseJSON{response in
            
            if (response.result.value != nil)
            {
                
                var arrayResult = response.result.value as! Dictionary<String, Any>
                let alert = CPAlertViewController()
                
                switch response.result {
                case .success:
                    switch arrayResult["code"] as! Int{
                    case 200:
                        var arrayData = arrayResult["data"] as! Dictionary<String,Any>
                        var arrayUser = arrayData["user"] as! Dictionary<String,Any>
                        var arrayPrivacity = arrayData["privacity"] as! Dictionary<String,String>
                        
                        SwiftSpinner.hide()
                        
                        let alert = CPAlertViewController()
                        // si es logeo no mostrar alert
                        alert.showSuccess(title: "correctLogin".localized(), message: "succesLogin".localized(), buttonTitle: "OK", action: nil)
                        
                        saveDataInUserDefaults(value: arrayUser["id"] as! String, key: "id")
                        saveDataInUserDefaults(value: arrayUser["id_rol"] as! String, key: "id_rol")
                        saveDataInUserDefaults(value: arrayUser["email"] as! String, key: "email")
                        saveDataInUserDefaults(value: arrayUser["password"] as! String, key: "password")
                        saveDataInUserDefaults(value: arrayUser["name"] as! String, key: "name")
                        saveDataInUserDefaults(value: arrayUser["username"] as! String, key: "username")
                        saveDataInUserDefaults(value: arrayPrivacity["phone"]! , key: "phoneprivacity")
                        saveDataInUserDefaults(value: arrayPrivacity["localization"]! , key: "localizationprivacity")
                        
                        if !(arrayUser["description"] is NSNull)  {
                            saveDataInUserDefaults(value: arrayUser["description"]! as! String, key: "description")
                        }else{
                            clearDataInUserDefaults(key: "description")
                        }
                        
                        if !(arrayUser["phone"] is NSNull)  {
                            
                            saveDataInUserDefaults(value: arrayUser["phone"]! as! String, key: "phone")
                        }else{
                            clearDataInUserDefaults(key: "phone")
                        }
                        
                        if arrayUser["photo"] as? String != nil{
                            
                            let remoteImageURL = URL(string: (arrayUser["photo"] as? String)!)!
                            
                            // Use Alamofire to download the image
                            Alamofire.request(remoteImageURL).responseData { (response) in
                                if response.error == nil {
                                    if let data = response.data {
                                        saveDataInUserDefaults(value: data.base64EncodedString(), key: "photo")
                                    }
                                }
                            }
                            
                        }else{
                            clearDataInUserDefaults(key: "photo")
                        }
                        
                        if arrayUser["lat"] as? String != nil && arrayUser["lon"] as? String != nil{
                            saveDataInUserDefaults(value: arrayUser["lat"] as! String, key: "lat")
                            saveDataInUserDefaults(value: arrayUser["lon"] as! String, key: "lon")
                        }
                        
                        saveDataInUserDefaults(value: arrayData["token"] as! String, key: "token")
                        
                        saveDataInUserDefaults(value: "true", key: "isLoged")
                        self.goToMain()
                    case 500:
                        // error del servidor
                        SwiftSpinner.hide()
                        if getDataInUserDefaults(key: "email") != nil {
                            self.emailLoginTextField.text = getDataInUserDefaults(key: "email")
                        }
                        alert.showError(title: ("Error al conectar con el servidor" ), buttonTitle: "OK")
                        
                    default:
                        // cualquier error
                        SwiftSpinner.hide()
                        if getDataInUserDefaults(key: "email") != nil {
                            self.emailLoginTextField.text = getDataInUserDefaults(key: "email")
                        }
                        alert.showError(title: (arrayResult["message"] as! String), buttonTitle: "OK")
                    }
                case .failure:
                    SwiftSpinner.hide()
                    if getDataInUserDefaults(key: "email") != nil {
                        self.emailLoginTextField.text = getDataInUserDefaults(key: "email")
                    }
                    alert.showError(title: String(describing: response.error), buttonTitle: "OK")
                    print("Error :: \(String(describing: response.error))")
                }
                SwiftSpinner.hide()
            }else{
                let alert = CPAlertViewController()
                if getDataInUserDefaults(key: "email") != nil {
                    self.emailLoginTextField.text = getDataInUserDefaults(key: "email")
                }
                
                alert.showError(title: "No se puede conectar al servidor", buttonTitle: "OK")
            }
        }
    }
    
    func goToMain(){
        
        let tabbarVC = storyboard?.instantiateViewController(withIdentifier: "UITabBarController") as! UITabBarController
        
        self.present(tabbarVC, animated: false, completion: nil)
    }
    
    //función para ocultar el teclado cuando pulsas fuera de él
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
}

