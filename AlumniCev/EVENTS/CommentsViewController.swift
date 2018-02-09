//
//  CommentsViewController.swift
//  AlumniCev
//
//  Created by Daniel Plata on 8/2/18.
//  Copyright © 2018 Victor Serrano. All rights reserved.
//

import UIKit
import Alamofire
import CPAlertViewController

class CommentsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var id_event:Int?
    
    @IBOutlet weak var commentsTable: UITableView!
    
    @IBOutlet weak var photoUser: UIImageView!
    @IBOutlet weak var commentTxF: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return comments!.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 175
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "commentCell", for: indexPath) as! CommentsTableViewCell
        
        let comment = comments![indexPath.row]
        
        cell.usernameLbl.text = comment["username"] as? String
        cell.descriptionTxV.text = comment["description"] as? String
        
        if comment["photo"] as? String != nil{
            requestImageComment(url: (comment["photo"] as? String)!, image: cell.imageUser)
        }else{
            cell.imageUser.image = UIImage(named: "userdefaulticon")
        }
        
        cell.imageUser.layer.cornerRadius = cell.imageUser.frame.size.width/2
        cell.imageUser.layer.masksToBounds = true

        return cell
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
    @IBAction func backAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func sendCommentAction(_ sender: Any) {
        
        requestCreateComment(title: "ComentarioTest", description: commentTxF.text!, id_event: self.id_event!){
            
            let alert = CPAlertViewController()
            
            alert.showSuccess(title: "Éxito", message: "Comentario creado!", buttonTitle: "OK", action: { (nil) in
                requestEvent(id: self.id_event!) {
                    requestEvent(id: self.id_event!) {
                        self.commentsTable.reloadData()
                        
                        self.commentTxF.text = ""
                    }
                    
                }
            })
            
            
        }
        
    }
    
}
