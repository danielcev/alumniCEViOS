//
//  myAppTools.swift
//  AlumniCev
//
//  Created by alumnos on 9/1/18.
//  Copyright © 2018 Victor Serrano. All rights reserved.
//

import Foundation

var userRegistered:[String:String] = [:]
let defaults = UserDefaults.standard

let events:[[String:String]] = [
    
    ["title":"Evento 1",
     "description":"Este es el evento 1"],
    
    ["title":"Evento 2",
     "description":"Este es el evento 2"],
    
    ["title":"Evento 3",
     "description":"Este es el evento 3"],
    
    ["title":"Evento 4",
     "description":"Este es el evento 4"],
    
    ["title":"Evento 5",
     "description":"Este es el evento 5"]

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
    
    userRegistered = defaults.object(forKey: "userRegistered") as! [String:String]
    
    return userRegistered[key]
}


func isValidEmail(YourEMailAddress: String) -> Bool {
    let REGEX: String
    REGEX = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,6}"
    return NSPredicate(format: "SELF MATCHES %@", REGEX).evaluate(with: YourEMailAddress)
}
func isValidPhone(phone: String) -> Bool {
    
    return NSPredicate(format: "SELF MATCHES %@", "\\d{9}").evaluate(with: phone)
    
}
let URL_GENERAL = "http://h2744356.stratoserver.net/solfamidas/alumniCEV/public/index.php/"
