//
//  TitleEventViewController.swift
//  AlumniCev
//
//  Created by alumnos on 24/1/18.
//  Copyright © 2018 Victor Serrano. All rights reserved.
//

import UIKit

class TitleEventViewController: UIViewController {
    
    @IBOutlet weak var addTitleLbl: UILabel!
    @IBOutlet weak var addDescriptionLbl: UILabel!
    @IBOutlet weak var titleTxF: UITextField!
    @IBOutlet weak var descriptionTxF: UITextView!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setStyle()

        // Do any additional setup after loading the view.
    }
    
    func setStyle(){
        titleTxF.layer.borderColor = cevColor.cgColor
        descriptionTxF.layer.borderColor = cevColor.cgColor
        
        titleTxF.layer.borderWidth = 1.0
        descriptionTxF.layer.borderWidth = 1.0
        
        titleTxF.layer.cornerRadius = 15.0
        descriptionTxF.layer.cornerRadius = 15.0
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        eventCreated?.titleEvent = titleTxF.text
        eventCreated?.descriptionEvent = descriptionTxF.text
    }
    
    //función para ocultar el teclado cuando pulsas fuera de él
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
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
