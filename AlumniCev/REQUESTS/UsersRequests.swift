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
    let url = URL(string: URL_GENERAL + "users/allusersapp.json")
    
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

func requestEditUser(id:Int,email:String?, phone:String?, birthday:String?, description:String?, photo:Data?, action: @escaping ()->()){
    let url = URL(string: URL_GENERAL + "users/update.json")
    
    var parameters: Parameters = ["id": id]
    
    if email != nil{
        parameters["email"] = email
    }
    
    if phone != nil{
        parameters["phone"] = phone
    }
    
    if birthday != nil{
        parameters["birthday"] = birthday
    }
    
    if description != nil{
        parameters["description"] = description
    }

    let token = getDataInUserDefaults(key:"token")
    
    let headers: HTTPHeaders = [
        "Authorization": token!,
        "Accept": "application/json"
    ]
    
    Alamofire.upload(multipartFormData: { multipartFormData in
        
        for (key, value) in parameters {
            multipartFormData.append(String(describing: value).data(using: .utf8)!, withName: key)
            
        }
        if photo != nil{
            multipartFormData.append(photo!, withName: "photo", fileName: "photo.jpeg", mimeType: "image/jpeg")
        }
        
    },
                     
                     to: url!,
                     headers:headers,
                     
                     encodingCompletion: { encodingResult in
                        
                        switch encodingResult {
                            
                        case .success(let upload, _, _):
                            upload.responseJSON { response in
                                
                                var arrayResult = response.result.value as! Dictionary<String, Any>
                                
                                if let result = response.result.value {
                                    
                                    let code = arrayResult["code"] as! Int
                                    
                                    switch code{
                                    case 200:
                                        action()
                                    case 400:
                                        print(arrayResult)
                                        
                                    default:
                                        print(arrayResult)
                                        
                                    }
                                    
                                }
                                
                            }
                        case .failure(let encodingError):
                            print(encodingError)
                            // your implementation
                        }
    })
}
