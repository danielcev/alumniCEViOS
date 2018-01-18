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
 
 class RegisterViewController: UIViewController {
    
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var emailTextLabel: UILabel!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextLabel: UILabel!
    @IBOutlet weak var repeatPasswordTextLabel: UILabel!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var repeatPasswordTextField: UITextField!
    @IBOutlet weak var btnRegister: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        updateTexts()
    }
    
    func updateTexts(){
        emailTextLabel.text = "email".localized()
        passwordTextField.placeholder = "password".localized()
        repeatPasswordTextField.placeholder = "repeatpassword".localized()
        btnRegister.setTitle("btnregister".localized(), for: .normal)
        
        passwordTextLabel.text = "password".localized()
        repeatPasswordTextLabel.text = "repeatpassword".localized()
        
        btnRegister.layer.borderColor = UIColor.white.cgColor
        btnRegister.layer.borderWidth = 2
        btnRegister.layer.cornerRadius = btnRegister.layer.frame.height / 2
        
        emailTextField.layer.borderColor = UIColor.white.cgColor
        emailTextField.layer.borderWidth = 3
        emailTextField.layer.cornerRadius = emailTextField.layer.frame.height / 2
        
        passwordTextField.layer.borderColor = UIColor.white.cgColor
        passwordTextField.layer.borderWidth = 3
        passwordTextField.layer.cornerRadius = passwordTextField.layer.frame.height / 2
        
        //Set color placeholder blanco
        passwordTextField.setValue(UIColor.init(red: 255/255, green: 255/255, blue: 255/255, alpha: 1.0), forKeyPath: "_placeholderLabel.textColor")
        
        repeatPasswordTextField.layer.borderColor = UIColor.white.cgColor
        repeatPasswordTextField.layer.borderWidth = 2
        repeatPasswordTextField.layer.cornerRadius = repeatPasswordTextField.layer.frame.height / 2
        
        //Set color placeholder blanco
        repeatPasswordTextField.setValue(UIColor.init(red: 255/255, green: 255/255, blue: 255/255, alpha: 1.0), forKeyPath: "_placeholderLabel.textColor")
        
    }
    @IBAction func backBtn(_ sender: Any) {

        self.dismiss(animated: true, completion: nil)
    }
    
  
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func registerAction(_ sender: Any) {
        
        let alert = CPAlertViewController()
        if isValidEmail(YourEMailAddress: emailTextField.text!) {

                if passwordTextField.text! != "" {
                    if repeatPasswordTextField.text! == passwordTextField.text!{
                        
                        self.createRegisterRequest(email: emailTextField.text!, password: passwordTextField.text!)
                    
                    }
                    else{
                        alert.showError(title: "wrongRepeatPassword".localized(), buttonTitle: "OK")
                    }
                }
                else{
                    alert.showError(title: "emptyPassword".localized(), buttonTitle: "OK")
                }
            
        }else {
            alert.showError(title: "wrongEmail".localized(), buttonTitle: "OK")
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
                        
                        SwiftSpinner.hide()
                
//                        var arrayData = arrayResult["data"] as! Dictionary<String, Any>
//                        var arrayUser = arrayData["user"] as! Dictionary<String, Any>
                    alert.showSuccess(title: (arrayResult["message"] as! String),  buttonTitle: "OK", action: { (nil) in
                        self.dismiss(animated: true)
                    })
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
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
 }
