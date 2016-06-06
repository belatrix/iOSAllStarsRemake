//
//  OSPWebModel.swift
//  BookShelf
//
//  Created by Kenyi Rodriguez on 11/04/16.
//  Copyright © 2016 Kenyi Rodriguez. All rights reserved.
//

import UIKit

class OSPWebModel: NSObject {
    
    static let OSPWebModelURLBase = "https://allstars-belatrix.herokuapp.com"
    
    class func listUserRankingToKind(kind : String, withToken token : String, withCompletion completion : (arrayUsersRanking : NSMutableArray) -> Void) {
        
        let path = "api/employee/list/top/\(kind)/15/"
        
        OSPWebSender.doGETTokenToURL(conURL: OSPWebModelURLBase, conPath: path, conParametros: nil, conToken: token) { (objRespuesta) in
            
            let arrayResponse : NSArray? = objRespuesta.respuestaJSON as? NSArray
            let arrayUsersRanking = NSMutableArray()
            
            arrayResponse?.enumerateObjectsUsingBlock({ (obj, idx, stop) in
                arrayUsersRanking.addObject(OSPWebTranslator.translateUserRankingBE(obj as! NSDictionary))
            })
            
            completion(arrayUsersRanking: arrayUsersRanking)
        }
    }
    
    class func rateUser(rate : RateUserBE, withToken token : String, withCompletion completion : (isCorrect : Bool) -> Void) {
        
        let userFromID = rate.rate_fromUser!.user_id != nil ? rate.rate_fromUser!.user_id : rate.rate_fromUser!.user_pk
        let userToID = rate.rate_toUser!.user_id != nil ? rate.rate_toUser!.user_id : rate.rate_toUser!.user_pk
        
        let path = "api/star/\(userFromID!)/give/star/to/\(userToID!)/"
        
        let dic : NSDictionary = ["category"    : rate.rate_category!.category_pk!,
                                  "subcategory" : rate.rate_subCategory!.subCategory_pk!,
                                  "keyword"     : rate.rate_keyword!.keyword_pk!,
                                  "text"        : rate.rate_comment
                                 ]
        
        OSPWebSender.doPOSTTokenToURL(conURL: OSPWebModelURLBase, conPath: path, conParametros: dic, conToken: token) { (objRespuesta) in
            
            completion(isCorrect: objRespuesta.respuestaJSON?["pk"] != nil ? true : false)
        }
    }
    
    class func listKeyWordsWithToken(token : String, withCompletion completion : (arrayKeywords : NSMutableArray) -> Void) {
        
        let path = "api/category/keyword/list/"
        
        OSPWebSender.doGETTokenToURL(conURL: OSPWebModelURLBase, conPath: path, conParametros: nil, conToken: token) { (objRespuesta) in
            
            let arrayResponse : NSArray? = objRespuesta.respuestaJSON as? NSArray
            let arrayKeywords = NSMutableArray()
            
            arrayResponse?.enumerateObjectsUsingBlock({ (obj, idx, stop) in
                
                arrayKeywords.addObject(OSPWebTranslator.translateKeywordBE(obj as! NSDictionary))
            })
            
            completion(arrayKeywords: arrayKeywords)
        }
    }
    
    class func listAllCatgoriesToUser(user : User, withToken token : String, withCompletion completion : (arrayCategories : NSMutableArray) -> Void) -> NSURLSessionDataTask {
        
        let userID = user.user_id != nil ? user.user_id : user.user_pk
        let path = "api/employee/\(userID!)/category/list/"
        
        return OSPWebSender.doGETTokenToURL(conURL: OSPWebModelURLBase, conPath: path, conParametros: nil, conToken: token, conCompletion: { (objRespuesta) in
            
            let arrayResponse : NSArray? = objRespuesta.respuestaJSON as? NSArray
            let arrayCategories = NSMutableArray()
            
            arrayResponse?.enumerateObjectsUsingBlock({ (obj, idx, stop) in
                
                arrayCategories.addObject(OSPWebTranslator.translateCategoryBE(obj as! NSDictionary))
            })
            
            completion(arrayCategories: arrayCategories)
        })
    }
    
