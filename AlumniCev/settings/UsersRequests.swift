//
//  UsersRequests.swift
//  AlumniCev
//
//  Created by alumnos on 6/2/18.
//  Copyright © 2018 Victor Serrano. All rights reserved.
//

import Foundation
import Alamofire

func requestAllUsers(action: @escaping ()->()){
    let url = URL(string: URL_GENERAL + "users/allusers.json")
    
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
                users = arrayResult["data"] as? [[String:Any]]
                
                action()
            default:
                
                print(arrayResult["message"] as! String)
            }
        case .failure:
            
            print("Error :: \(String(describing: response.error))")
            //alert.showError(title: (String(describing: response.error), buttonTitle: "OK")
        }
    }
}
