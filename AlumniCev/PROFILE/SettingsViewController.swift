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
    
    @IBOutlet weak var passwordTitleLbl: UILabel!
    @IBOutlet weak var passwordTxF: UITextField!
    
    @IBOutlet weak var phoneTitleLbl: UILabel!
    @IBOutlet weak var phoneTxF: UITextField!
    
    @IBOutlet weak var emailTitleLbl: UILabel!
    @IBOutlet weak var emailTxF: UITextField!
    
    @IBOutlet weak var descriptionTitleLbl: UILabel!
    @IBOutlet weak var descriptionTxV: UITextView!
    
    @IBOutlet weak var privacityTitleLbl: UILabel!
    @IBOutlet weak var localizationTitleLbl: UILabel!

    @IBOutlet weak var allowPhoneLbl: UILabel!
    
    @IBOutlet weak var changePhotoBtn: UIButton!
    
    var photo:Data?
    
    var picker:UIImagePickerController?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        imgProfile.contentMode = .scaleAspectFill
        imgProfile.layer.masksToBounds = true
        imgProfile.layer.cornerRadius = imgProfile.frame.size.height/2
        
        picker = UIImagePickerController()
        picker?.delegate = self
        
        setTitles()
        setValues()
        setStyleTxF()

        // Do any additional setup after loading the view.
    }
    
    func setValues(){
        let name = getDataInUserDefaults(key: "name")
        nameTxF.text = name
   
        passwordTxF.text = "*******"
        
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
        passwordTitleLbl.text = "password".localized()
        phoneTitleLbl.text = "MyPhone".localized()
        emailTitleLbl.text = "emailSettings".localized()
        descriptionTitleLbl.text = "descriptSettings".localized()
        localizationTitleLbl.text = "localizSettings".localized()
        allowPhoneLbl.text = "phoneSettings".localized()
    }
    
    func setStyleTxF(){
        nameTxF.layer.borderColor = cevColor.cgColor
        passwordTxF.layer.borderColor = cevColor.cgColor
        phoneTxF.layer.borderColor = cevColor.cgColor
        emailTxF.layer.borderColor = cevColor.cgColor
        
        nameTxF.layer.borderWidth = 0.5
        passwordTxF.layer.borderWidth = 0.5
        phoneTxF.layer.borderWidth = 0.5
        emailTxF.layer.borderWidth = 0.5
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
                
                requestEditUser(id: id!, email: email, phone: phone, birthday: nil, description: description, photo: photo) {
                    
                    self.stopSpinner()
                    
                    alert.showSuccess(title: "Éxito", message: "Cambios guardados", buttonTitle: "OK", action: { (nil) in
                        
                        if self.photo != nil{
                            saveDataInUserDefaults(value: (self.photo?.base64EncodedString())!, key: "photo")
                        }

                        saveDataInUserDefaults(value: email, key: "email")
                        saveDataInUserDefaults(value: phone, key: "phone")
                        saveDataInUserDefaults(value: description!, key: "description")
                        saveDataInUserDefaults(value: name!, key: "name")
                        
                        self.dismiss(animated: true, completion: nil)
                    })
                    
                }
              
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