    class func listEmployeeToPage(page : String, withToken token : String, withCompletion completion : (arrayEmployee : NSMutableArray, nextPage : String?) -> Void) -> NSURLSessionDataTask{
        
        return OSPWebSender.doGETTokenToURL(conURL: OSPWebModelURLBase, conPath: page, conParametros: nil, conToken: token) { (objRespuesta) in
            
            let nextPage = (objRespuesta.respuestaJSON?["next"] as? String)?.stringByReplacingOccurrencesOfString("\(OSPWebModelURLBase)/", withString: "")
            let arrayEmployee = NSMutableArray()
            let arrayResponse = objRespuesta.respuestaJSON?["results"] as? NSArray
            
            arrayResponse?.enumerateObjectsUsingBlock({ (obj, idx, stop) in
                
                arrayEmployee.addObject(OSPWebTranslator.translateUserBE(obj as! NSDictionary))
            })
            
            completion(arrayEmployee: arrayEmployee, nextPage: nextPage)
        }
    }
    
    class func listEmployeeWithText(text : String, withToken token : String, withCompletion completion : (arrayEmployee : NSMutableArray, nextPage : String?) -> Void) -> NSURLSessionDataTask {
        
        let path = "api/employee/list/?search=\(text)"
        
        return OSPWebSender.doGETTokenToURL(conURL: OSPWebModelURLBase, conPath: path, conParametros: nil, conToken: token) { (objRespuesta) in
            
            let nextPage = (objRespuesta.respuestaJSON?["next"] as? String)?.stringByReplacingOccurrencesOfString("\(OSPWebModelURLBase)/", withString: "")
            let arrayEmployee = NSMutableArray()
            let arrayResponse = objRespuesta.respuestaJSON?["results"] as? NSArray
            
            arrayResponse?.enumerateObjectsUsingBlock({ (obj, idx, stop) in
                
                arrayEmployee.addObject(OSPWebTranslator.translateUserBE(obj as! NSDictionary))
            })
            
            completion(arrayEmployee: arrayEmployee, nextPage: nextPage)
        }
    }
    
    class func listEmployeeWithToken(token : String, withCompletion completion : (arrayEmployee : NSMutableArray, nextPage : String?) -> Void) -> NSURLSessionDataTask {
        
        let path = "api/employee/list/"
        
        return OSPWebSender.doGETTokenToURL(conURL: OSPWebModelURLBase, conPath: path, conParametros: nil, conToken: token) { (objRespuesta) in
            
            let nextPage = (objRespuesta.respuestaJSON?["next"] as? String)?.stringByReplacingOccurrencesOfString("\(OSPWebModelURLBase)/", withString: "")
            let arrayEmployee = NSMutableArray()
            let arrayResponse = objRespuesta.respuestaJSON?["results"] as? NSArray
            
            arrayResponse?.enumerateObjectsUsingBlock({ (obj, idx, stop) in
                
                arrayEmployee.addObject(OSPWebTranslator.translateUserBE(obj as! NSDictionary))
            })
            
            completion(arrayEmployee: arrayEmployee, nextPage: nextPage)
        }
    }
    
    class func listStarKeywordToPage(page : String, withToken token : String, withCompletion completion : (arrayKeyword : NSMutableArray, nextPage : String?) -> Void) -> NSURLSessionDataTask {
        
