//
//  WebUrlViewController.swift
//  AlumniCev
//
//  Created by alumnos on 1/2/18.
//  Copyright © 2018 Victor Serrano. All rights reserved.
//

import UIKit
import CPAlertViewController

class WebUrlViewController: UIViewController {

    @IBOutlet weak var webTxF: UITextField!
    @IBOutlet weak var webLbl: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func addWeb(_ sender: Any) {
        if validateUrl(urlString: webTxF.text){
            eventCreated?.url = webTxF.text
            print("URL añadida")
        }else{
            let alert = CPAlertViewController()
            alert.showError(title: "La URL no tiene un formato válido", buttonTitle: "OK")
        }
    }

}
