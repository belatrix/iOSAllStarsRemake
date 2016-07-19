//
//  OSPWebSender.swift
//  BookShelf
//
//  Created by Flavio Franco Tunqui on 7/6/16.
//  Copyright © 2016 Belatrix SF. All rights reserved.
//

import UIKit
import Alamofire

class OSPWebSender: NSObject {

    class func createHeaderWithToken(aToken : NSString) -> NSDictionary {
        
        let dicHeader = NSMutableDictionary()
        dicHeader.setObject("Token \(aToken)", forKey: "Authorization")
        
        return dicHeader
    }
    
    class func doGET(path : String, withCompletion completion : (response : AnyObject?, successful : Bool) -> Void) {
        
        let URL = Constants.WEB_SERVICES + path
        
        Alamofire.request(
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
    
    class func doGETWithToken(path : String, withToken token : String, withCompletion completion : (response : AnyObject?, successful : Bool) -> Void) {
        
        let URL = Constants.WEB_SERVICES + path
        
        Alamofire.request(
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
    
    class func doPOST(path : String, withParameters parameters : [String : AnyObject], withCompletion completion : (response : AnyObject?, successful : Bool) -> Void) {
        
        let URL = Constants.WEB_SERVICES + path
        
        Alamofire.request(
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
    
    class func doPOSTWithToken(path : String, withParameters parameters : [String : AnyObject], withToken token : String, withCompletion completion : (response : AnyObject?, successful : Bool) -> Void) {
        
        let URL = Constants.WEB_SERVICES + path
        
        Alamofire.request(
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
    
    class func doPATCHWithToken(path : String, withParameters parameters : [String : AnyObject], withToken token : String, withCompletion completion : (response : AnyObject?, successful : Bool) -> Void) {
        
        let URL = Constants.WEB_SERVICES + path
        
        Alamofire.request(
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
    
    class func doMultipartWithToken(path : String, withParameters parameters : NSDictionary?, withImage image : NSData, withToken token : String, withCompletion completion : (response : AnyObject?, successful : Bool) -> Void) {
        
        let URL = Constants.WEB_SERVICES + path
        
        Alamofire.upload(
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