        return OSPWebSender.doGETTokenToURL(conURL: OSPWebModelURLBase, conPath: page, conParametros: nil, conToken: token) { (objRespuesta) in
            
            let nextPage = (objRespuesta.respuestaJSON?["next"] as? String)?.stringByReplacingOccurrencesOfString("\(OSPWebModelURLBase)/", withString: "")
            let arrayStarKeyword = NSMutableArray()
            let arrayResponse = objRespuesta.respuestaJSON?["results"] as? NSArray
            
            arrayResponse?.enumerateObjectsUsingBlock({ (obj, idx, stop) in
                
                arrayStarKeyword.addObject(OSPWebTranslator.translateStarKeywordBE(obj as! NSDictionary))
            })
            
            completion(arrayKeyword: arrayStarKeyword, nextPage: nextPage)
        }
    }
    
    class func listStarKeywordWithToken(token : String, withCompletion completion : (arrayKeyword : NSMutableArray, nextPage : String?) -> Void) -> NSURLSessionDataTask {
        
        let path = "api/star/keyword/list/"
        
        return OSPWebSender.doGETTokenToURL(conURL: OSPWebModelURLBase, conPath: path, conParametros: nil, conToken: token) { (objRespuesta) in
            
            let nextPage = (objRespuesta.respuestaJSON?["next"] as? String)?.stringByReplacingOccurrencesOfString("\(OSPWebModelURLBase)/", withString: "")
            let arrayStarKeyword = NSMutableArray()
            let arrayResponse = objRespuesta.respuestaJSON?["results"] as? NSArray
            
            arrayResponse?.enumerateObjectsUsingBlock({ (obj, idx, stop) in
                
                arrayStarKeyword.addObject(OSPWebTranslator.translateStarKeywordBE(obj as! NSDictionary))
            })
            
            completion(arrayKeyword: arrayStarKeyword, nextPage: nextPage)
        }
    }
    
    class func listStarKeywordWithText(text : String, withToken token : String, withCompletion completion : (arrayKeyword : NSMutableArray, nextPage : String?) -> Void) -> NSURLSessionDataTask {
        
        let path = "api/star/keyword/list/?search=\(text)"
        
        return OSPWebSender.doGETTokenToURL(conURL: OSPWebModelURLBase, conPath: path, conParametros: nil, conToken: token) { (objRespuesta) in
            
            let nextPage = (objRespuesta.respuestaJSON?["next"] as? String)?.stringByReplacingOccurrencesOfString("\(OSPWebModelURLBase)/", withString: "")
            let arrayStarKeyword = NSMutableArray()
            let arrayResponse = objRespuesta.respuestaJSON?["results"] as? NSArray
            
            arrayResponse?.enumerateObjectsUsingBlock({ (obj, idx, stop) in
                
                arrayStarKeyword.addObject(OSPWebTranslator.translateStarKeywordBE(obj as! NSDictionary))
            })
            
            completion(arrayKeyword: arrayStarKeyword, nextPage: nextPage)
        }
    }
    
    class func listStarUserSubCategoriesToPage(page : String, withToken token : String, withCompletion completion : (arrayUsers : NSMutableArray, nextPage : String?) -> Void) -> NSURLSessionDataTask {
        
        
        return OSPWebSender.doGETTokenToURL(conURL: OSPWebModelURLBase, conPath: page, conParametros: nil, conToken: token) { (objRespuesta) in
            
            let nextPage = (objRespuesta.respuestaJSON?["next"] as? String)?.stringByReplacingOccurrencesOfString("\(OSPWebModelURLBase)/", withString: "")
            let arrayUsers = NSMutableArray()
            let arrayResponse = objRespuesta.respuestaJSON?["results"] as? NSArray
            
            arrayResponse?.enumerateObjectsUsingBlock({ (obj : AnyObject, idx : Int, stop : UnsafeMutablePointer<ObjCBool>) in
                
                arrayUsers.addObject(OSPWebTranslator.translateUserQualifyBE(obj as! NSDictionary))
            })
            
            completion(arrayUsers: arrayUsers, nextPage: nextPage)
        }
    }
    
    class func listStarUserSubCategoriesToUser(user : User, toSubCategory subCategory : StarSubCategoryBE, withToken token : String, withCompletion completion : (arrayUsers : NSMutableArray, nextPage : String?) -> Void) -> NSURLSessionDataTask {
        
