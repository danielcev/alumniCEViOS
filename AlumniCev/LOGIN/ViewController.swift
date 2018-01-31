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

        // Do any additional setup after loading the view, typically from a nib.
        manager.delegate = self
        updateElements()
    
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if(getDataInUserDefaults(key: "isLoged")! == "true"){
            self.goToMain()
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
        vc.modalTransitionStyle = .flipHorizontal
        self.present(vc, animated: true)
    }
    
    @IBAction func goToForgot(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "ForgotViewController") as! ForgotViewController
        vc.modalTransitionStyle = .flipHorizontal
        self.present(vc, animated: true)
    }
    
    
    @IBAction func enterLoginButtom(_ sender: UIButton) {
    
        let alert = CPAlertViewController()
        
        if passwordLoginTextField.text != "" && emailLoginTextField.text != ""{
            
            if isValidEmail(YourEMailAddress: emailLoginTextField.text!) {
                
                self.getLocation()

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
            
            var arrayResult = response.result.value as! Dictionary<String, Any>
            let alert = CPAlertViewController()
            
            switch response.result {
            case .success:
                switch arrayResult["code"] as! Int{
                case 200:
                    var arrayData = arrayResult["data"] as! Dictionary<String,Any>
                    var arrayUser = arrayData["user"] as! Dictionary<String,Any>
                    
                    SwiftSpinner.hide()

                    alert.showSuccess(title: (arrayResult["message"] as! String),  buttonTitle: "OK", action: { (nil) in
                        saveDataInUserDefaults(value: arrayUser["email"] as! String, key: "email")
                        saveDataInUserDefaults(value: arrayUser["password"] as! String, key: "password")
                        saveDataInUserDefaults(value: arrayUser["name"] as! String, key: "name")
                        saveDataInUserDefaults(value: arrayData["token"] as! String, key: "token")
                        saveDataInUserDefaults(value: "true", key: "isLoged")
                        self.goToMain()
                    })
                default:
                    SwiftSpinner.hide()
                    alert.showError(title: (arrayResult["message"] as! String), buttonTitle: "OK")
                }
            case .failure:
                SwiftSpinner.hide()
                print("Error :: \(String(describing: response.error))")
                //alert.showError(title: (String(describing: response.error), buttonTitle: "OK")
            }
            SwiftSpinner.hide()
        }
    }
    
    func getLocation(){
        
        manager.requestAlwaysAuthorization()
        manager.requestLocation()
        
        SwiftSpinner.show("...")
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            print("Found user's location: \(location)")
            
            self.manager.stopUpdatingLocation()
            
            self.lon = Float(location.coordinate.longitude)
            self.lat = Float(location.coordinate.latitude)
            
            self.createLoginRequest(email: emailLoginTextField.text!, password: passwordLoginTextField.text!)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Failed to find user's location: \(error.localizedDescription)")
        self.manager.stopUpdatingLocation()
        self.createLoginRequest(email: emailLoginTextField.text!, password: passwordLoginTextField.text!)
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

