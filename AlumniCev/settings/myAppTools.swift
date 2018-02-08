//
//  myAppTools.swift
//  AlumniCev
//
//  Created by alumnos on 9/1/18.
//  Copyright © 2018 Victor Serrano. All rights reserved.
//

import Foundation
import UIKit

var userRegistered:[String:String] = [:]
let defaults = UserDefaults.standard

var eventCreated:Event?

let cevColor:UIColor = hexStringToUIColor(hex:"008D9D")

var groups:[Dictionary<String,String>] = []

var types:[Dictionary<String,String>] = []

var addressResponse:Dictionary<String,Any>?

var comments:[Dictionary<String,Any>]?

var users:[Dictionary<String,Any>]?

var events:[[String:Any]] = [
    
    ["title":"Evento 1",
     "description":"Lorem ipsum dolor sit amet, consectetur adipiscing elit. Maecenas dictum nulla turpis. Morbi dignissim arcu orci, in imperdiet dolor faucibus a. Ut quis arcu quis eros vulputate dapibus nec bibendum dolor. Sed fermentum vehicula purus et iaculis. Curabitur vitae nunc lacinia, fringilla justo congue, mattis neque. Class aptent taciti sociosqu ad litora torquent per conubia nostra, per inceptos himenaeos. Donec ante elit, iaculis sagittis mollis id, fringilla eget felis.",
     "lat":40.425366,
     "lon":-3.656443],
    
    ["title":"Evento 2",
     "description":"Este es el evento 2",
     "lat":51.5287352,
     "lon":-0.3817844]

]

func saveDataInUserDefaults(value:String, key:String){
    
    if defaults.object(forKey: "userRegistered") == nil {
        defaults.set(userRegistered, forKey: "userRegistered")
    }
    userRegistered = defaults.object(forKey: "userRegistered") as! [String:String]
    userRegistered.updateValue(value, forKey: key)
    
    defaults.set(userRegistered, forKey: "userRegistered")
    defaults.synchronize()
    
}

func getDataInUserDefaults(key:String) -> String?{
    
    if defaults.object(forKey: "userRegistered") != nil{
        userRegistered = defaults.object(forKey: "userRegistered") as! [String:String]
        
        return userRegistered[key]
    }else{
        return nil
    }
    
}

func clearUserDefaults(){
    defaults.set(nil, forKey: "userRegistered")
}


func isValidEmail(YourEMailAddress: String) -> Bool {
    let REGEX: String
    REGEX = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,6}"
    return NSPredicate(format: "SELF MATCHES %@", REGEX).evaluate(with: YourEMailAddress)
}

func validateUrl (urlString: String?) -> Bool {
    let urlRegEx = "(http|https)://((\\w)*|([0-9]*)|([-|_])*)+([\\.|/]((\\w)*|([0-9]*)|([-|_])*))+"
    return NSPredicate(format: "SELF MATCHES %@", urlRegEx).evaluate(with: urlString)
}

func isValidPhone(phone: String) -> Bool {
    
    return NSPredicate(format: "SELF MATCHES %@", "\\d{9}").evaluate(with: phone)
    
}
let URL_GENERAL = "http://h2744356.stratoserver.net/solfamidas/alumniCEV/public/index.php/"

func hexStringToUIColor (hex:String) -> UIColor {
    var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
    
    if (cString.hasPrefix("#")) {
        cString.remove(at: cString.startIndex)
    }
    
    if ((cString.count) != 6) {
        return UIColor.gray
    }
    
    var rgbValue:UInt32 = 0
    Scanner(string: cString).scanHexInt32(&rgbValue)
    
    return UIColor(
        red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
        green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
        blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
        alpha: CGFloat(1.0)
    )
}
