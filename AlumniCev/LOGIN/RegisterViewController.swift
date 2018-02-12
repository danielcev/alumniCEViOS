 //
 //  RegisterViewController.swift
 //  AlumniCev
 //
 //  Created by alumnos on 9/1/18.
 //  Copyright © 2018 Victor Serrano. All rights reserved.
 //
 
 import UIKit
 import Alamofire
 import CPAlertViewController
 import SwiftSpinner
 import JHTAlertController

 import CoreLocation
 
 class RegisterViewController: UIViewController, CLLocationManagerDelegate {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var repeatPasswordTextField: UITextField!
    @IBOutlet weak var btnRegister: UIButton!
    
    var lon:Float = 0.0
    var lat:Float = 0.0
    
    let manager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        manager.delegate = self
        
        // Do any additional setup after loading the view.
        updateTexts()
    }
    
    func updateTexts(){

        emailTextField.placeholder = "email".localized()
        passwordTextField.placeholder = "password".localized()
        repeatPasswordTextField.placeholder = "repeatPassword".localized()
        btnRegister.setTitle("register".localized(), for: .normal)
        
        
        btnRegister.layer.borderColor = UIColor.white.cgColor
        btnRegister.layer.borderWidth = 2
        btnRegister.layer.cornerRadius = btnRegister.layer.frame.height / 2

        
        //Set color placeholder blanco
        passwordTextField.setValue(UIColor.init(red: 255/255, green: 255/255, blue: 255/255, alpha: 0.5), forKeyPath: "_placeholderLabel.textColor")
        repeatPasswordTextField.setValue(UIColor.init(red: 255/255, green: 255/255, blue: 255/255, alpha: 0.5), forKeyPath: "_placeholderLabel.textColor")
        emailTextField.setValue(UIColor.init(red: 255/255, green: 255/255, blue: 255/255, alpha: 0.5), forKeyPath: "_placeholderLabel.textColor")
        
    }
    @IBAction func backBtn(_ sender: Any) {

        self.dismiss(animated: true, completion: nil)
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
        styleTxF(textfield:passwordTextField)
        styleTxF(textfield:repeatPasswordTextField)
        styleTxF(textfield:emailTextField)

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func registerAction(_ sender: Any) {
        
        let alert = CPAlertViewController()
        
        if emailTextField.text != "" && passwordTextField.text != "" && repeatPasswordTextField.text != ""{
        
            if isValidEmail(YourEMailAddress: emailTextField.text!) {

                if repeatPasswordTextField.text! == passwordTextField.text!{
                    
                    let password:String = passwordTextField.text!
                    
                    if password.count > 4 && password.count < 13{
                        self.createRegisterRequest(email: emailTextField.text!, password: passwordTextField.text!)
                    }else{
                        alert.showError(title: "lengthPassword".localized(), buttonTitle: "OK")
                    }
                    
                }
                else{
                    alert.showError(title: "wrongRepeatPassword".localized(), buttonTitle: "OK")
                }
                
            }else {
                alert.showError(title: "wrongEmail".localized(), buttonTitle: "OK")
            }
            
        }else{
            alert.showError(title: "allFieldsRequired".localized(), buttonTitle: "OK")
        }
    }
    
    func createRegisterRequest(email:String, password:String){
        
        let url = URL(string: URL_GENERAL + "users/create.json")
        
        let parameters : Parameters = ["email":email,"password":password]
        
        SwiftSpinner.show("...")
        
        Alamofire.request(url!, method: .post, parameters: parameters).responseJSON{response in
            
            var arrayResult = response.result.value as! Dictionary<String, Any>
            let alert = CPAlertViewController()
            
            switch response.result {
            case .success:
                switch arrayResult["code"] as! Int{
                    case 200:

                        self.getLocation()
                    
                    default:
                        
                        SwiftSpinner.hide()
                        alert.showError(title: (arrayResult["message"] as! String), buttonTitle: "OK")
                }
            case .failure:
                SwiftSpinner.hide()
                print("Error :: \(String(describing: response.error))")
            }
            
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
                    
                    // Setting up an alert with a title and message
                    let alertController = JHTAlertController(title: "", message: "Congratulations".localized(), preferredStyle: .alert)
                    
                    // Create an action with a completionl handler.
                    let okAction = JHTAlertAction(title: "OK", style: .default, bgColor: cevColor) { _ in
                        saveDataInUserDefaults(value: arrayUser["id"] as! String, key: "id")
                        saveDataInUserDefaults(value: arrayUser["email"] as! String, key: "email")
                        saveDataInUserDefaults(value: arrayUser["password"] as! String, key: "password")
                        saveDataInUserDefaults(value: arrayUser["name"] as! String, key: "name")
                        saveDataInUserDefaults(value: arrayData["token"] as! String, key: "token")
                        saveDataInUserDefaults(value: arrayUser["username"] as! String, key: "username")
                        if arrayUser["description"] as? String != nil{
                            saveDataInUserDefaults(value: arrayUser["description"] as! String, key: "description")
                        }
                        saveDataInUserDefaults(value: "true", key: "isLoged")
                        self.goToMain()
                    }
                    
                    alertController.addAction(okAction)
                    alertController.titleImage = UIImage(named: "Certificate")
                    alertController.titleViewBackgroundColor = UIColor.white
                    alertController.messageTextColor = cevColor
                    alertController.alertBackgroundColor = UIColor.white
                    
                    // Show the action
                    self.present(alertController, animated: true, completion: nil)
                    
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
            
            self.createLoginRequest(email: emailTextField.text!, password: passwordTextField.text!)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Failed to find user's location: \(error.localizedDescription)")
        self.manager.stopUpdatingLocation()
        self.createLoginRequest(email: emailTextField.text!, password: passwordTextField.text!)
    }
    
    func goToMain(){
        
        //        let tabbarVC = storyboard?.instantiateViewController(withIdentifier: "UITabBarController") as! UITabBarController
        let tabbarVC = storyboard?.instantiateViewController(withIdentifier: "WelcomeViewController") as! WelcomeViewController
        
        
        self.present(tabbarVC, animated: false, completion: nil)
        
        
    }
    
    //función para ocultar el teclado cuando pulsas fuera de él
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }

 }
