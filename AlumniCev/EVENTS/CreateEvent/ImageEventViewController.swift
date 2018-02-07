//
//  ImageEventViewController.swift
//  AlumniCev
//
//  Created by alumnos on 24/1/18.
//  Copyright © 2018 Victor Serrano. All rights reserved.
//

import UIKit
import Photos
import CPAlertViewController

class ImageEventViewController: UIViewController, UIImagePickerControllerDelegate,UIPopoverControllerDelegate,UINavigationControllerDelegate {
    
    var picker:UIImagePickerController?

    @IBOutlet weak var addImageLbl: UILabel!
    @IBOutlet weak var optionalLabel: UILabel!
    
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var addImageBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        picker = UIImagePickerController()
        picker?.delegate = self
        
        addImageLbl.text = "wantImage".localized()
        addImageBtn.setTitle("uploadImage".localized(), for: .normal)
        optionalLabel.text = "optional".localized()
        
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
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    @IBAction func OpenGallery(_ sender: Any) {
        
        checkPermission()
        
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
    
    @IBAction func cancelAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        
        let chosenImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        imageView.contentMode = .scaleAspectFit
        imageView.image = chosenImage
        
        eventCreated?.imageEvent = UIImageJPEGRepresentation(chosenImage, 0.1)

        dismiss(animated: true, completion: nil)
        
        
    }
}
