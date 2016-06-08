//
//  OSPWebSender.swift
//  BookShelf
//
//  Created by Kenyi Rodriguez on 11/04/16.
//  Copyright © 2016 Online Studio Productions. All rights reserved.
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
        
        diccionarioHeader.setObject("application/json; charset=UTF-8", forKey: "Content-Type")
        diccionarioHeader.setObject("application/json", forKey: "Accept")
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
    
    
    
    
    
    
    
    
    
    
    
    
    //MARK:
    //MARK: Consumo de servicios con cookie
    //MARK:
    
    
    
    
    class func doPOSTCookieToURL(conURL url : NSString, conPath path : NSString, conParametros parametros : AnyObject?, conCookie cookie : NSString, conCompletion completion : (objRespuesta : OSPWebResponse) -> Void){
        
        let configuracionSesion = NSURLSessionConfiguration.defaultSessionConfiguration()
        configuracionSesion.HTTPAdditionalHeaders = self.crearCabeceraPeticionConCookie(cookie) as [NSObject : AnyObject]
        
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
    
    
    
    
    
    
    
    class func doGETCookieToURL(conURL url : NSString, conPath path : NSString, conParametros parametros : AnyObject?, conCookie cookie : NSString, conCompletion completion : (objRespuesta : OSPWebResponse) -> Void){
        
        let configuracionSesion = NSURLSessionConfiguration.defaultSessionConfiguration()
        configuracionSesion.HTTPAdditionalHeaders = self.crearCabeceraPeticionConCookie(cookie) as [NSObject : AnyObject]
        
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
        
        request.HTTPMethod = "GET"
        
        let postDataTask = sesion.dataTaskWithRequest(request) { (data : NSData?, response : NSURLResponse?, error : NSError?) in
            
            dispatch_async(dispatch_get_main_queue(), {
                
                completion(objRespuesta : self.obtenerRespuestaServicioParaData(data, response: response, error: error))
            })
        }
        
        
        postDataTask.resume()
    }
    
    
    
    
    
    
    
    
    
    class func doPUTCookieToURL(conURL url : NSString, conPath path : NSString, conParametros parametros : AnyObject?, conCookie cookie : NSString, conCompletion completion : (objRespuesta : OSPWebResponse) -> Void){
        
        let configuracionSesion = NSURLSessionConfiguration.defaultSessionConfiguration()
        configuracionSesion.HTTPAdditionalHeaders = self.crearCabeceraPeticionConCookie(cookie) as [NSObject : AnyObject]
        
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
    
    
    
    
    
    
    
    
    
    //MARK:
    //MARK: Consumo de servicios con token
    //MARK:
    
    
    
    
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
        
        let urlServicio = NSURL(string: "\(url)/\(path)")
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
    
    class func doPATCHTokenToURL(conURL url : NSString, conPath path : NSString, conParametros parametros : AnyObject?, conToken token : NSString, conCompletion completion : (objRespuesta : OSPWebResponse) -> Void){
        
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
        
        request.HTTPMethod = "PATCH"
        
        let postDataTask = sesion.dataTaskWithRequest(request) { (data : NSData?, response : NSURLResponse?, error : NSError?) in
            
            dispatch_async(dispatch_get_main_queue(), {
                
                completion(objRespuesta : self.obtenerRespuestaServicioParaData(data, response: response, error: error))
            })
        }
        
        postDataTask.resume()
    }
    
    class func doMultipartTokenToURL(conURL url : NSString, conPath path : NSString, conParametros parametros : AnyObject?, withImage image : NSData, conToken token : NSString, conCompletion completion : (objRespuesta : OSPWebResponse) -> Void){
        
        let urlWS = "\(url)/\(path)"
        
        Alamofire.upload(
            .POST,
            urlWS,
            headers: self.crearCabeceraPeticionConToken(token) as! [String : String],
            multipartFormData: { multipartFormData in
                multipartFormData.appendBodyPart(data: image, name: "image", fileName: "testName.jpg", mimeType: "image/jpg")
            },
            encodingCompletion: { encodingResult in
                switch encodingResult {
                case .Success(let upload, _, _):
                    upload.responseJSON { response in
                        debugPrint(response)
                        completion(objRespuesta : self.obtenerRespuestaServicioParaData(response.data, response: response.response, error: nil))
                    }
                case .Failure(let encodingError):
                    print(encodingError)
                    completion(objRespuesta : self.obtenerRespuestaServicioParaData(nil, response: nil, error: nil))
                }
            }
        )
    }
    
    //MARK:
    //MARK: Consumo de servicios simple
    //MARK:
    
    class func doPOSTToURL(conURL url : NSString, conPath path : NSString, conParametros parametros : AnyObject?, conCompletion completion : (objRespuesta : OSPWebResponse) -> Void){
        
        let configuracionSesion = NSURLSessionConfiguration.defaultSessionConfiguration()
        configuracionSesion.HTTPAdditionalHeaders = self.crearCabeceraPeticion() as [NSObject : AnyObject]
        
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
    

    
    
    
    
    
    class func doGETToURL(conURL url : NSString, conPath path : NSString, conParametros parametros : AnyObject?, conCompletion completion : (objRespuesta : OSPWebResponse) -> Void){
        
        let configuracionSesion = NSURLSessionConfiguration.defaultSessionConfiguration()
        configuracionSesion.HTTPAdditionalHeaders = self.crearCabeceraPeticion() as [NSObject : AnyObject]
        
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
        
        request.HTTPMethod = "GET"
        
        let postDataTask = sesion.dataTaskWithRequest(request) { (data : NSData?, response : NSURLResponse?, error : NSError?) in
            
            dispatch_async(dispatch_get_main_queue(), {
                
                completion(objRespuesta : self.obtenerRespuestaServicioParaData(data, response: response, error: error))
            })
        }
        
        
        postDataTask.resume()
    }
    
    
    
    
    
    
    
    
    class func doPUTToURL(conURL url : NSString, conPath path : NSString, conParametros parametros : AnyObject?, conCompletion completion : (objRespuesta : OSPWebResponse) -> Void){
        
        let configuracionSesion = NSURLSessionConfiguration.defaultSessionConfiguration()
        configuracionSesion.HTTPAdditionalHeaders = self.crearCabeceraPeticion() as [NSObject : AnyObject]
        
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
    
    
    
    
    
    
    
    
}
