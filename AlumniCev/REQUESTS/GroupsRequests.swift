//
//  GroupsRequests.swift
//  AlumniCev
//
//  Created by alumnos on 26/1/18.
//  Copyright © 2018 Victor Serrano. All rights reserved.
//

import Foundation
import Alamofire

func requestTypes(controller:UIViewController){
    let url = URL(string: URL_GENERAL + "events/types.json")

    let token = getDataInUserDefaults(key:"token")
    
    let headers: HTTPHeaders = [
        "Authorization": token!,
        "Accept": "application/json"
    ]
    
    Alamofire.request(url!, method: .get, headers: headers).responseJSON{response in
        
        var arrayResult = response.result.value as! Dictionary<String, Any>
        
        switch response.result {
        case .success:
            switch arrayResult["code"] as! Int{
            case 200:
                types = arrayResult["data"] as! [Dictionary<String,String>]
                
            default:
                
                print(arrayResult["message"] as! String)
            }
        case .failure:
            
            print("Error :: \(String(describing: response.error))")
            //alert.showError(title: (String(describing: response.error), buttonTitle: "OK")
        }
    }
}

func requestGroups(controller:UIViewController){
    let url = URL(string: URL_GENERAL + "groups/groups.json")
    
    let token = getDataInUserDefaults(key:"token")
    
    let headers: HTTPHeaders = [
        "Authorization": token!,
        "Accept": "application/json"
    ]
    
    Alamofire.request(url!, method: .get, headers: headers).responseJSON{response in
        
        var arrayResult = response.result.value as! Dictionary<String, Any>
        
        switch response.result {
        case .success:
            switch arrayResult["code"] as! Int{
            case 200:
                groups = arrayResult["data"] as! [Dictionary<String,String>]
                
                (controller as! GroupEventViewController).rechargeTable()
                
            default:
                
                print(arrayResult["message"] as! String)
            }
        case .failure:
            
            print("Error :: \(String(describing: response.error))")
            //alert.showError(title: (String(describing: response.error), buttonTitle: "OK")
        }
    }
}
