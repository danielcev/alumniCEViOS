//
//  RecoverViewController.swift
//  AlumniCev
//
//  Created by alumnos on 17/1/18.
//  Copyright © 2018 Victor Serrano. All rights reserved.
//

import UIKit
import Alamofire
import CPAlertViewController

class RecoverViewController: UIViewController {

    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var repeatPasswordTextField: UITextField!
    @IBOutlet weak var passLabel: UILabel!
    @IBOutlet weak var repeatPassLabel: UILabel!
    @IBOutlet weak var aceptBtn: UIButton!
    
    var id:Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateTexts()
        // Do any additional setup after loading the view.
    }
    
    func updateTexts(){
        
        passLabel.text = "password".localized()
        repeatPassLabel.text = "repeatpassword".localized()
        aceptBtn.setTitle("acept".localized(), for: .normal)
        
        aceptBtn.layer.borderColor = UIColor.white.cgColor
        aceptBtn.layer.borderWidth = 2
        aceptBtn.layer.cornerRadius = aceptBtn.layer.frame.height / 2
        
        passwordTextField.layer.borderColor = UIColor.white.cgColor
        passwordTextField.layer.borderWidth = 2
        passwordTextField.layer.cornerRadius = passwordTextField.layer.frame.height / 2
        
        repeatPasswordTextField.layer.borderColor = UIColor.white.cgColor
        repeatPasswordTextField.layer.borderWidth = 2
        repeatPasswordTextField.layer.cornerRadius = repeatPasswordTextField.layer.frame.height / 2
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func RecoverAction(_ sender: Any) {
        
        if passwordTextField.text! == repeatPasswordTextField.text && passwordTextField.text! != "" {
            
            let password = passwordTextField.text!
            let url = URL(string: URL_GENERAL + "users/recoverPassword.json")
            
            let parameters: Parameters = ["password":password, "id": id!]
            
            Alamofire.request(url!, method: .post, parameters: parameters).responseJSON{response in
                
                var arrayResult = response.result.value as! Dictionary<String, Any>
                let alert = CPAlertViewController()
                
                switch response.result {
                case .success:
                    switch arrayResult["code"] as! Int{
                    case 200:
                        
                        alert.showSuccess(title: (arrayResult["message"] as! String),  buttonTitle: "OK", action: { (nil) in
                            self.dismiss(animated: true, completion: {
                                self.dismiss(animated: true)
                            })
                        })
                    default:
                        alert.showError(title: (arrayResult["message"] as! String), buttonTitle: "OK")
                    }
                case .failure:
                    print("Error :: \(String(describing: response.error))")
                    //alert.showError(title: (String(describing: response.error), buttonTitle: "OK")
                }
                
            }
        }else{
            let alert = CPAlertViewController()
            alert.showError(title: ("wrongRepeatPassword".localized()), buttonTitle: "OK")
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
