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

    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        picker = UIImagePickerController()
        picker?.delegate = self
        
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
            needAcceptPermission()
        case .restricted:
            print("Access is restricted")
            needAcceptPermission()
        case .denied:
            print("Access is denied")
            needAcceptPermission()
        }
    }
    
    func requestAuth(){
        PHPhotoLibrary.requestAuthorization({
            (newStatus) in print("new status is \(newStatus)")
            
            if newStatus == PHAuthorizationStatus.authorized {
                
                self.openGallary()
                
                print("success")
                
            }
        })
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
//    // Take Photo button click
//    @IBAction func TakePhoto(sender: AnyObject) {
//        openCamera()
//    }
    
    @IBAction func OpenGallery(_ sender: Any) {
        
        checkPermission()
        
    }
    
    func openGallary()
    {
        picker!.allowsEditing = false
        picker!.sourceType = UIImagePickerControllerSourceType.photoLibrary
        present(picker!, animated: true, completion: nil)
    }
    
    
    func openCamera()
    {
        if(UIImagePickerController .isSourceTypeAvailable(UIImagePickerControllerSourceType.camera)){
            picker!.allowsEditing = false
            picker!.sourceType = UIImagePickerControllerSourceType.camera
            picker!.cameraCaptureMode = .photo
            present(picker!, animated: true, completion: nil)
        }else{
            let alert = UIAlertController(title: "Camera Not Found", message: "This device has no Camera", preferredStyle: .alert)
            let ok = UIAlertAction(title: "OK", style:.default, handler: nil)
            alert.addAction(ok)
            present(alert, animated: true, completion: nil)
        }
    }
    
    func needAcceptPermission(){
        let alert = CPAlertViewController()
        alert.showError(title: "Es necesario aceptar los permisos desde ajustes", buttonTitle: "OK")
    }
    
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        
        let chosenImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        imageView.contentMode = .scaleAspectFit
        imageView.image = chosenImage
        
        eventCreated?.imageEvent = UIImageJPEGRepresentation(chosenImage, 1)

        dismiss(animated: true, completion: nil)
        
        
    }
}