        let userID = user.user_id != nil ? user.user_id : user.user_pk
        let path = "api/star/\(userID!)/subcategory/\(subCategory.starSubCategoy_id!)/list/"
        
        return OSPWebSender.doGETTokenToURL(conURL: OSPWebModelURLBase, conPath: path, conParametros: nil, conToken: token) { (objRespuesta) in
            
            let nextPage = (objRespuesta.respuestaJSON?["next"] as? String)?.stringByReplacingOccurrencesOfString("\(OSPWebModelURLBase)/", withString: "")
            let arrayUsers = NSMutableArray()
            let arrayResponse = objRespuesta.respuestaJSON?["results"] as? NSArray
            
            arrayResponse?.enumerateObjectsUsingBlock({ (obj : AnyObject, idx : Int, stop : UnsafeMutablePointer<ObjCBool>) in
                
                arrayUsers.addObject(OSPWebTranslator.translateUserQualifyBE(obj as! NSDictionary))
            })
            
            completion(arrayUsers: arrayUsers, nextPage: nextPage)
        }
    }
    
    class func listStarSubCategoriesToUser(user : User, withToken token : String, withCompletion completion : (arrayCategories : NSMutableArray) -> Void) {
        
        let userID = user.user_id != nil ? user.user_id : user.user_pk
        let path = "api/star/\(userID!)/subcategory/list/"
        
        OSPWebSender.doGETTokenToURL(conURL: OSPWebModelURLBase, conPath: path, conParametros: nil, conToken: token) { (objRespuesta) in
            
            let arrayCategories = NSMutableArray()
            let arrayResponse = objRespuesta.respuestaJSON?["results"] as? NSArray
            
            arrayResponse?.enumerateObjectsUsingBlock({ (obj : AnyObject, idx : Int, stop : UnsafeMutablePointer<ObjCBool>) in
    
                arrayCategories.addObject(OSPWebTranslator.translateStarSubCategoryBE(obj as! NSDictionary))
            })
            
            completion(arrayCategories: arrayCategories)
        }
    }
    
    class func listEmployeeKeywordToPage(page : String, withToken token : String, withCompletion completion : (arrayEmployee : NSMutableArray, nextPage : String?) -> Void) -> NSURLSessionDataTask{
        
        return OSPWebSender.doGETTokenToURL(conURL: OSPWebModelURLBase, conPath: page, conParametros: nil, conToken: token) { (objRespuesta) in
            
            let nextPage = (objRespuesta.respuestaJSON?["next"] as? String)?.stringByReplacingOccurrencesOfString("\(OSPWebModelURLBase)/", withString: "")
            let arrayEmployee = NSMutableArray()
            let arrayResponse = objRespuesta.respuestaJSON?["results"] as? NSArray
            
            arrayResponse?.enumerateObjectsUsingBlock({ (obj, idx, stop) in
                
                arrayEmployee.addObject(OSPWebTranslator.translateUserTagBE(obj as! NSDictionary))
            })
            
            completion(arrayEmployee: arrayEmployee, nextPage: nextPage)
        }
    }
    
    class func listEmployeeKeywordWithToken(starKeyword : StarKeywordBE, withToken token : String, withCompletion completion : (arrayEmployee : NSMutableArray, nextPage : String?) -> Void) -> NSURLSessionDataTask {
        
        let path = "api/star/keyword/\(starKeyword.keyword_pk!)/list/"
        
