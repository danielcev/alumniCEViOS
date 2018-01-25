//
//  GetEventsRequest.swift
//  AlumniCev
//
//  Created by alumnos on 25/1/18.
//  Copyright © 2018 Victor Serrano. All rights reserved.
//

import Foundation
import Alamofire

func createEventRequest(title:String, description:String, idType:Int, idGroup:[Int]){
    let url = URL(string: URL_GENERAL + "events/create")
    
    let parameters: Parameters = ["type":idType, "id_group":idGroup]
    
    let token = getDataInUserDefaults(key:"token")
    
    let headers: HTTPHeaders = [
        "Authorization": token!,
        "Accept": "application/json"
    ]
    
    Alamofire.request(url!, method: .post, parameters: parameters, headers: headers).responseJSON{response in
        
        var arrayResult = response.result.value as! Dictionary<String, Any>
        
        print(response)
        
        switch response.result {
        case .success:
            switch arrayResult["code"] as! Int{
            case 200:
                events = arrayResult["data"] as! [[String:Any]]
                
            default:
                
                print(arrayResult["message"] as! String)
            }
        case .failure:
            
            print("Error :: \(String(describing: response.error))")
            //alert.showError(title: (String(describing: response.error), buttonTitle: "OK")
        }
    }
}

func requestEvents(type:Int){
    let url = URL(string: URL_GENERAL + "events/events.json")
    
    let parameters: Parameters = ["type":type]
    
    let token = getDataInUserDefaults(key:"token")
    
    let headers: HTTPHeaders = [
        "Authorization": token!,
        "Accept": "application/json"
    ]
    
    Alamofire.request(url!, method: .get, parameters: parameters, headers: headers).responseJSON{response in
        
        var arrayResult = response.result.value as! Dictionary<String, Any>
        
        print(response)
        
        switch response.result {
        case .success:
            switch arrayResult["code"] as! Int{
            case 200:
                events = arrayResult["data"] as! [[String:Any]]

            default:
         
                print(arrayResult["message"] as! String)
            }
        case .failure:
            
            print("Error :: \(String(describing: response.error))")
            //alert.showError(title: (String(describing: response.error), buttonTitle: "OK")
        }
    }
}
