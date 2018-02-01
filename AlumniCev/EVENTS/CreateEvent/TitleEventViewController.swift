//
//  TitleEventViewController.swift
//  AlumniCev
//
//  Created by alumnos on 24/1/18.
//  Copyright © 2018 Victor Serrano. All rights reserved.
//

import UIKit

class TitleEventViewController: UIViewController, UITextViewDelegate {
    
    @IBOutlet weak var addTitleLbl: UILabel!
    @IBOutlet weak var addDescriptionLbl: UILabel!
    @IBOutlet weak var titleTxF: UITextField!
    @IBOutlet weak var descriptionTxF: UITextView!
    
    @IBOutlet weak var countTitleLbl: UILabel!
    @IBOutlet weak var countDescriptionLbl: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        descriptionTxF.delegate = self
        
        setStyle()

        
    }
    
    @IBAction func titleChanged(_ sender: UITextField) {
        countTitleLbl.text = String(describing: sender.text!.count) + "/100"
        
        if sender.text!.count > 100{
            countTitleLbl.textColor = UIColor.red
        }else{
            countTitleLbl.textColor = cevColor
        }

    }
    
    func textViewDidChange(_ textView: UITextView){
        countDescriptionLbl.text = String(describing: textView.text!.count) + "/1000"
        
        if textView.text!.count > 1000{
            countDescriptionLbl.textColor = UIColor.red
        }else{
            countDescriptionLbl.textColor = cevColor
        }
        
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
        
        if titleTxF.text != ""{
            eventCreated?.titleEvent = titleTxF.text
        }
        
        if descriptionTxF.text != ""{
            eventCreated?.descriptionEvent = descriptionTxF.text
        }

    }
    
    //función para ocultar el teclado cuando pulsas fuera de él
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
  

}
