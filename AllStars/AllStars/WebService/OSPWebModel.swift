//
//  OSPWebModel.swift
//  BookShelf
//
//  Created by Kenyi Rodriguez on 11/04/16.
//  Copyright © 2016 Kenyi Rodriguez. All rights reserved.
//

import UIKit

class OSPWebModel: NSObject {
    
    class func listUserRankingToKind(kind : String, withToken token : String, withCompletion completion : (arrayUsersRanking : NSMutableArray) -> Void) {
        
        let path = "api/employee/list/top/\(kind)/15/"
        
        OSPWebSender.doGETTokenToURL(conURL: Constants.WEB_SERVICES, conPath: path, conParametros: nil, conToken: token) { (objRespuesta) in
            
            let arrayResponse : NSArray? = objRespuesta.respuestaJSON as? NSArray
            let arrayUsersRanking = NSMutableArray()
            
            arrayResponse?.enumerateObjectsUsingBlock({ (obj, idx, stop) in
                arrayUsersRanking.addObject(OSPWebTranslator.translateUserRankingBE(obj as! NSDictionary))
            })
            
            completion(arrayUsersRanking: arrayUsersRanking)
        }
    }
    
    class func rateUser(rate : RateUserBE, withToken token : String, withCompletion completion : (isCorrect : Bool) -> Void) {
        
        let userFromID = rate.rate_fromUser!.user_pk
        let userToID = rate.rate_toUser!.user_pk
        
        let path = "api/star/\(userFromID!)/give/star/to/\(userToID!)/"
        
        let dic : NSDictionary = ["category"    : rate.rate_category!.category_pk!,
                                  "subcategory" : rate.rate_subCategory!.subCategory_pk!,
                                  "keyword"     : rate.rate_keyword!.keyword_pk!,
                                  "text"        : rate.rate_comment
                                 ]
        
        OSPWebSender.doPOSTTokenToURL(conURL: Constants.WEB_SERVICES, conPath: path, conParametros: dic, conToken: token) { (objRespuesta) in
            
            completion(isCorrect: objRespuesta.respuestaJSON?["pk"] != nil ? true : false)
        }
    }
    
    class func listKeyWordsWithToken(token : String, withCompletion completion : (arrayKeywords : NSMutableArray) -> Void) {
        
        let path = "api/category/keyword/list/"
        
        OSPWebSender.doGETTokenToURL(conURL: Constants.WEB_SERVICES, conPath: path, conParametros: nil, conToken: token) { (objRespuesta) in
            
            let arrayResponse : NSArray? = objRespuesta.respuestaJSON as? NSArray
            let arrayKeywords = NSMutableArray()
            
            arrayResponse?.enumerateObjectsUsingBlock({ (obj, idx, stop) in
                
                arrayKeywords.addObject(OSPWebTranslator.translateKeywordBE(obj as! NSDictionary))
            })
            
            completion(arrayKeywords: arrayKeywords)
        }
    }
    
    class func listAllCatgoriesToUser(user : User, withToken token : String, withCompletion completion : (arrayCategories : NSMutableArray) -> Void) -> NSURLSessionDataTask {
        
        let userID = user.user_pk
        let path = "api/employee/\(userID!)/category/list/"
        
        return OSPWebSender.doGETTokenToURL(conURL: Constants.WEB_SERVICES, conPath: path, conParametros: nil, conToken: token, conCompletion: { (objRespuesta) in
            
            let arrayResponse : NSArray? = objRespuesta.respuestaJSON as? NSArray
            let arrayCategories = NSMutableArray()
            
            arrayResponse?.enumerateObjectsUsingBlock({ (obj, idx, stop) in
                
                arrayCategories.addObject(OSPWebTranslator.translateCategoryBE(obj as! NSDictionary))
            })
            
            completion(arrayCategories: arrayCategories)
        })
    }
    
    class func listEmployeeToPage(page : String, withToken token : String, withCompletion completion : (arrayEmployee : NSMutableArray, nextPage : String?) -> Void) -> NSURLSessionDataTask{
        
