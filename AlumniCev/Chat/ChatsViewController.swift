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
    
    
    @IBOutlet weak var userImage: UITableView!
    @IBOutlet weak var userName: UITableView!
    
    var chats = [Dictionary<String,Any>()]
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return chats.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        return UITableViewCell()
    }
    
    @IBAction func goToCreateChat(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "CreateChatViewController") as! CreateChatViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    @IBAction func goToMessages(){
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "MessagesViewController") as! MessagesViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getChatsRequest(){
        let url = URL(string: URL_GENERAL + "chats/chats")
        
        let token = getDataInUserDefaults(key:"token")
        
        let headers: HTTPHeaders = [
            "Authorization": token!,
            "Accept": "application/json"
        ]
        
        Alamofire.request(url!, method: .get, headers: headers).responseJSON{response in
            
            if (response.result.value != nil){
                
                var arrayResult = response.result.value as! Dictionary<String, Any>
                var arrayData = arrayResult["data"]! as! Dictionary<String,Any>
                
                switch response.result {
                case .success:
                    switch arrayResult["code"] as! Int{
                    case 200:
                        //chats = arrayData
                        break
                    default:
                        break

                    }
                case .failure:
                    print("Error :: \(String(describing: response.error))")

                }
            }
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        //goToMessages()
    }
}
