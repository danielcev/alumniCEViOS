//
//  UsersViewController.swift
//  AlumniCev
//
//  Created by Daniel Plata on 22/1/18.
//  Copyright © 2018 Victor Serrano. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

class UsersViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    
    @IBOutlet weak var notFriendsLbl: UILabel!
    
    @IBOutlet var completView: UIView!
    @IBOutlet weak var spinner: NVActivityIndicatorView!
    @IBOutlet weak var segmentedUsers: UISegmentedControl!
    
    @IBOutlet weak var usersTable: UITableView!
    
    var listSelected:String = "users"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        notFriendsLbl.text = "notFriends".localized()
        
        requestAllUsers {
            self.rechargeTable()
        }

        // Do any additional setup after loading the view.
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        switch listSelected {
        case "users":
            if users != nil{
                return users!.count
            }else{
                return 0
            }
        case "groups":
            if groups != nil{
                return groups.count
            }else{
                return 0
            }
        case "friends":
            if users != nil{
                return users!.count
            }else{
                
                return 0
            }
        case "requests":
            if requests != nil{
                return requests!.count
            }else{
                return 0
            }
        default:
            if users != nil{
                return users!.count
            }else{
                return 0
            }
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 88
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "userCell", for: indexPath) as! UsersTableViewCell
        
        switch listSelected {
        case "users":
            cell.nameLbl.text = users![indexPath.row]["username"] as? String
            break
        case "groups":
            cell.nameLbl.text = groups[indexPath.row]["name"]
            break
        case "friends":
            cell.nameLbl.text = users![indexPath.row]["username"] as? String
            break
        case "requests":
            
            let id = getDataInUserDefaults(key: "id")!
            
            let sendUser = requests![indexPath.row]["username"] as! String
            
            if requests![indexPath.row]["state"] as! String == "1"{
                
                
                if requests![indexPath.row]["id_user_receive"] as? String == id{
                    cell.nameLbl.text = "\(sendUser) te ha enviado una petición de amistad"
                }else{
                    cell.nameLbl.text = "Has enviado una petición a \(sendUser)"
                }
                
            }else{
                
                if requests![indexPath.row]["id_user_receive"] as? String == id{
                    cell.nameLbl.text = "Has aceptado la petición de \(sendUser). Ya sois amigos!"
                }else{
                    cell.nameLbl.text = "\(sendUser) ha aceptado tu petición. Ya sois amigos!"
                }
                
            }
            
            break
        default:
            cell.nameLbl.text = users![indexPath.row]["username"] as? String
            break
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        switch listSelected {
        case "groups":
            break
        case "requests":
            break
        default:
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "UserDetailViewController") as! UserDetailViewController
            vc.user = (users![indexPath.row] as Dictionary<String,Any>?)! as! Dictionary<String, Any>
            
            self.present(vc, animated: true, completion: nil)
        }

    }
    
    @IBAction func segmentedChanged(_ sender: Any) {
        startSpinner()
        switch segmentedUsers.selectedSegmentIndex{
            
        case 0:
            listSelected = "users"
            requestAllUsers {
                self.rechargeTable()
                self.stopSpinner()
            }
            
        case 1:
            listSelected = "groups"
            requestGroups {
                self.rechargeTable()
                self.stopSpinner()
            }
            
        case 2:
            listSelected = "friends"
            requestFriends {
                self.rechargeTable()
                self.stopSpinner()
                
                if users?.count == 0{
                    self.usersTable.isHidden = true
                    self.notFriendsLbl.isHidden = false
                }
            }
            
        case 3:
            listSelected = "requests"
            requestRequests {
                self.rechargeTable()
                self.stopSpinner()
            }
            
        default:
            listSelected = "users"
            requestAllUsers {
                self.rechargeTable()
                self.stopSpinner()
            }
        }
        stopSpinner()
    }
    
    
    func rechargeTable(){
        usersTable.isHidden = false
        notFriendsLbl.isHidden = true
        usersTable.reloadData()
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
