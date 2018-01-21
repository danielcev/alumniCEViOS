//
//  ForgotViewController.swift
//  AlumniCev
//
//  Created by alumnos on 17/1/18.
//  Copyright © 2018 Victor Serrano. All rights reserved.
//

import UIKit
import CPAlertViewController
import Alamofire
import SwiftSpinner

class ForgotViewController: UIViewController {

    
    @IBOutlet weak var resetPasswordLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var sendButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateTexts()
        // Do any additional setup after loading the view.
    }
    
    func updateTexts()
    {
        
        resetPasswordLabel.text = "recoverpassword".localized()
        emailLabel.text = "email".localized()

        sendButton.layer.borderColor = UIColor.white.cgColor
        sendButton.layer.borderWidth = 2
        sendButton.layer.cornerRadius = sendButton.layer.frame.height / 2
        
        backButton.layer.borderColor = UIColor.white.cgColor
        backButton.layer.borderWidth = 2
        backButton.layer.cornerRadius = backButton.layer.frame.height / 2
        
        emailTextField.layer.borderColor = UIColor.white.cgColor
        emailTextField.layer.borderWidth = 3
        emailTextField.layer.cornerRadius = emailTextField.layer.frame.height / 2
        
        sendButton.setTitle("send".localized(), for: .normal)
        backButton.setTitle("back".localized(), for: .normal)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func ActionCheckEmail(_ sender: Any) {
        
        let alert = CPAlertViewController()
        
        if emailTextField.text != ""{
        
            if isValidEmail(YourEMailAddress: emailTextField.text!){
                let url = URL(string: URL_GENERAL + "users/validateEmail.json")
                
                let parameters : Parameters = ["email":emailTextField.text!]
                
                SwiftSpinner.show("...")
                
                Alamofire.request(url!, method: .get, parameters: parameters).responseJSON{response in
                    
                    var arrayResult = response.result.value as! Dictionary<String, Any>
                    let alert = CPAlertViewController()
                    
                    switch response.result {
                    case .success:
                        switch arrayResult["code"] as! Int{
                        case 200:
                            
                            SwiftSpinner.hide()
                            
                            let vc = self.storyboard?.instantiateViewController(withIdentifier: "RecoverViewController") as! RecoverViewController
                            vc.modalTransitionStyle = .flipHorizontal
                            var arrayData = arrayResult["data"] as! Dictionary<String,Any>
                            vc.id =  Int( arrayData["id"] as! String)
                            self.present(vc, animated: true)
                            
                        default:
                            SwiftSpinner.hide()
                            
                            alert.showError(title: (arrayResult["message"] as! String), buttonTitle: "OK")
                        }
                    case .failure:
                        SwiftSpinner.hide()
                        print("Error :: \(String(describing: response.error))")
                    }
                    
                }
            }else{
                alert.showError(title: "wrongEmail".localized(), buttonTitle: "OK")
            }
            
        }else{
            alert.showError(title: "allFieldsRequired".localized(), buttonTitle: "OK")
        }
    }
    @IBAction func dismissFunction(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    //función para ocultar el teclado cuando pulsas fuera de él
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
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
