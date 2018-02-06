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

    @IBOutlet weak var infotitleLb: UILabel!
    @IBOutlet weak var titleTxtView: UITextView!
    
    @IBOutlet weak var descriptionTxF: UITextView!
    
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var countTitleLbl: UILabel!
    @IBOutlet weak var countDescriptionLbl: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        descriptionTxF.delegate = self
        titleTxtView.delegate = self
        
        addTitleLbl.text = "addTitle".localized()
        addDescriptionLbl.text = "addDescription".localized()
        infotitleLb.text = "infoTitle".localized()
        cancelButton.setTitle("cancel".localized(), for: .normal)
        
        setStyle()

        
    }
    
    func textViewDidChange(_ textView: UITextView){
        countDescriptionLbl.text = String(describing: descriptionTxF.text!.count) + "/2500"
        
        if descriptionTxF.text!.count > 2500{
            countDescriptionLbl.textColor = UIColor.red
        }else{
            countDescriptionLbl.textColor = cevColor
        }
        
        countTitleLbl.text = String(describing: titleTxtView.text!.count) + "/100"
        
        if titleTxtView.text!.count > 100{
            countTitleLbl.textColor = UIColor.red
        }else{
            countTitleLbl.textColor = cevColor
        }
        
    }
    
    func setStyle(){
        titleTxtView.layer.borderColor = cevColor.cgColor
        descriptionTxF.layer.borderColor = cevColor.cgColor
        
        titleTxtView.layer.borderWidth = 1.0
        descriptionTxF.layer.borderWidth = 1.0
        
        titleTxtView.layer.cornerRadius = 15.0
        descriptionTxF.layer.cornerRadius = 15.0
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        if titleTxtView.text != ""{
            eventCreated?.titleEvent = titleTxtView.text
        }
        
        if descriptionTxF.text != ""{
            eventCreated?.descriptionEvent = descriptionTxF.text
        }

    }
    @IBAction func cancelAction(_ sender: Any) {
         self.dismiss(animated: true, completion: nil)
    }
    
    //función para ocultar el teclado cuando pulsas fuera de él
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
  

}
