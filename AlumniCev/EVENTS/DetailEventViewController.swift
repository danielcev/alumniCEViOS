//
//  DetailEventViewController.swift
//  AlumniCev
//
//  Created by alumnos on 23/1/18.
//  Copyright © 2018 Victor Serrano. All rights reserved.
//

import UIKit
import Alamofire
import CPAlertViewController

class DetailEventViewController: UIViewController{
    
    var idReceived: Int = 0

    @IBOutlet weak var commentView: UIView!
    
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var secondTitleLbl: UILabel!
    
    @IBOutlet weak var descriptionText: UITextView!
    
    @IBOutlet weak var imageViewEvent: UIImageView!
    
    @IBOutlet weak var webBtn: UIButton!
    @IBOutlet weak var localizationBtn: UIButton!
    @IBOutlet weak var photoUser: UIImageView!
    
    @IBOutlet weak var commentTxF: UITextField!
    @IBOutlet weak var usernameLbl: UILabel!
    @IBOutlet weak var descriptionTxF: UITextView!
    @IBOutlet weak var photoUserComment: UIImageView!
    
    @IBOutlet weak var seeCommentsBtn: UIButton!
    @IBOutlet weak var deleteEventBtn: UIButton!
    
    @IBOutlet weak var dateComment: UILabel!
    
    var lat:Float?
    var lon:Float?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.dateComment.isHidden = true
        
        styleTxF(textfield: commentTxF)
        
        seeCommentsBtn.layer.cornerRadius = seeCommentsBtn.layer.frame.height / 2
        
        if(getDataInUserDefaults(key: "photo") != nil){
            let photo:Data = Data(base64Encoded: getDataInUserDefaults(key: "photo")!)!
            photoUser.image = UIImage(data: photo)
            
        }
        
        photoUser.layer.cornerRadius = photoUser.frame.size.width/2
        photoUser.layer.masksToBounds = true

        requestEvent(id: Int(events[idReceived]["id"] as! String)!) {
            if(comments!.count > 0){
                self.setComment()
            }
        }
        
        //Ajustar TextView a contenido
        
        descriptionText.sizeToFit()
        descriptionText.isScrollEnabled = false
        
        imageViewEvent.clipsToBounds = true
        imageViewEvent.contentMode = .scaleAspectFill
        
        //Solo se muestra la información de localización si el evento la tiene
        if((events[idReceived]["lat"] as? String) != nil && (events[idReceived]["lon"] as? String) != nil){
        
            lat = Float(events[idReceived]["lat"] as! String)
            lon = Float(events[idReceived]["lon"] as! String)
            
            addressFromPosition(lat: lat!, lon: lon!, controller: self)
            
            localizationBtn.isHidden = false
        }else{
            localizationBtn.isHidden = true
            
        }
        
        if events[idReceived]["url"] as? String == nil{
            webBtn.isHidden = true
            
        }else{
            webBtn.isHidden = false
        }
        
        if events[idReceived]["image"] as? String == nil{
            switch events[idReceived]["id_type"] as! String {
            case "1":
                imageViewEvent.image = UIImage(named: "eventimage")
            case "2":
                imageViewEvent.image = UIImage(named: "jobofferimage")
            case "3":
                imageViewEvent.image = UIImage(named: "notificationimage")
            case "4":
                imageViewEvent.image = UIImage(named: "newsimage")
            default:
                imageViewEvent.image = UIImage(named: "eventimage")
            }
        }else{
            requestImage(url: (events[idReceived]["image"] as? String)!)
        }
        
        switch events[idReceived]["id_type"] as! String {
        case "1":
            titleLbl.text = "Event"
        case "2":
            titleLbl.text = "Job offer"
        case "3":
            titleLbl.text = "Notification"
        case "4":
            titleLbl.text = "Notice"
        default:
            titleLbl.text = "Event"
        }
        
        setInfoEvent()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func opendURL(_ sender: Any) {
        
        if let url = URL(string: (events[idReceived]["url"] as? String)!) {
            UIApplication.shared.open(url, options: [:])
        }
        
    }
    func setEvent(address:Address){
        setInfoEvent()
    }
    
