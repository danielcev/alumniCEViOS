//
//  UsersViewController.swift
//  AlumniCev
//
//  Created by Daniel Plata on 22/1/18.
//  Copyright © 2018 Victor Serrano. All rights reserved.
//

import UIKit

class UsersViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var segmentedUsers: UISegmentedControl!
    
    @IBOutlet weak var usersTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        requestAllUsers {
            self.rechargeTable()
        }

        // Do any additional setup after loading the view.
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if users != nil{
            return users!.count
        }else{
            return 0
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 88
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "userCell", for: indexPath) as! UsersTableViewCell
        
        cell.nameLbl.text = users![indexPath.row]["username"] as? String
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("He pulsado la celda \(indexPath.row)")
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "UserDetailViewController") as! UserDetailViewController
        vc.username = users![indexPath.row]["username"] as? String
        
        self.present(vc, animated: true, completion: nil)

    }
    
    @IBAction func segmentedChanged(_ sender: Any) {
        switch segmentedUsers.selectedSegmentIndex{
            
        case 0:
            requestAllUsers {
                self.rechargeTable()
            }
            
        case 2:
            requestFriends {
                self.rechargeTable()
            }
            
        default:
            requestAllUsers {
                self.rechargeTable()
            }
        }
    }
    
    
    func rechargeTable(){
        usersTable.reloadData()
    }

}
