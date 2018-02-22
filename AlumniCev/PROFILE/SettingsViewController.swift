//
//  SettingsViewController.swift
//  AlumniCev
//
//  Created by Daniel Plata on 8/2/18.
//  Copyright © 2018 Victor Serrano. All rights reserved.
//

import UIKit
import Photos
import CPAlertViewController
import NVActivityIndicatorView

class SettingsViewController: UIViewController, UIImagePickerControllerDelegate,UIPopoverControllerDelegate,UINavigationControllerDelegate {
    
    @IBOutlet var completView: UIView!
    
    @IBOutlet weak var spinner: NVActivityIndicatorView!
    
    @IBOutlet weak var imgProfile: UIImageView!
    
    @IBOutlet weak var nameTitleLbl: UILabel!
    @IBOutlet weak var nameTxF: UITextField!
    

    @IBOutlet weak var changePasswordBtn: UIButton!
    
    @IBOutlet weak var phoneTitleLbl: UILabel!
    @IBOutlet weak var phoneTxF: UITextField!
    
    @IBOutlet weak var emailTitleLbl: UILabel!
    @IBOutlet weak var emailTxF: UITextField!
    
    @IBOutlet weak var descriptionTitleLbl: UILabel!
    @IBOutlet weak var descriptionTxV: UITextView!
    
    @IBOutlet weak var privacityTitleLbl: UILabel!
    
    @IBOutlet weak var localizationTitleLbl: UILabel!
    @IBOutlet weak var switchLocalization: UISwitch!
    
    @IBOutlet weak var allowPhoneLbl: UILabel!
    @IBOutlet weak var switchPhone: UISwitch!
    
    @IBOutlet weak var changePhotoBtn: UIButton!
    
    var photo:Data?
    
    var picker:UIImagePickerController?
    
    var cpalert:CPAlertViewController? = nil
    
    var lastPassword:String?
    var password:String?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        cpalert = CPAlertViewController()
        
        let phonePrivacity = getDataInUserDefaults(key: "phoneprivacity") == "1" ? true : false
        
        let localizationPrivacity = getDataInUserDefaults(key: "localizationprivacity") == "1" ? true : false
        
        switchPhone.setOn(phonePrivacity, animated: false)
        switchLocalization.setOn(localizationPrivacity, animated: false)
        
        imgProfile.contentMode = .scaleAspectFill
        imgProfile.layer.masksToBounds = true
        imgProfile.layer.cornerRadius = imgProfile.frame.size.height/2
        
        picker = UIImagePickerController()
        picker?.delegate = self
        
        setTitles()
        setValues()

