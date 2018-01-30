//
//  GetEventsRequest.swift
//  AlumniCev
//
//  Created by alumnos on 25/1/18.
//  Copyright © 2018 Victor Serrano. All rights reserved.
//

import Foundation
import Alamofire

func createEventRequest(title:String, description:String, idType:Int, idGroup:[Int], controller:UIViewController, lat:Float = 0.0, lon:Float = 0.0){
    let url = URL(string: URL_GENERAL + "events/create")
    
    var parameters: Parameters = ["title": title, "description": description, "id_type":idType, "id_group":idGroup]
    
    if lat != 0.0 && lon != 0.0{
        parameters["lat"] = lat
        parameters["lon"] = lon
    }
    
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
                
                (controller as! LocalizationCreateEventViewController).createAlert()
                
            default:
                
                print(arrayResult["message"] as! String)
            }
        case .failure:
            
            print("Error :: \(String(describing: response.error))")
            //alert.showError(title: (String(describing: response.error), buttonTitle: "OK")
        }
    }
}

func requestEvents(type:Int, controller:UIViewController){
    let url = URL(string: URL_GENERAL + "events/events.json")
    
    let parameters: Parameters = ["type":type]
    
    let token = getDataInUserDefaults(key:"token")
    
    let headers: HTTPHeaders = [
        "Authorization": token!,
        "Accept": "application/json"
    ]
    
    Alamofire.request(url!, method: .get, parameters: parameters, headers: headers).responseJSON{response in
        
        var arrayResult = response.result.value as! Dictionary<String, Any>
        
        switch response.result {
        case .success:
            switch arrayResult["code"] as! Int{
            case 200:
                events = arrayResult["data"] as! [[String:Any]]
                
                (controller as! EventsViewController).reloadTable()

            default:
         (controller as! EventsViewController).notResults()
                print(arrayResult["message"] as! String)
            }
        case .failure:
            
            print("Error :: \(String(describing: response.error))")
            //alert.showError(title: (String(describing: response.error), buttonTitle: "OK")
        }
    }
}

func requestFindEvents(search:String, controller:UIViewController){
    let url = URL(string: URL_GENERAL + "events/find.json")
    
    let parameters: Parameters = ["search":search]
    
    let token = getDataInUserDefaults(key:"token")
    
    let headers: HTTPHeaders = [
        "Authorization": token!,
        "Accept": "application/json"
    ]
    
    Alamofire.request(url!, method: .get, parameters: parameters, headers: headers).responseJSON{response in
        
        var arrayResult = response.result.value as! Dictionary<String, Any>
        
        switch response.result {
        case .success:
            switch arrayResult["code"] as! Int{
            case 200:
                events = arrayResult["data"] as! [[String : Any]]
                
                (controller as! EventsViewController).reloadTable()
                
            default:
                (controller as! EventsViewController).notResults()
                print(arrayResult["message"] as! String)
            }
        case .failure:
            
            print("Error :: \(String(describing: response.error))")
            //alert.showError(title: (String(describing: response.error), buttonTitle: "OK")
        }
    }
}
