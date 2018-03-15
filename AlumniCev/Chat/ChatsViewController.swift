//
//  ChatsViewController.swift
//  AlumniCev
//
//  Created by alumnos on 12/3/18.
//  Copyright © 2018 Victor Serrano. All rights reserved.
//

import UIKit
import Alamofire

class ChatsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    
    
    @IBOutlet weak var tableView: UITableView!
    
    var chatsToShow = [Dictionary<String,Any>]()
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return chatsToShow.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //if chatsToShow != nil{
        let cell = tableView.dequeueReusableCell(withIdentifier: "userCell") as! CellChatsTableViewCell
        var user = chatsToShow[indexPath.row]["user"] as! Dictionary<String,Any>
        cell.userNameLabel.text = user["username"] as? String
        // cargar foto por defecto
        cell.userImage.image = UIImage(named: "userdefaulticon")
        // foto
        if user["photo"] as? String != nil{
            //Añadir imagen
            let remoteImageURL = URL(string: (user["photo"] as? String)!)!
            
            Alamofire.request(remoteImageURL).responseData { (response) in
                if response.error == nil {
                    print(response.result)
                    
                    if let data = response.data {
                        cell.userImage.image = UIImage(data: data)
                    }
                }
            }
            
        }
        cell.userImage.layer.cornerRadius = cell.userImage.frame.size.height/2
        cell.userImage.layer.masksToBounds = true
        cell.userImage.layer.borderColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        cell.userImage.layer.borderWidth = 1
        // ultimo mensaje
        let chat = chatsToShow[indexPath.row]
        
        if chat["message"] as? Dictionary<String,Any> != nil{
            let message = chat["message"] as! Dictionary<String,Any>
            cell.lastMessageLabel.text = message["description"] as? String
            // fecha
            cell.dateLabel.text = message["date"] as? String
        }
        
        return cell
        //}
        
    }
    
    @IBAction func goToCreateChat(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "CreateChatViewController") as! CreateChatViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 111
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "MessagesViewController") as! MessagesViewController
        let chat = chatsToShow[indexPath.row]
        // el id llega mal al listado con los mensajes
        let id_chat:String = String(describing: chat["id"]!)
        vc.id_chat = id_chat
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func reloadData(_ sender: Any) {
        // peticion get chats
        getChatsRequest { (chats) in
            
            self.chatsToShow = chats!
            self.tableView.reloadData()
            
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        reloadData((Any).self)
    }
}
