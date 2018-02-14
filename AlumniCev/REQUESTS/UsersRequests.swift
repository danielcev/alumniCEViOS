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
        
        if (response.result.value != nil){
            
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
}

func requestFriends(action: @escaping ()->()){
    let url = URL(string: URL_GENERAL + "users/friends.json")
    
    let token = getDataInUserDefaults(key:"token")
    
    let headers: HTTPHeaders = [
        "Authorization": token!,
        "Accept": "application/json"
    ]
    
    Alamofire.request(url!, method: .get, headers: headers).responseJSON{response in
        
        if (response.result.value != nil){
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
                
            }
        }

    }
}

func requestUserById(id:Int, action: @escaping ()->()){
    let url = URL(string: URL_GENERAL + "users/userbyid.json")
    
    let token = getDataInUserDefaults(key:"token")
    
    let parameters:Parameters = ["id":id]
    
    let headers: HTTPHeaders = [
        "Authorization": token!,
        "Accept": "application/json"
    ]
    
    Alamofire.request(url!, method: .get, parameters:parameters, headers: headers).responseJSON{response in
        
        if (response.result.value != nil){
            
            var arrayResult = response.result.value as! Dictionary<String, Any>
            
            switch response.result {
            case .success:
                switch arrayResult["code"] as! Int{
                case 200:
                    
                    var arrayData = arrayResult["data"] as! Dictionary<String,Any>
                   
                    friend = arrayData["friend"] as? Dictionary<String,Any>
                    
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
}

func requestRequests(action: @escaping ()->()){
    let url = URL(string: URL_GENERAL + "users/requests.json")
    
    let token = getDataInUserDefaults(key:"token")
    
    let headers: HTTPHeaders = [
        "Authorization": token!,
        "Accept": "application/json"
    ]
    
    Alamofire.request(url!, method: .get, headers: headers).responseJSON{response in
        
        if (response.result.value != nil){
        
            var arrayResult = response.result.value as! Dictionary<String, Any>
            
            switch response.result {
            case .success:
                switch arrayResult["code"] as! Int{
                case 200:
                    
                    let arrayData = arrayResult["data"] as? [String:Any]
                    
                    requests = arrayData!["requests"] as? [Dictionary<String, Any>]
                    
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
}

func requestChangePassword(lastPassword:String, password:String, action: @escaping ()->(), fail: @escaping ()->()){
    
    let url = URL(string: URL_GENERAL + "users/changepassword.json")
    
    let token = getDataInUserDefaults(key:"token")
    
    let headers: HTTPHeaders = [
        "Authorization": token!,
        "Accept": "application/json"
    ]
    
    let parameters: Parameters = ["lastpassword": lastPassword,
                                  "password":password]
    
    Alamofire.request(url!, method: .post, parameters: parameters, headers: headers).responseJSON{response in

        if (response.result.value != nil){
            
            var arrayResult = response.result.value as! Dictionary<String, Any>

            switch response.result {
            case .success:
                switch arrayResult["code"] as! Int{
                case 200:
                    action()
                default:
                    
                    fail()

                }
            case .failure:
                
                print("Error :: \(String(describing: response.error))")
            
            }
        }
    }
}

func sendRequestFriend(id_user:Int, action: @escaping ()->()){
    let url = URL(string: URL_GENERAL + "users/sendRequest.json")
    
    let token = getDataInUserDefaults(key:"token")
    
    let parameters:Parameters = ["id_user":id_user]
    
    let headers: HTTPHeaders = [
        "Authorization": token!,
        "Accept": "application/json"
    ]
    
    Alamofire.request(url!, method: .post, parameters:parameters, headers: headers).responseJSON{response in
        
        if (response.result.value != nil){
            
            var arrayResult = response.result.value as! Dictionary<String, Any>
            
            switch response.result {
            case .success:
                switch arrayResult["code"] as! Int{
                case 200:
                    
                    action()
                default:
                    
                    print(arrayResult["message"] as! String)
                }
            case .failure:
                
                print("Error :: \(String(describing: response.error))")
            
            }
        }
    }
}

func requestEditUser(id:Int,email:String?, phone:String?, birthday:String?, description:String?, photo:Data?, phoneprivacity:Int?, localizationprivacity:Int?, action: @escaping ()->()){
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
    
    if phoneprivacity != nil{
        parameters["phoneprivacity"] = phoneprivacity
    }
    
    if localizationprivacity != nil{
        parameters["localizationprivacity"] = localizationprivacity
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
                
                if (response.result.value != nil){
                
                    var arrayResult = response.result.value as! Dictionary<String, Any>
                    
                    if response.result.value != nil {
                        
                        let code = arrayResult["code"] as! Int
                        
                        switch code{
                        case 200:
                            action()
                            print("Usuario editado")
                        case 400:
                            print(arrayResult)
                            
                        default:
                            print(arrayResult)
                            
                        }
                        
                    }
                }
                
            }
        case .failure(let encodingError):
            print(encodingError)
            // your implementation
        }
    })
}
