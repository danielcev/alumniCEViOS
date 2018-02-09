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

class SettingsViewController: UIViewController, UIImagePickerControllerDelegate,UIPopoverControllerDelegate,UINavigationControllerDelegate {
    
    @IBOutlet weak var photoView: UIImageView!
    
    var photo:Data?
    
    var picker:UIImagePickerController?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        picker = UIImagePickerController()
        picker?.delegate = self

        // Do any additional setup after loading the view.
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
        photoView.contentMode = .scaleAspectFit
        photoView.image = chosenImage
        
        photo = UIImageJPEGRepresentation(chosenImage, 0.1)!
        
        dismiss(animated: true, completion: nil)
    }

    @IBAction func saveChanges(_ sender: UIButton) {
        let id = Int(getDataInUserDefaults(key: "id")!)
        
        requestEditUser(id: id!, email: nil, phone: nil, birthday: nil, description: nil, photo: photo) {
            saveDataInUserDefaults(value: (self.photo?.base64EncodedString())!, key: "photo")
            self.dismiss(animated: true, completion: nil)
        }
        
    }
}
