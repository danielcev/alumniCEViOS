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
    


    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    @IBAction func uploadImageAction(_ sender: UIButton) {
        // alert para camara o galeria
        
        let alert = UIAlertController(title: "Usar camara o galeria", message: "¿Quieres subir una foto desde la camara o desde la galeria?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Camara", style: .default, handler: { (nil) in
            self.checkPermissionCamera()
        }))
        alert.addAction(UIAlertAction(title: "Galeria", style: .default, handler: { (nil) in
            self.checkPermissionGallery()
        }))
        present(alert, animated: true, completion: nil)
        
        
    }
    
    func checkPermissionCamera() {
        
        // permisos para galeria
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .notDetermined:
            // pedir permisos
            DispatchQueue.main.async {
                AVCaptureDevice.requestAccess(for: AVMediaType.video, completionHandler: { (granted)  in
                    if granted {
                        self.openCamera()
                    }
                })
            }
        case .denied,.restricted:
            // alert para ir a ajustes
            let alert = UIAlertController(title: "Se necesitan permisos", message: "Se necesitan permisos para acceder a la galeria", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ir a ajustes", style: .default, handler: { (nil) in
                UIApplication.shared.open(NSURL(string:UIApplicationOpenSettingsURLString)! as URL, options: [:], completionHandler: nil)
            }))
            alert.addAction(UIAlertAction(title: "Cancelar", style: .cancel, handler: nil))
            
            present(alert, animated: true)
            
        case .authorized:
            // abrir galeria
            openCamera()
        }
    }
    func checkPermissionGallery() {
        
        // permisos para galeria
        switch PHPhotoLibrary.authorizationStatus() {
        case .notDetermined:
            // pedir permisos
            DispatchQueue.main.async {
                PHPhotoLibrary.requestAuthorization({(newStatus) in
                    print(newStatus)
                    if newStatus == PHAuthorizationStatus.authorized {
                        self.openGallary()
                    }
                    
                })
            }
        case .denied,.restricted:
            // alert para ir a ajustes
            let alert = UIAlertController(title: "Se necesitan permisos", message: "Se necesitan permisos para acceder a la galeria", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Cancelar", style: .cancel, handler: nil))
            alert.addAction(UIAlertAction(title: "Ir a ajustes", style: .destructive, handler: { (nil) in
                UIApplication.shared.open(NSURL(string:UIApplicationOpenSettingsURLString)! as URL, options: [:], completionHandler: nil)
            }))
            present(alert, animated: true)
            
        case .authorized:
            // abrir galeria
            openGallary()
        }
        
        
    }
    func openCamera(){
        picker!.allowsEditing = false
        picker!.sourceType = UIImagePickerControllerSourceType.camera
        present(picker!, animated: true, completion: nil)
    }
    func openGallary()
    {
        picker!.allowsEditing = false
        picker!.sourceType = UIImagePickerControllerSourceType.photoLibrary
        present(picker!, animated: true, completion: nil)
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