        return OSPWebSender.doGETTokenToURL(conURL: OSPWebModelURLBase, conPath: path, conParametros: nil, conToken: token) { (objRespuesta) in
            
            let nextPage = (objRespuesta.respuestaJSON?["next"] as? String)?.stringByReplacingOccurrencesOfString("\(OSPWebModelURLBase)/", withString: "")
            let arrayEmployee = NSMutableArray()
            let arrayResponse = objRespuesta.respuestaJSON?["results"] as? NSArray
            
            arrayResponse?.enumerateObjectsUsingBlock({ (obj, idx, stop) in
                
                arrayEmployee.addObject(OSPWebTranslator.translateUserTagBE(obj as! NSDictionary))
            })
            
            completion(arrayEmployee: arrayEmployee, nextPage: nextPage)
        }
    }
    
    class func listLocationsWithToken(token : String, withCompletion completion : (arrayLocations : NSMutableArray) -> Void) {
        
        let path = "api/employee/location/list/"
        
        OSPWebSender.doGETTokenToURL(conURL: OSPWebModelURLBase, conPath: path, conParametros: nil, conToken: token) { (objRespuesta) in
            
            let arrayResponse : NSArray? = objRespuesta.respuestaJSON as? NSArray
            let arrayLocations = NSMutableArray()
            
            arrayResponse?.enumerateObjectsUsingBlock({ (obj, idx, stop) in
                
                arrayLocations.addObject(OSPWebTranslator.translateLocationBE(obj as! NSDictionary))
            })
            
            completion(arrayLocations: arrayLocations)
        }
    }
    
    class func getUserInfo(user : User, withToken token : String, withCompletion completion : (user : User?, messageError : String?) -> Void) {
        
        let userID = user.user_id != nil ? user.user_id : user.user_pk
        let path = "api/employee/\(userID!)/"
        
        OSPWebSender.doGETTokenToURL(conURL: OSPWebModelURLBase, conPath: path, conParametros: nil, conToken: token) { (objRespuesta) in
            
            if objRespuesta.respuestaJSON != nil {
                
                let objUsuario = OSPWebTranslator.translateUserBE(objRespuesta.respuestaJSON as! NSDictionary)
                objUsuario.user_id = user.user_id
                
                completion(user:objUsuario , messageError: nil)
            }else{
                completion(user: nil, messageError: nil)
            }
        }
    }
    
    class func updateUser(user : User, withToken token : String, withCompletion completion : (isCorrect : Bool) -> Void) {
        
        let userID = user.user_id != nil ? user.user_id : user.user_pk
        let path = "api/employee/\(userID!)/update/"
        
        let dic : NSDictionary = ["first_name" : user.user_first_name!,
                                  "last_name" : user.user_last_name!,
                                  "skype_id" : user.user_skype_id!,
                                  "location" : user.user_location_id!]
        
        OSPWebSender.doPATCHTokenToURL(conURL: OSPWebModelURLBase, conPath: path, conParametros: dic, conToken: token) { (objRespuesta) in
            
            completion(isCorrect: objRespuesta.respuestaJSON?["pk"] != nil ? true : false)
        }
    }
    
    class func loginWithUser(user : User, withCompletion completion : (user : User?, messageError : String?) -> Void) {
    
        let dic : NSDictionary = ["username" : user.user_username!,
                                  "password" : user.user_password!]
        
        
        OSPWebSender.doPOSTToURL(conURL: OSPWebModelURLBase, conPath: "api/employee/authenticate/", conParametros: dic) { (objRespuesta : OSPWebResponse) in
            
            let messageError = self.getErrorMessageToResponse(objRespuesta)
            
            if objRespuesta.respuestaJSON != nil {
                completion(user: OSPWebTranslator.translateUserBE(objRespuesta.respuestaJSON as! NSDictionary), messageError: messageError)
            }else{
                completion(user: nil, messageError: messageError)
            }
        }
    }
    
    class func getErrorMessageToResponse(objResponse : OSPWebResponse) -> String? {
        
        if objResponse.respuestaJSON != nil {
            
            let dictionaryResponse = objResponse.respuestaJSON! as! NSDictionary
            
            return dictionaryResponse["msg"] as? String
            
        }else {
            
            return "Error with your connection"
        }
        
    }
}