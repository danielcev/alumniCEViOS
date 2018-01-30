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
import SwiftSpinner

class RecoverViewController: UIViewController {

    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var repeatPasswordTextField: UITextField!
    @IBOutlet weak var aceptBtn: UIButton!
    
    var id:Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateTexts()
        // Do any additional setup after loading the view.
    }
    
    func updateTexts(){
        
        aceptBtn.setTitle("acept".localized(), for: .normal)
        
        aceptBtn.layer.borderColor = UIColor.white.cgColor
        aceptBtn.layer.borderWidth = 2
        aceptBtn.layer.cornerRadius = aceptBtn.layer.frame.height / 2
        
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
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func RecoverAction(_ sender: Any) {
        
        if passwordTextField.text != "" && repeatPasswordTextField.text != ""{
        
            if passwordTextField.text == repeatPasswordTextField.text{
                
                let password:String = passwordTextField.text!
                
                if password.count > 4 && password.count < 13{
                    let password = passwordTextField.text!
                    let url = URL(string: URL_GENERAL + "users/recoverPassword.json")
                    
                    let parameters: Parameters = ["password":password, "id": id!]
                    
                    SwiftSpinner.show("...")
                    
                    Alamofire.request(url!, method: .post, parameters: parameters).responseJSON{response in
                        
                        var arrayResult = response.result.value as! Dictionary<String, Any>
                        let alert = CPAlertViewController()
                        
                        switch response.result {
                        case .success:
                            switch arrayResult["code"] as! Int{
                            case 200:
                                
                                SwiftSpinner.hide()
                                
                                alert.showSuccess(title: (arrayResult["message"] as! String),  buttonTitle: "OK", action: { (nil) in
                                    //self.dismiss(animated: true)
                                    self.view.window!.rootViewController?.dismiss(animated: true, completion: nil)
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
                        
                    }
                }else{
                    let alert = CPAlertViewController()
                    alert.showError(title: "lengthPassword".localized(), buttonTitle: "OK")
                }
                
                
            }else{
                let alert = CPAlertViewController()
                alert.showError(title: ("wrongRepeatPassword".localized()), buttonTitle: "OK")
            }
        }else{
            let alert = CPAlertViewController()
            alert.showError(title: ("allFieldsRequired".localized()), buttonTitle: "OK")
        }
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
