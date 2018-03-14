//
//  CreateChatViewController.swift
//  AlumniCev
//
//  Created by alumnos on 14/3/18.
//  Copyright © 2018 Victor Serrano. All rights reserved.
//

import UIKit
import Alamofire

class CreateChatViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    var userstochat:[Dictionary<String,Any>] = []
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (userstochat.count)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "userToChat") as! CellUserToChatViewController
        
        cell.userName.text = userstochat[indexPath.row]["username"] as? String
        cell.id_user = userstochat[indexPath.row]["id"] as? Int
        if userstochat[indexPath.row]["photo"] as? String != nil{
            //Añadir imagen
            let remoteImageURL = URL(string: (userstochat[indexPath.row]["photo"] as? String)!)!
            
            Alamofire.request(remoteImageURL).responseData { (response) in
                if response.error == nil {
                    print(response.result)
                    
                    if let data = response.data {
                        cell.userImage.image = UIImage(data: data)
                    }
                }
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let alert = UIAlertController(title: "Iniciar nuevo chat", message: "", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (nil) in
            //peticion crear chat con id user
            let id_user = self.userstochat[indexPath.row]["id"] as? Int
            createChatRequesst(id_user: id_user!, action: { (chat) in
                // ir a la pestaña de mesajes con el id del chat en la respuesta
            })
        }))
        alert.addAction(UIAlertAction(title: "cancelar", style: .cancel, handler: nil))
        self.present(alert, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        getUsersToChat { (users) in
            self.userstochat = users!
            self.tableView.reloadData()
        }
    }

   

}