        // Do any additional setup after loading the view.
    }
    
    func setValues(){
        let name = getDataInUserDefaults(key: "name")
        nameTxF.text = name
        
        if getDataInUserDefaults(key: "phone") != nil{
            let phone = getDataInUserDefaults(key: "phone")
            phoneTxF.text = phone
        }

        let email = getDataInUserDefaults(key: "email")
        emailTxF.text = email
        
        if getDataInUserDefaults(key: "photo") != nil{
            imgProfile.image = UIImage(data: Data(base64Encoded: getDataInUserDefaults(key: "photo")!)!)
        }
        
        if getDataInUserDefaults(key: "description") != nil{
            let description = getDataInUserDefaults(key: "description")
            descriptionTxV.text = description
        }else{
            descriptionTxV.text = "defaulDesc".localized()
        }
    }
    
    func setTitles(){
        changePhotoBtn.setTitle("changePhoto".localized(), for: .normal)
        nameTitleLbl.text = "fullName".localized()
        changePasswordBtn.setTitle("password".localized(), for: .normal)
        phoneTitleLbl.text = "MyPhone".localized()
        emailTitleLbl.text = "emailSettings".localized()
        descriptionTitleLbl.text = "descriptSettings".localized()
        localizationTitleLbl.text = "localizSettings".localized()
        allowPhoneLbl.text = "phoneSettings".localized()
    }
   
    @IBAction func changePasswordAction(_ sender: Any) {
        
        //1. Create the alert controller.
        let alert = UIAlertController(title: "Cambiar contraseña", message: "Cambia tu contraseña por una nueva", preferredStyle: .alert)
        
        //2. Add the text field. You can configure it however you need.
        alert.addTextField { (textField) in
            textField.placeholder = "Contraseña antigua"
        }
        
        alert.addTextField { (textField) in
            textField.placeholder = "Contraseña nueva"
        }
        
        alert.addTextField { (textField) in
            textField.placeholder = "Repetir contraseña nueva"
        }
        
        alert.addAction(UIAlertAction(title: "Cancelar", style: .destructive, handler: nil))
        
        
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak alert] (_) in
            let textFieldAntigua = alert?.textFields![0]
            let textFieldNueva = alert?.textFields![1]
            let textFieldRepetirNueva = alert?.textFields![2]
            
            if textFieldAntigua!.text != "" && textFieldNueva!.text != "" && textFieldRepetirNueva!.text != ""{
                
                if textFieldNueva!.text != textFieldRepetirNueva!.text{
                    self.present(alert!, animated: true, completion: nil)
                    alert?.message = "No coinciden las contraseñas"
                    alert?.setValue(NSAttributedString(string: (alert?.message)!, attributes: [NSAttributedStringKey.font : UIFont.systemFont(ofSize: 13, weight: UIFont.Weight.medium), NSAttributedStringKey.foregroundColor : UIColor.red]), forKey: "attributedMessage")
                }else{
                    if (textFieldNueva!.text?.count)! < 5 || (textFieldNueva!.text?.count)! > 12{
                        self.present(alert!, animated: true, completion: nil)
                        alert?.message = "La longitud de la contraseña debe estar comprendida entre 5 y 12 caracteres"
                        alert?.setValue(NSAttributedString(string: (alert?.message)!, attributes: [NSAttributedStringKey.font : UIFont.systemFont(ofSize: 13, weight: UIFont.Weight.medium), NSAttributedStringKey.foregroundColor : UIColor.red]), forKey: "attributedMessage")
                    }else{
                    
                        self.lastPassword = (textFieldAntigua!.text)!
                        self.password = (textFieldNueva?.text)!
                        
                        self.changePassword(alert: alert!)
                    }
                }
                
            }else{
                self.present(alert!, animated: true, completion: nil)
                alert?.message = "Todos los campos son necesarios"
                alert?.setValue(NSAttributedString(string: (alert?.message)!, attributes: [NSAttributedStringKey.font : UIFont.systemFont(ofSize: 13, weight: UIFont.Weight.medium), NSAttributedStringKey.foregroundColor : UIColor.red]), forKey: "attributedMessage")
            }

        }))
        
        // 4. Present the alert.
        self.present(alert, animated: true, completion: nil)
        
    }
    
    func changePassword(alert:UIAlertController){
        requestChangePassword(lastPassword: self.lastPassword!, password: self.password!, action: {
            
            self.cpalert?.showSuccess(title: "Éxito", message: "Contraseña cambiada", buttonTitle: "OK", action: nil)
            
        }, fail: {
            self.present(alert, animated: true, completion: nil)
            alert.message = "La contraseña antigua no es válida"
            alert.setValue(NSAttributedString(string: (alert.message)!, attributes: [NSAttributedStringKey.font : UIFont.systemFont(ofSize: 13, weight: UIFont.Weight.medium), NSAttributedStringKey.foregroundColor : UIColor.red]), forKey: "attributedMessage")
        })
    }

    
    @IBAction func uploadImageAction(_ sender: UIButton) {
        checkPermission()
    }
    
    func checkPermission() {
        
        requestAuth()
        
        let photoAuthorizationStatus = PHPhotoLibrary.authorizationStatus()
        
        print(photoAuthorizationStatus)
        
        switch photoAuthorizationStatus {
            
        case .authorized:
            print("Access is granted by user")
            self.openGallary()
        case .notDetermined:
            print("Access is not determined")
            
        case .restricted:
            print("Access is restricted")
            
        case .denied:
            print("Access is denied")
            
        }
    }
    
    func requestAuth(){
        PHPhotoLibrary.requestAuthorization({
            (newStatus) in print("new status is \(newStatus)")
            
            if newStatus == PHAuthorizationStatus.authorized {
                
                self.openGallary()
                
                print("success")
                
            }else{
                self.needAcceptPermission()
            }
        })
    }
    
    func openGallary()
    {
        picker!.allowsEditing = false
        picker!.sourceType = UIImagePickerControllerSourceType.photoLibrary
        present(picker!, animated: true, completion: nil)
    }
    
    func needAcceptPermission(){
        let alert = CPAlertViewController()
        alert.showError(title: "Es necesario aceptar los permisos desde ajustes", buttonTitle: "OK")
    }
    
    @IBAction func backAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        
        let chosenImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        imgProfile.contentMode = .scaleAspectFit
        imgProfile.image = chosenImage
        
        photo = UIImageJPEGRepresentation(chosenImage, 0.1)!
        
        dismiss(animated: true, completion: nil)
    }

    @IBAction func saveChanges(_ sender: UIButton) {
        
        let alert = CPAlertViewController()
        
        let id = Int(getDataInUserDefaults(key: "id")!)
        
        if isValidEmail(YourEMailAddress: emailTxF.text!) {
            
            let email = emailTxF.text!
            
            if isValidPhone(phone: phoneTxF.text!) || phoneTxF.text! == ""{
                
                self.startSpinner()
                
                let phone = phoneTxF.text!
                let description = descriptionTxV.text
                let name = nameTxF.text
                
                let localizationprivacity = switchLocalization.isOn ? 1 : 0
                let phoneprivacity = switchPhone.isOn ? 1 : 0
                
                requestEditUser(id: id!, email: email, name: name, phone: phone, birthday: nil, description: description, photo: photo, phoneprivacity: phoneprivacity, localizationprivacity: localizationprivacity, action: {
                    
                    self.stopSpinner()
                    
                    alert.showSuccess(title: "Éxito", message: "Cambios guardados", buttonTitle: "OK", action: { (nil) in
                        
                        if self.photo != nil{
                            saveDataInUserDefaults(value: (self.photo?.base64EncodedString())!, key: "photo")
                        }

                        saveDataInUserDefaults(value: email, key: "email")
                        saveDataInUserDefaults(value: phone, key: "phone")
                        saveDataInUserDefaults(value: description!, key: "description")
                        saveDataInUserDefaults(value: name!, key: "name")
                        saveDataInUserDefaults(value: localizationprivacity.description, key: "localizationprivacity")
                        saveDataInUserDefaults(value: phoneprivacity.description, key: "phoneprivacity")
                        
                        self.dismiss(animated: true, completion: nil)
                    })
                    
                }, fail: {
                    
                    alert.showError(title: "Error", message: "No se ha podido modificar el perfil", buttonTitle: "Ok", action: nil)
                    
                })

 
            }else{
                alert.showError(title: "wrongTlf".localized(), buttonTitle: "OK")
            }
            
        }else{
            alert.showError(title: "wrongEmail".localized(), buttonTitle: "OK")
        }

    }
    
    func startSpinner(){
        completView.isUserInteractionEnabled = false
        spinner.isHidden = false
        spinner.startAnimating()
    }
    
    func stopSpinner(){
        completView.isUserInteractionEnabled = true
        spinner.isHidden = true
        spinner.stopAnimating()
    }
    
}
