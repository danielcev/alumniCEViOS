//
//  CommentsRequests.swift
//  AlumniCev
//
//  Created by Daniel Plata on 8/2/18.
//  Copyright © 2018 Victor Serrano. All rights reserved.
//

import Foundation
import Alamofire

func requestCreateComment(title:String, description:String, id_event:Int, action:@escaping ()->()){
    let url = URL(string: URL_GENERAL + "comments/create.json")
    
    let parameters: Parameters = ["title":title, "description":description, "id_event": id_event]
    
    let token = getDataInUserDefaults(key:"token")
    
    let headers: HTTPHeaders = [
        "Authorization": token!,
        "Accept": "application/json"
    ]
    
    Alamofire.request(url!, method: .post, parameters: parameters, headers: headers).responseJSON{response in
        
        var arrayResult = response.result.value as! Dictionary<String, Any>
        
        switch response.result {
        case .success:
            switch arrayResult["code"] as! Int{
            case 200:
                
                action()
                print("comentario creado")
                
            default:
                
                print(arrayResult["message"] as! String)
            }
        case .failure:
            
            print("Error :: \(String(describing: response.error))")
            //alert.showError(title: (String(describing: response.error), buttonTitle: "OK")
        }
    }
}

func requestDeleteComment(id_comment:Int, action:@escaping ()->()){
    let url = URL(string: URL_GENERAL + "comments/delete.json")
    
    let parameters: Parameters = ["id_comment": id_comment]
    
    let token = getDataInUserDefaults(key:"token")
    
    let headers: HTTPHeaders = [
        "Authorization": token!,
        "Accept": "application/json"
    ]
    
    Alamofire.request(url!, method: .post, parameters: parameters, headers: headers).responseJSON{response in
        
        var arrayResult = response.result.value as! Dictionary<String, Any>
        
        switch response.result {
        case .success:
            switch arrayResult["code"] as! Int{
            case 200:
                
                action()
                print("comentario borrado")
                
            default:
                print(arrayResult["message"] as! String)
            }
        case .failure:
            print("Error :: \(String(describing: response.error))")
        }
    }
}