    func setInfoEvent(){
        secondTitleLbl.text = events[idReceived]["title"] as? String
        descriptionText.text = events[idReceived]["description"] as? String
    }
    
    @IBAction func goToLocalization(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "EventLocalizationViewController") as! EventLocalizationViewController
        
        vc.lat = self.lat!
        vc.lon = self.lon!
        vc.titleEvent = (events[idReceived]["title"] as? String)!
        
        self.present(vc, animated: true, completion: nil)
    }
    
    @IBAction func backAction(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func requestImage(url:String){
        let remoteImageURL = URL(string: url)!
        
        // Use Alamofire to download the image
        Alamofire.request(remoteImageURL).responseData { (response) in
            if response.error == nil {
                print(response.result)
                
                if let data = response.data {
                    self.imageViewEvent.image = UIImage(data: data)
                }
            }
        }
    }
    
    func requestImageComment(url:String, image:UIImageView){
        let remoteImageURL = URL(string: url)!
        
        // Use Alamofire to download the image
        Alamofire.request(remoteImageURL).responseData { (response) in
            if response.error == nil {
                print(response.result)
                
                if let data = response.data {
                    image.image = UIImage(data: data)
                }
            }
        }
    }
    
    func setComment(){
        
        commentView.isHidden = false
        
        var lastComment = comments![(comments?.count)! - 1]
        
        self.usernameLbl.text = lastComment["username"] as? String
        self.descriptionTxF.text = lastComment["description"] as! String
        
        if lastComment["date"] as? String != nil{
            self.dateComment.isHidden = false
            self.dateComment.text = lastComment["date"] as? String
        }
        
        if lastComment["photo"] as? String != nil{
            requestImageComment(url: (lastComment["photo"] as? String)!, image: photoUserComment)
        }else{
            photoUserComment.image = UIImage(named: "userdefaulticon")
        }
        
        photoUserComment.layer.cornerRadius = photoUserComment.frame.size.width/2
        photoUserComment.layer.masksToBounds = true
        
        if comments!.count > 1{
            self.seeCommentsBtn.setTitle("Ver \(comments!.count) comentarios", for: .normal)
        }else{
            self.seeCommentsBtn.setTitle("Ver 1 comentario", for: .normal)
        }

    }
    
    @IBAction func sendCommentAction(_ sender: Any) {
        
        requestCreateComment(title: "ComentarioTest", description: commentTxF.text!, id_event: Int((events[idReceived]["id"] as? String)!)!){
            
            let alert = CPAlertViewController()
            
            alert.showSuccess(title: "Éxito", message: "Comentario creado!", buttonTitle: "OK", action: { (nil) in
                requestEvent(id: Int(events[self.idReceived]["id"] as! String)!) {
                    self.setComment()
                    
                    self.commentTxF.text = ""
                }
            })
            
            
        }
    
    }
    
    @IBAction func goToCommentsAction(_ sender: Any) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "CommentsViewController") as! CommentsViewController
        
        vc.id_event = Int(events[self.idReceived]["id"] as! String)!
        
        self.present(vc, animated: false, completion: nil)
    }
    
    func styleTxF(textfield:UITextField){
        
        let border = CALayer()
        let width = CGFloat(2.0)
        
        border.borderColor = cevColor.cgColor
        border.frame = CGRect(x: 0, y: 0, width:  textfield.frame.size.width, height: 1)
        
        border.borderWidth = width
        textfield.layer.addSublayer(border)
        textfield.layer.masksToBounds = true
        
        textfield.setValue(UIColor.init(red: 255/255, green: 255/255, blue: 255/255, alpha: 0.5), forKeyPath: "_placeholderLabel.textColor")
        
    }
    @IBAction func deleteEventAction(_ sender: Any) {
        
        let alert = UIAlertController(title: "Borrar evento", message: "Seguro que quieres borrar el evento?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancelar", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Borrar", style: .destructive, handler: { (nil) in
            print("borrar evento")
            requestDeleteEvent(id: Int(events[self.idReceived]["id"] as! String)!)

            }))
        self.present(alert, animated: true)
        

    }
    
}
