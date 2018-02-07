//
//  UserDetailViewController.swift
//  AlumniCev
//
//  Created by Daniel Plata on 7/2/18.
//  Copyright © 2018 Victor Serrano. All rights reserved.
//

import UIKit

class UserDetailViewController: UIViewController {
    
    @IBOutlet weak var usernameLbl: UILabel!
    
    var username:String?

    override func viewDidLoad() {
        super.viewDidLoad()
        usernameLbl.text = username!
        // Do any additional setup after loading the view.
    }

    @IBAction func backAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
