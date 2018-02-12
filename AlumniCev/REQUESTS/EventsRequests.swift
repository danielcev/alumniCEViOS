//
//  GetEventsRequest.swift
//  AlumniCev
//
//  Created by alumnos on 25/1/18.
//  Copyright © 2018 Victor Serrano. All rights reserved.
//

import Foundation
import Alamofire

func createEventRequest(title:String, description:String, idType:Int, idGroup:[Int], controller:UIViewController, lat:Float?, lon:Float?, image:Data?, urlEvent:String?){
    let url = URL(string: URL_GENERAL + "events/create.json")
    
    var parameters: Parameters = ["title": title, "description": description, "id_type":idType]
    
    if lat != nil && lon != nil{
        parameters["lat"] = lat
        parameters["lon"] = lon
    }
    
    if url != nil{
        parameters["url"] = urlEvent
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
        for value in idGroup{
            let clave = "id_group[" + String(value) + "]"
            print(clave)
            let valor = String(value)
            multipartFormData.append(String(describing: valor).data(using: .utf8)!, withName: clave)
        }
        
        if image != nil{
            multipartFormData.append(image!, withName: "image", fileName: "photo.jpeg", mimeType: "image/jpeg")
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
                                    
                                    if let result = response.result.value {
                                        
                                        print(result)
                                        
                                        let code = arrayResult["code"] as! Int
                                        
                                        switch code{
                                        case 200:
                                            events = arrayResult["data"] as! [[String:Any]]
                                            
                                            (controller as! LocalizationCreateEventViewController).createAlert(type:"success", title:"eventCreated".localized(), message: "eventCreatedSuccess".localized())
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

func requestEvents(type:Int, controller:UIViewController){
    let url = URL(string: URL_GENERAL + "events/events.json")
    
    let parameters: Parameters = ["type":type]
    
    let token = getDataInUserDefaults(key:"token")
    
    let headers: HTTPHeaders = [
        "Authorization": token!,
        "Accept": "application/json"
    ]
    
    Alamofire.request(url!, method: .get, parameters: parameters, headers: headers).responseJSON{response in
        
        if (response.result.value != nil){
        
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
}

func requestEvent(id:Int, action: @escaping () -> ()){
    let url = URL(string: URL_GENERAL + "events/event.json")
    
    let parameters: Parameters = ["id":id]
    
    let token = getDataInUserDefaults(key:"token")
    
    let headers: HTTPHeaders = [
        "Authorization": token!,
        "Accept": "application/json"
    ]
    
    Alamofire.request(url!, method: .get, parameters: parameters, headers: headers).responseJSON{response in
        
        if (response.result.value != nil){
        
            var arrayResult = response.result.value as! Dictionary<String, Any>
            
            print(response)
            
            switch response.result {
            case .success:
                switch arrayResult["code"] as! Int{
                case 200:
                    comments = (arrayResult["data"] as! Dictionary<String, Any>)["comments"] as? [Dictionary<String, Any>]
                    action()
                default:
                    //(controller as! EventsViewController).notResults()
                    print(arrayResult["message"] as! String)
                }
            case .failure:
                
                print("Error :: \(String(describing: response.error))")
                //alert.showError(title: (String(describing: response.error), buttonTitle: "OK")
            }
        }
    }
}

func requestFindEvents(search:String, type:Int, controller:UIViewController){
    let url = URL(string: URL_GENERAL + "events/find.json")
    
    let parameters: Parameters = ["search":search, "type":type]
    
    let token = getDataInUserDefaults(key:"token")
    
    let headers: HTTPHeaders = [
        "Authorization": token!,
        "Accept": "application/json"
    ]
    
    Alamofire.request(url!, method: .get, parameters: parameters, headers: headers).responseJSON{response in
        
        if (response.result.value != nil){
        
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
               
            }
        }
    }
    
    
}
