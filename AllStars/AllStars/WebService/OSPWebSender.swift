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

    
    //MARK:
    //MARK: Configuración
    //MARK:
    
    class func crearCabeceraPeticion() -> NSDictionary {
        
        let diccionarioHeader = NSMutableDictionary()
        
        diccionarioHeader.setObject("application/json; charset=UTF-8", forKey: "Content-Type")
        diccionarioHeader.setObject("application/json", forKey: "Accept")
        
        return diccionarioHeader
    }

    
    class func crearCabeceraPeticionConToken(aToken : NSString) -> NSDictionary {
        
        let diccionarioHeader = NSMutableDictionary()
        
//        diccionarioHeader.setObject("application/json; charset=UTF-8", forKey: "Content-Type")
//        diccionarioHeader.setObject("application/json", forKey: "Accept")
        diccionarioHeader.setObject("Token \(aToken)", forKey: "Authorization")
        
        return diccionarioHeader
    }
    
    class func crearCabeceraPeticionConCookie(aCookie : NSString) -> NSDictionary {
        
        let diccionarioHeader = NSMutableDictionary()
        
        diccionarioHeader.setObject("application/json; charset=UTF-8", forKey: "Content-Type")
        diccionarioHeader.setObject("application/json", forKey: "Accept")
        diccionarioHeader.setObject("Bearer \(aCookie)", forKey: "Cookie")
        
        return diccionarioHeader
    }
    
    //MARK:
    //MARK: Tratado de respuesta
    //MARK:
    class func obtenerRespuestaEnJSONConData(data : NSData) -> AnyObject? {
        
        do{
            return try NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.AllowFragments)
        }catch{
            return nil
        }
    }
    
    class func obtenerRespuestaServicioParaData(data : NSData?, response : NSURLResponse?, error : NSError?) -> OSPWebResponse{
        
        var respuesta : AnyObject? = nil
        
        if error == nil && data != nil {
            respuesta = self.obtenerRespuestaEnJSONConData(data!)
        }
        
        print(respuesta)
        
        let urlResponse = response as? NSHTTPURLResponse
        
        let headerFields : NSDictionary? = urlResponse?.allHeaderFields
        let objRespuesta = OSPWebResponse()
        
        objRespuesta.respuestaJSON      = respuesta
        objRespuesta.statusCode         = urlResponse?.statusCode
        objRespuesta.respuestaNSData    = data
        objRespuesta.error              = error
        objRespuesta.datosCabezera      = headerFields
        objRespuesta.token              = headerFields?["_token"] as? NSString
        objRespuesta.cookie             = headerFields?["_token"] as? NSString
        
        return objRespuesta
    }
    
    
    
    
    //MARK: Consumo de servicios con token
    class func doPOSTTokenToURL(conURL url : NSString, conPath path : NSString, conParametros parametros : AnyObject?, conToken token : NSString, conCompletion completion : (objRespuesta : OSPWebResponse) -> Void){
        
        let configuracionSesion = NSURLSessionConfiguration.defaultSessionConfiguration()
        configuracionSesion.HTTPAdditionalHeaders = self.crearCabeceraPeticionConToken(token) as [NSObject : AnyObject]
        
        let sesion = NSURLSession.init(configuration: configuracionSesion)
        
        let urlServicio = NSURL(string: "\(url)/\(path)")
        let request = NSMutableURLRequest(URL: urlServicio!)
        request.addValue("application/json; charset=UTF-8", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        
        if parametros != nil {
            do {
                request.HTTPBody = try NSJSONSerialization.dataWithJSONObject(parametros!, options: NSJSONWritingOptions.PrettyPrinted)
            }catch {}
        }
        
        request.HTTPMethod = "POST"
        
        let postDataTask = sesion.dataTaskWithRequest(request) { (data : NSData?, response : NSURLResponse?, error : NSError?) in
            
            dispatch_async(dispatch_get_main_queue(), {
                
                completion(objRespuesta : self.obtenerRespuestaServicioParaData(data, response: response, error: error))
            })
        }
        
        
        postDataTask.resume()
    }
    
    
    class func doGETTokenToURL(conURL url : NSString, conPath path : NSString, conParametros parametros : AnyObject?, conToken token : NSString, conCompletion completion : (objRespuesta : OSPWebResponse) -> Void) -> NSURLSessionDataTask {
        
        let configuracionSesion = NSURLSessionConfiguration.defaultSessionConfiguration()
        configuracionSesion.HTTPAdditionalHeaders = self.crearCabeceraPeticionConToken(token) as [NSObject : AnyObject]
        
        let sesion = NSURLSession.init(configuration: configuracionSesion)
        
        var urlServicio = NSURL(string: "\(path)")
        if (url != "") {
            urlServicio = NSURL(string: "\(url)/\(path)")
        }
        let request = NSMutableURLRequest(URL: urlServicio!)
        request.addValue("application/json; charset=UTF-8", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        
        if parametros != nil {
            do {
                request.HTTPBody = try NSJSONSerialization.dataWithJSONObject(parametros!, options: NSJSONWritingOptions.PrettyPrinted)
            }catch {}
        }
        
        request.HTTPMethod = "GET"
        
        let postDataTask = sesion.dataTaskWithRequest(request) { (data : NSData?, response : NSURLResponse?, error : NSError?) in
            
            dispatch_async(dispatch_get_main_queue(), {
                
                completion(objRespuesta : self.obtenerRespuestaServicioParaData(data, response: response, error: error))
            })
        }
        
        
        postDataTask.resume()
        return postDataTask
    }
    
    
    class func doPUTTokenToURL(conURL url : NSString, conPath path : NSString, conParametros parametros : AnyObject?, conToken token : NSString, conCompletion completion : (objRespuesta : OSPWebResponse) -> Void){
        
        let configuracionSesion = NSURLSessionConfiguration.defaultSessionConfiguration()
        configuracionSesion.HTTPAdditionalHeaders = self.crearCabeceraPeticionConToken(token) as [NSObject : AnyObject]
        
        let sesion = NSURLSession.init(configuration: configuracionSesion)
        
        let urlServicio = NSURL(string: "\(url)/\(path)")
        let request = NSMutableURLRequest(URL: urlServicio!)
        request.addValue("application/json; charset=UTF-8", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        
        if parametros != nil {
            do {
                request.HTTPBody = try NSJSONSerialization.dataWithJSONObject(parametros!, options: NSJSONWritingOptions.PrettyPrinted)
            }catch {}
        }
        
        request.HTTPMethod = "PUT"
        
        let postDataTask = sesion.dataTaskWithRequest(request) { (data : NSData?, response : NSURLResponse?, error : NSError?) in
            
            dispatch_async(dispatch_get_main_queue(), {
                
                completion(objRespuesta : self.obtenerRespuestaServicioParaData(data, response: response, error: error))
            })
        }
        
        
        postDataTask.resume()
    }

    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    

    
    
    class func doGETTemp(path : String, withCompletion completion : (response : AnyObject?, successful : Bool) -> Void) {
        
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
    
    class func doGETWithTokenTemp(path : String, withToken token : String, withCompletion completion : (response : AnyObject?, successful : Bool) -> Void) {
        
        let URL = Constants.WEB_SERVICES + path
        
        Alamofire.request(
            .GET,
            URL,
            headers: self.crearCabeceraPeticionConToken(token) as? [String : String],
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
    
    class func doPOSTTemp(path : String, withParameters parameters : [String : AnyObject], withCompletion completion : (response : AnyObject?, successful : Bool) -> Void) {
        
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
    
    class func doPOSTWithTokenTemp(path : String, withParameters parameters : [String : AnyObject], withToken token : String, withCompletion completion : (response : AnyObject?, successful : Bool) -> Void) {
        
        let URL = Constants.WEB_SERVICES + path
        
        Alamofire.request(
            .POST,
            URL,
            headers: self.crearCabeceraPeticionConToken(token) as? [String : String],
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
    
    class func doPATCHWithTokenTemp(path : String, withParameters parameters : [String : AnyObject], withToken token : String, withCompletion completion : (response : AnyObject?, successful : Bool) -> Void) {
        
        let URL = Constants.WEB_SERVICES + path
        
        Alamofire.request(
            .PATCH,
            URL,
            headers: self.crearCabeceraPeticionConToken(token) as? [String : String],
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
    
    class func doMultipartTokenToURL(path : String, withParameters parameters : NSDictionary?, withImage image : NSData, withToken token : String, withCompletion completion : (response : AnyObject?, successful : Bool) -> Void) {
        
        let URL = Constants.WEB_SERVICES + path
        
        Alamofire.upload(
            .POST,
            URL,
            headers: self.crearCabeceraPeticionConToken(token) as? [String : String],
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