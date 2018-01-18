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
    @IBOutlet weak var emailLabelLogin: UILabel!
    @IBOutlet weak var passwordLabelLogin: UILabel!
    @IBOutlet weak var areyouregisterButtomLogin: UIButton!
    @IBOutlet weak var forgetPasswordLogin: UIButton!
    @IBOutlet weak var enterButtomlogin: UIButton!
    
    let manager = CLLocationManager()
    
    var lon:Float = 0.0
    var lat:Float = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        manager.delegate = self
        updateTexts()
        //self.view.backgroundColor = UIColor(patternImage: UIImage(named: "recurso_fo.png")!)
        
    }
    func updateTexts(){
        emailLabelLogin.text = "email".localized()
        passwordLabelLogin.text = "passwordLogin".localized()
        areyouregisterButtomLogin.setTitle("areyouregister".localized(), for: .normal)
        forgetPasswordLogin.setTitle("forgetPass".localized(), for: .normal)
        enterButtomlogin.setTitle("enterBtn".localized(), for: .normal)
        enterButtomlogin.layer.borderColor = UIColor.white.cgColor
        enterButtomlogin.layer.borderWidth = 2
        enterButtomlogin.layer.cornerRadius = enterButtomlogin.layer.frame.height / 2
        emailLoginTextField.layer.borderColor =  UIColor.white.cgColor
        passwordLoginTextField.layer.borderColor =  UIColor.white.cgColor
        emailLoginTextField.layer.borderWidth = 3
        passwordLoginTextField.layer.borderWidth = 3
        emailLoginTextField.layer.cornerRadius = emailLoginTextField.layer.frame.height / 2
        passwordLoginTextField.layer.cornerRadius = passwordLoginTextField.layer.frame.height / 2
        
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
        if isValidEmail(YourEMailAddress: emailLoginTextField.text!) {
            if passwordLoginTextField.text! != "" {
                
                self.getLocation()
                
            }
            else{
                
                alert.showError(title: "emptyPassword".localized(), buttonTitle: "OK")
                //createAlert(message: "emptyPassword".localized())

            }
        }else{
            alert.showError(title: "wrongMail".localized(), buttonTitle: "OK")
            //createAlert(message: "wrongMail".localized())
        }
    }
    
    func createLoginRequest(email:String, password:String){
        
        SwiftSpinner.show("...")
        
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
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "MainViewController") as! MainViewController
        vc.modalTransitionStyle = .flipHorizontal
        self.present(vc, animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