        return OSPWebSender.doGETTokenToURL(conURL: Constants.WEB_SERVICES, conPath: page, conParametros: nil, conToken: token) { (objRespuesta) in
            
            let nextPage = (objRespuesta.respuestaJSON?["next"] as? String)?.stringByReplacingOccurrencesOfString("\(Constants.WEB_SERVICES)/", withString: "")
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
        
        return OSPWebSender.doGETTokenToURL(conURL: Constants.WEB_SERVICES, conPath: path, conParametros: nil, conToken: token) { (objRespuesta) in
            
            let nextPage = (objRespuesta.respuestaJSON?["next"] as? String)?.stringByReplacingOccurrencesOfString("\(Constants.WEB_SERVICES)/", withString: "")
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
        
        return OSPWebSender.doGETTokenToURL(conURL: Constants.WEB_SERVICES, conPath: path, conParametros: nil, conToken: token) { (objRespuesta) in
            
            let nextPage = (objRespuesta.respuestaJSON?["next"] as? String)?.stringByReplacingOccurrencesOfString("\(Constants.WEB_SERVICES)/", withString: "")
            let arrayEmployee = NSMutableArray()
            let arrayResponse = objRespuesta.respuestaJSON?["results"] as? NSArray
            
            arrayResponse?.enumerateObjectsUsingBlock({ (obj, idx, stop) in
                
                arrayEmployee.addObject(OSPWebTranslator.translateUserBE(obj as! NSDictionary))
            })
            
            completion(arrayEmployee: arrayEmployee, nextPage: nextPage)
        }
    }
    
    class func listStarKeywordToPage(page : String, withToken token : String, withCompletion completion : (arrayKeyword : NSMutableArray, nextPage : String?) -> Void) -> NSURLSessionDataTask {
        
        return OSPWebSender.doGETTokenToURL(conURL: Constants.WEB_SERVICES, conPath: page, conParametros: nil, conToken: token) { (objRespuesta) in
            
            let nextPage = (objRespuesta.respuestaJSON?["next"] as? String)?.stringByReplacingOccurrencesOfString("\(Constants.WEB_SERVICES)/", withString: "")
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
        
        return OSPWebSender.doGETTokenToURL(conURL: Constants.WEB_SERVICES, conPath: path, conParametros: nil, conToken: token) { (objRespuesta) in
            
            let nextPage = (objRespuesta.respuestaJSON?["next"] as? String)?.stringByReplacingOccurrencesOfString("\(Constants.WEB_SERVICES)/", withString: "")
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
        
        return OSPWebSender.doGETTokenToURL(conURL: Constants.WEB_SERVICES, conPath: path, conParametros: nil, conToken: token) { (objRespuesta) in
            
            let nextPage = (objRespuesta.respuestaJSON?["next"] as? String)?.stringByReplacingOccurrencesOfString("\(Constants.WEB_SERVICES)/", withString: "")
            let arrayStarKeyword = NSMutableArray()
            let arrayResponse = objRespuesta.respuestaJSON?["results"] as? NSArray
            
            arrayResponse?.enumerateObjectsUsingBlock({ (obj, idx, stop) in
                
                arrayStarKeyword.addObject(OSPWebTranslator.translateStarKeywordBE(obj as! NSDictionary))
            })
            
            completion(arrayKeyword: arrayStarKeyword, nextPage: nextPage)
        }
    }
    
    class func listStarUserSubCategoriesToPage(page : String, withToken token : String, withCompletion completion : (arrayUsers : NSMutableArray, nextPage : String?) -> Void) -> NSURLSessionDataTask {
        
        
        return OSPWebSender.doGETTokenToURL(conURL: Constants.WEB_SERVICES, conPath: page, conParametros: nil, conToken: token) { (objRespuesta) in
            
            let nextPage = (objRespuesta.respuestaJSON?["next"] as? String)?.stringByReplacingOccurrencesOfString("\(Constants.WEB_SERVICES)/", withString: "")
            let arrayUsers = NSMutableArray()
            let arrayResponse = objRespuesta.respuestaJSON?["results"] as? NSArray
            
            arrayResponse?.enumerateObjectsUsingBlock({ (obj : AnyObject, idx : Int, stop : UnsafeMutablePointer<ObjCBool>) in
                
                arrayUsers.addObject(OSPWebTranslator.translateUserQualifyBE(obj as! NSDictionary))
            })
            
            completion(arrayUsers: arrayUsers, nextPage: nextPage)
        }
    }
    
    class func listStarUserSubCategoriesToUser(user : User, toSubCategory subCategory : StarSubCategoryBE, withToken token : String, withCompletion completion : (arrayUsers : NSMutableArray, nextPage : String?) -> Void) -> NSURLSessionDataTask {
        
        let userID = user.user_pk
        let path = "api/star/\(userID!)/subcategory/\(subCategory.starSubCategoy_id!)/list/"
        
        return OSPWebSender.doGETTokenToURL(conURL: Constants.WEB_SERVICES, conPath: path, conParametros: nil, conToken: token) { (objRespuesta) in
            
            let nextPage = (objRespuesta.respuestaJSON?["next"] as? String)?.stringByReplacingOccurrencesOfString("\(Constants.WEB_SERVICES)/", withString: "")
            let arrayUsers = NSMutableArray()
            let arrayResponse = objRespuesta.respuestaJSON?["results"] as? NSArray
            
            arrayResponse?.enumerateObjectsUsingBlock({ (obj : AnyObject, idx : Int, stop : UnsafeMutablePointer<ObjCBool>) in
                
                arrayUsers.addObject(OSPWebTranslator.translateUserQualifyBE(obj as! NSDictionary))
            })
            
            completion(arrayUsers: arrayUsers, nextPage: nextPage)
        }
    }
    
    class func listStarSubCategoriesToUser(user : User, withToken token : String, withCompletion completion : (arrayCategories : NSMutableArray) -> Void) {
        
        let userID = user.user_pk
        let path = "api/star/\(userID!)/subcategory/list/"
        
        OSPWebSender.doGETTokenToURL(conURL: Constants.WEB_SERVICES, conPath: path, conParametros: nil, conToken: token) { (objRespuesta) in
            
            let arrayCategories = NSMutableArray()
            let arrayResponse = objRespuesta.respuestaJSON?["results"] as? NSArray
            
            arrayResponse?.enumerateObjectsUsingBlock({ (obj : AnyObject, idx : Int, stop : UnsafeMutablePointer<ObjCBool>) in
    
                arrayCategories.addObject(OSPWebTranslator.translateStarSubCategoryBE(obj as! NSDictionary))
            })
            
            completion(arrayCategories: arrayCategories)
        }
    }
    
    class func listEmployeeKeywordToPage(page : String, withToken token : String, withCompletion completion : (arrayEmployee : NSMutableArray, nextPage : String?) -> Void) -> NSURLSessionDataTask{
        
        return OSPWebSender.doGETTokenToURL(conURL: Constants.WEB_SERVICES, conPath: page, conParametros: nil, conToken: token) { (objRespuesta) in
            
            let nextPage = (objRespuesta.respuestaJSON?["next"] as? String)?.stringByReplacingOccurrencesOfString("\(Constants.WEB_SERVICES)/", withString: "")
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
        
        return OSPWebSender.doGETTokenToURL(conURL: Constants.WEB_SERVICES, conPath: path, conParametros: nil, conToken: token) { (objRespuesta) in
            
            let nextPage = (objRespuesta.respuestaJSON?["next"] as? String)?.stringByReplacingOccurrencesOfString("\(Constants.WEB_SERVICES)/", withString: "")
            let arrayEmployee = NSMutableArray()
            let arrayResponse = objRespuesta.respuestaJSON?["results"] as? NSArray
            
            arrayResponse?.enumerateObjectsUsingBlock({ (obj, idx, stop) in
                
                arrayEmployee.addObject(OSPWebTranslator.translateUserTagBE(obj as! NSDictionary))
            })
            
            completion(arrayEmployee: arrayEmployee, nextPage: nextPage)
        }
    }
    
    class func updateUser(user : User, withToken token : String, withCompletion completion : (user : User?) -> Void) {
        
        let userID = user.user_pk
        let path = "api/employee/\(userID!)/update/"
        
        let dic : NSDictionary = ["first_name" : user.user_first_name!,
                                  "last_name" : user.user_last_name!,
                                  "skype_id" : user.user_skype_id!,
                                  "location" : user.user_location_id!]
        
        OSPWebSender.doPATCHTokenToURL(conURL: Constants.WEB_SERVICES, conPath: path, conParametros: dic, conToken: token) { (objRespuesta) in
            
            completion(user: OSPWebTranslator.translateUserBE(objRespuesta.respuestaJSON as! NSDictionary))
        }
    }
    
    class func updatePhoto(user : User, withToken token : String, withImage image : NSData, withCompletion completion : (user : User?) -> Void) {
        
        let userID = user.user_pk
        let path = "api/employee/\(userID!)/avatar/"
        
        OSPWebSender.doMultipartTokenToURL(conURL: Constants.WEB_SERVICES, conPath: path, conParametros: nil, withImage: image, conToken: token) {(objRespuesta) in
            
            completion(user: OSPWebTranslator.translateUserBE(objRespuesta.respuestaJSON as! NSDictionary))
        }
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    class func loginUser(user : User, withCompletion completion : (userSession : UserSession?, errorResponse : ErrorResponse?, successful : Bool) -> Void) {
        
        let dic : [String : AnyObject] =
            ["username" : user.user_username!,
             "password" : user.user_password!]
        
        let path = "api/employee/authenticate/"
        
        OSPWebSender.doPOSTTemp(path, withParameters: dic) {(response, successful) in
            if (response != nil) {
                if (successful) {
                    completion(userSession: OSPWebTranslator.parseUserSessionBE(response as! [String : AnyObject]), errorResponse: nil, successful: successful)
                } else {
                    completion(userSession: nil, errorResponse: OSPWebTranslator.parseErrorMessage(response as! [String : AnyObject]), successful: successful)
                }
            } else {
                completion(userSession: nil, errorResponse: nil, successful: successful)
            }
        }
    }
    
    class func createUser(mail : String, withCompletion completion : (errorResponse : ErrorResponse?, successful : Bool) -> Void) {
        
        let dic : [String : AnyObject] =
            ["email" : mail]
        
        let path = "api/employee/create/"
        
        OSPWebSender.doPOSTTemp(path, withParameters: dic) {(response, successful) in
            if (response != nil) {
                if (successful) {
                    completion(errorResponse: OSPWebTranslator.parseErrorMessage(response as! [String : AnyObject]), successful: successful)
                } else {
                    completion(errorResponse: OSPWebTranslator.parseErrorMessage(response as! [String : AnyObject]), successful: successful)
                }
            } else {
                completion(errorResponse: nil, successful: successful)
            }
        }
    }
    
    class func resetUserPassword(userSession : UserSession?, currentPassword : String, newPassword : String, withCompletion completion : (user : User?, errorResponse : ErrorResponse?, successful : Bool) -> Void) {
        
        let path = "api/employee/\(userSession!.session_user_id!)/update/password/"
        
        let dic : [String : AnyObject] =
            ["current_password" : currentPassword,
             "new_password" : newPassword]
        
        OSPWebSender.doPOSTWithTokenTemp(path, withParameters: dic, withToken: userSession!.session_token!) {(response, successful) in
            if (response != nil) {
                if (successful) {
                    completion(user: OSPWebTranslator.translateUserBE(response as! [String : AnyObject]), errorResponse: nil, successful: successful)
                } else {
                    completion(user: nil, errorResponse: OSPWebTranslator.parseErrorMessage(response as! [String : AnyObject]), successful: successful)
                }
            } else {
                completion(user: nil, errorResponse: nil, successful: successful)
            }
        }
    }
    
    class func getUserInformation(user : User, withToken token : String, withCompletion completion : (user : User?, errorResponse : ErrorResponse?, successful : Bool) -> Void) {
        
        let path = "api/employee/\(user.user_pk!)/"
        
        OSPWebSender.doGETWithTokenTemp(path, withToken: token) {(response, successful) in
            
            if (response != nil) {
                if (successful) {
                    let objUsuario = OSPWebTranslator.translateUserBE(response as! [String : AnyObject])
                    objUsuario.user_pk = user.user_pk
                    completion(user: objUsuario, errorResponse: nil, successful: successful)
                } else {
                    completion(user: nil, errorResponse: OSPWebTranslator.parseErrorMessage(response as! [String : AnyObject]), successful: successful)
                }
            } else {
                completion(user: nil, errorResponse: nil, successful: successful)
            }
        }
    }
    
    class func listLocations(token : String, withCompletion completion : (arrayLocations : NSMutableArray?, errorResponse : ErrorResponse?, successful : Bool) -> Void) {
        
        let path = "api/employee/location/list/"
        
        OSPWebSender.doGETWithTokenTemp(path, withToken: token) {(response, successful) in
            
            if (response != nil) {
                if (successful) {
                    let arrayResponse : NSArray? = response as? NSArray
                    let arrayTemp = NSMutableArray()
                    
                    arrayResponse?.enumerateObjectsUsingBlock({ (obj, idx, stop) in
                        arrayTemp.addObject(OSPWebTranslator.translateLocationBE(obj as! NSDictionary))
                    })
                    
                    completion(arrayLocations: arrayTemp, errorResponse: nil, successful: successful)
                } else {
                    completion(arrayLocations: nil, errorResponse: OSPWebTranslator.parseErrorMessage(response as! [String : AnyObject]), successful: successful)
                }
            } else {
                completion(arrayLocations: nil, errorResponse: nil, successful: successful)
            }
        }
    }
}