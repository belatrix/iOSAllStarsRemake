//
//  OSPWebSender.swift
//  BookShelf
//
//  Created by Flavio Franco Tunqui on 7/6/16.
//  Copyright © 2016 Belatrix SF. All rights reserved.
//

import UIKit
import Alamofire

class OSPWebSender {
    
    static let sharedInstance = OSPWebSender()
    
    private init() {}
    
    let manager = Alamofire.Manager.sharedInstance

    func createHeaderWithToken(aToken : NSString) -> NSDictionary {
        
        let dicHeader = NSMutableDictionary()
        dicHeader.setObject("Token \(aToken)", forKey: "Authorization")
        
        return dicHeader
    }
    
    func doGET(path : String, withCompletion completion : (response : AnyObject?, successful : Bool) -> Void) {
        
        let URL = Constants.WEB_SERVICES + path
        
        manager.request(
            .GET,
            URL,
            parameters: nil)
            .validate(statusCode: 200..<501)
            .responseJSON { response in
                switch response.result {
                case .Success:
                    print("statusCode: \(response.response!.statusCode)")
                    print("response: \(response.result.value)")
                    
                    if let JSON = response.result.value {
                        if(response.response!.statusCode >= 200 && response.response!.statusCode <= 299) {
                            completion(response : JSON, successful: true)
                        } else {
                            completion(response : JSON, successful: false)
                        }
                    } else {
                        completion(response : nil, successful: false)
                    }
                case .Failure(let error):
                    print("error: \(error)")
                    
                    completion(response : nil, successful: false)
                }
        }
    }
    
    func doGETWithToken(path : String, withToken token : String, withCompletion completion : (response : AnyObject?, statusCode: Int , successful : Bool) -> Void) {
        
        let URL = Constants.WEB_SERVICES + path
        
        manager.request(
            .GET,
            URL,
            headers: self.createHeaderWithToken(token) as? [String : String],
            parameters: nil)
            .validate(statusCode: 200..<501)
            .responseJSON { response in
                switch response.result {
                case .Success:
                    print("statusCode: \(response.response!.statusCode)")
                    print("response: \(response.result.value)")
                    
                    if let JSON = response.result.value {
                        if(response.response!.statusCode >= 200 && response.response!.statusCode <= 299) {
                            completion(response : JSON, statusCode: response.response?.statusCode ?? 0, successful: true)
                        } else {
                            completion(response : JSON, statusCode: response.response?.statusCode ?? 0, successful: false)
                        }
                    } else {
                        completion(response : nil, statusCode: response.response?.statusCode ?? 0, successful: false)
                    }
                case .Failure(let error):
                    print("error: \(error)")
                    
                    completion(response : nil, statusCode: response.response?.statusCode ?? 0, successful: false)
                }
        }
    }
    
    func doPOST(path : String, withParameters parameters : [String : AnyObject], withCompletion completion : (response : AnyObject?, successful : Bool) -> Void) {
        
        let URL = Constants.WEB_SERVICES + path
        
        manager.request(
            .POST,
            URL,
            parameters: parameters)
            .validate(statusCode: 200..<501)
            .responseJSON { response in
                switch response.result {
                case .Success:
                    print("statusCode: \(response.response!.statusCode)")
                    print("response: \(response.result.value)")
                    
                    if let JSON = response.result.value {
                        if(response.response!.statusCode >= 200 && response.response!.statusCode <= 299) {
                            completion(response : JSON, successful: true)
                        } else {
                            completion(response : JSON, successful: false)
                        }
                    } else {
                        completion(response : nil, successful: false)
                    }
                case .Failure(let error):
                    print("error: \(error)")
                    
                    completion(response : nil, successful: false)
                }
        }
    }
    
    func doPOSTWithToken(path : String, withParameters parameters : [String : AnyObject], withToken token : String, withCompletion completion : (response : AnyObject?, successful : Bool) -> Void) {
        
        let URL = Constants.WEB_SERVICES + path
        
        manager.request(
            .POST,
            URL,
            headers: self.createHeaderWithToken(token) as? [String : String],
            parameters: parameters)
            .validate(statusCode: 200..<501)
            .responseJSON { response in
                switch response.result {
                case .Success:
                    print("statusCode: \(response.response!.statusCode)")
                    print("response: \(response.result.value)")
                    
                    if let JSON = response.result.value {
                        if(response.response!.statusCode >= 200 && response.response!.statusCode <= 299) {
                            completion(response : JSON, successful: true)
                        } else {
                            completion(response : JSON, successful: false)
                        }
                    } else {
                        completion(response : nil, successful: false)
                    }
                case .Failure(let error):
                    print("error: \(error)")
                    
                    completion(response : nil, successful: false)
                }
        }
    }
    
    func doPATCHWithToken(path : String, withParameters parameters : [String : AnyObject], withToken token : String, withCompletion completion : (response : AnyObject?, successful : Bool) -> Void) {
        
        let URL = Constants.WEB_SERVICES + path
        
        manager.request(
            .PATCH,
            URL,
            headers: self.createHeaderWithToken(token) as? [String : String],
            parameters: parameters)
            .validate(statusCode: 200..<501)
            .responseJSON { response in
                switch response.result {
                case .Success:
                    print("statusCode: \(response.response!.statusCode)")
                    print("response: \(response.result.value)")
                    
                    if let JSON = response.result.value {
                        if(response.response!.statusCode >= 200 && response.response!.statusCode <= 299) {
                            completion(response : JSON, successful: true)
                        } else {
                            completion(response : JSON, successful: false)
                        }
                    } else {
                        completion(response : nil, successful: false)
                    }
                case .Failure(let error):
                    print("error: \(error)")
                    
                    completion(response : nil, successful: false)
                }
        }
    }
    
    func doMultipartWithToken(path : String, withParameters parameters : NSDictionary?, withImage image : NSData, withToken token : String, withCompletion completion : (response : AnyObject?, successful : Bool) -> Void) {
        
        let URL = Constants.WEB_SERVICES + path
        
        manager.upload(
            .POST,
            URL,
            headers: self.createHeaderWithToken(token) as? [String : String],
            multipartFormData: { multipartFormData in
                multipartFormData.appendBodyPart(data: image, name: "image", fileName: "testName.jpg", mimeType: "image/jpg")
            },
            encodingCompletion: { encodingResult in
                switch encodingResult {
                case .Success(let upload, _, _):
                    upload.responseJSON { response in
                        print("statusCode: \(response.response!.statusCode)")
                        print("response: \(response.result.value)")
                        
                        if let JSON = response.result.value {
                            completion(response : JSON, successful: true)
                        } else {
                            completion(response : nil, successful: false)
                        }
                    }
                case .Failure(let encodingError):
                    print("error: \(encodingError)")
                    
                    completion(response : nil, successful: false)
                }
            }
        )
    }
}