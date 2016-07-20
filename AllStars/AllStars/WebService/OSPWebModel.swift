//
//  OSPWebModel.swift
//  BookShelf
//
//  Created by Flavio Franco Tunqui on 7/6/16.
//  Copyright © 2016 Belatrix SF. All rights reserved.
//

import UIKit

class OSPWebModel: NSObject {
   

    class func logInUser(user : User, withCompletion completion : (userSession : UserSession?, errorResponse : ErrorResponse?, successful : Bool) -> Void) {
        
        let dic : [String : AnyObject] =
            ["username" : user.user_username!,
             "password" : user.user_password!]
        
        let path = "api/employee/authenticate/"
        
        OSPWebSender.doPOST(path, withParameters: dic) {(response, successful) in
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
    
    class func registerUserDevice(userDevice : UserDevice, withToken token : String, withCompletion completion : (userDevice : UserDevice?, errorResponse : ErrorResponse?, successful : Bool) -> Void) {
        
        let dic : [String : AnyObject] =
            ["employee_id" : userDevice.user_id!,
             "ios_device" : userDevice.user_ios_id!]
        
        let path = "/api/employee/\(userDevice.user_id!)/register/device/"
        
        OSPWebSender.doPOSTWithToken(path, withParameters: dic, withToken: token) {(response, successful) in
            if (response != nil) {
                if (successful) {
                    completion(userDevice: OSPWebTranslator.parseUserDevice(response as! [String : AnyObject]), errorResponse: nil, successful: successful)
                } else {
                    completion(userDevice: nil, errorResponse: OSPWebTranslator.parseErrorMessage(response as! [String : AnyObject]), successful: successful)
                }
            } else {
                completion(userDevice: nil, errorResponse: nil, successful: successful)
            }
        }
    }
    
    class func createUser(email : String, withCompletion completion : (errorResponse : ErrorResponse?, successful : Bool) -> Void) {
        
        let dic : [String : AnyObject] =
            ["email" : email]
        
        let path = "api/employee/create/"
        
        OSPWebSender.doPOST(path, withParameters: dic) {(response, successful) in
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
    
    class func forgotPassword(email : String, withCompletion completion : (errorResponse : ErrorResponse?, successful : Bool) -> Void) {
        
        let path = "/api/employee/reset/password/" + email + "/"
        
        OSPWebSender.doGET(path) {(response, successful) in
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
        
        OSPWebSender.doPOSTWithToken(path, withParameters: dic, withToken: userSession!.session_token!) {(response, successful) in
            if (response != nil) {
                if (successful) {
                    completion(user: OSPWebTranslator.parseUserBE(response as! [String : AnyObject]), errorResponse: nil, successful: successful)
                } else {
                    completion(user: nil, errorResponse: OSPWebTranslator.parseErrorMessage(response as! [String : AnyObject]), successful: successful)
                }
            } else {
                completion(user: nil, errorResponse: nil, successful: successful)
            }
        }
    }
    
    class func createParticipant(fullName : String, email : String, socialNetworkType : Int, socialNetworkId : String, withCompletion completion : (userGuest : UserGuest?, errorResponse : ErrorResponse?, successful : Bool) -> Void) {
        
        let path = "api/event/participant/"
        
        var socialNetworkIdKey = ""
        if (socialNetworkType == 1) {
            socialNetworkIdKey = "facebook_id"
        } else if (socialNetworkType == 2) {
            socialNetworkIdKey = "twitter_id"
        }
        
        let dic : [String : AnyObject] =
            ["fullname" : fullName,
             "email" : email,
             socialNetworkIdKey : socialNetworkId]
        

        OSPWebSender.doPOST(path, withParameters: dic) {(response, successful) in
            if (response != nil) {
                if (successful) {
                    completion(userGuest: OSPWebTranslator.parseUserGuestBE(response as! [String : AnyObject]), errorResponse: OSPWebTranslator.parseErrorMessage(response as! [String : AnyObject]), successful: successful)
                } else {
                    completion(userGuest: nil, errorResponse: OSPWebTranslator.parseErrorMessage(response as! [String : AnyObject]), successful: successful)
                }
            } else {
                completion(userGuest: nil, errorResponse: nil, successful: successful)
            }
        }
    }
    
    class func getUserInformation(user : User, withToken token : String, withCompletion completion : (user : User?, errorResponse : ErrorResponse?, successful : Bool) -> Void) {
        
        let path = "api/employee/\(user.user_pk!)/"
        
        OSPWebSender.doGETWithToken(path, withToken: token) {(response, successful) in
            
            if (response != nil) {
                if (successful) {
                    let objUsuario = OSPWebTranslator.parseUserBE(response as! [String : AnyObject])
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
        
        OSPWebSender.doGETWithToken(path, withToken: token) {(response, successful) in
            
            if (response != nil) {
                if (successful) {
                    let arrayResponse : NSArray? = response as? NSArray
                    let arrayTemp = NSMutableArray()
                    
                    arrayResponse?.enumerateObjectsUsingBlock({ (obj, idx, stop) in
                        arrayTemp.addObject(OSPWebTranslator.parseLocationBE(obj as! NSDictionary))
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
    
    class func updateUser(user : User, withToken token : String, withCompletion completion : (user : User?, errorResponse : ErrorResponse?, successful : Bool) -> Void) {
        
        let path = "api/employee/\(user.user_pk!)/update/"
        
        let dic : [String : AnyObject] =
            ["first_name" : user.user_first_name!,
             "last_name" : user.user_last_name!,
             "skype_id" : user.user_skype_id!,
             "location" : user.user_location_id!]
        
        OSPWebSender.doPATCHWithToken(path, withParameters: dic, withToken: token) {(response, successful) in
            
            if (response != nil) {
                if (successful) {
                    completion(user: OSPWebTranslator.parseUserBE(response as! [String : AnyObject]), errorResponse: nil, successful: successful)
                } else {
                    completion(user: nil, errorResponse: OSPWebTranslator.parseErrorMessage(response as! [String : AnyObject]), successful: successful)
                }
            } else {
                completion(user: nil, errorResponse: nil, successful: successful)
            }
        }
    }
    
    class func updatePhoto(user : User, withToken token : String, withImage image : NSData, withCompletion completion : (user : User?, errorResponse : ErrorResponse?, successful : Bool) -> Void) {
        
        let path = "api/employee/\(user.user_pk!)/avatar/"
        
        OSPWebSender.doMultipartWithToken(path, withParameters: nil, withImage: image, withToken: token) {(response, successful) in
            
            if (response != nil) {
                if (successful) {
                    completion(user: OSPWebTranslator.parseUserBE(response as! [String : AnyObject]), errorResponse: nil, successful: successful)
                } else {
                    completion(user: nil, errorResponse: OSPWebTranslator.parseErrorMessage(response as! [String : AnyObject]), successful: successful)
                }
            } else {
                completion(user: nil, errorResponse: nil, successful: successful)
            }
        }
    }
    
    class func listStarSubCategoriesToUser(user : User, withToken token : String, withCompletion completion : (arrayCategories : NSMutableArray?, errorResponse : ErrorResponse?, successful : Bool) -> Void) {
        
        let path = "api/star/\(user.user_pk!)/subcategory/list/"
        
        OSPWebSender.doGETWithToken(path, withToken: token) {(response, successful) in
            
            if (response != nil) {
                if (successful) {
                    let dic = response as! NSDictionary
                    let arrayResponse = dic["results"] as? NSArray
                    
                    let arrayTemp = NSMutableArray()
                    arrayResponse?.enumerateObjectsUsingBlock({ (obj, idx, stop) in
                        arrayTemp.addObject(OSPWebTranslator.parseStarSubCategoryBE(obj as! NSDictionary))
                    })
                    
                    completion(arrayCategories: arrayTemp, errorResponse: nil, successful: successful)
                } else {
                    completion(arrayCategories: nil, errorResponse: OSPWebTranslator.parseErrorMessage(response as! [String : AnyObject]), successful: successful)
                }
            } else {
                completion(arrayCategories: nil, errorResponse: nil, successful: successful)
            }
        }
    }
    
    class func listEmployeeWithToken(token : String, withCompletion completion : (arrayEmployees : NSMutableArray?, nextPage : String?, errorResponse : ErrorResponse?, successful : Bool) -> Void) {
        
        let path = "api/employee/list/"
        
        OSPWebSender.doGETWithToken(path, withToken: token) {(response, successful) in
            
            if (response != nil) {
                if (successful) {
                    let dic = response as! NSDictionary
                    var nextPage = dic["next"] as? String
                    nextPage = nextPage?.replace(Constants.WEB_SERVICES, withString: "")
                    let arrayResponse = dic["results"] as? NSArray
                    
                    let arrayTemp = NSMutableArray()
                    arrayResponse?.enumerateObjectsUsingBlock({ (obj, idx, stop) in
                        
                        arrayTemp.addObject(OSPWebTranslator.parseUserBE(obj as! NSDictionary))
                    })
                    
                    completion(arrayEmployees: arrayTemp, nextPage: nextPage, errorResponse: nil, successful: true)
                } else {
                    completion(arrayEmployees: nil, nextPage: nil, errorResponse: OSPWebTranslator.parseErrorMessage(response as! [String : AnyObject]), successful: false)
                }
            } else {
                completion(arrayEmployees: nil, nextPage: nil, errorResponse: nil, successful: false)
            }
        }
    }
    
    class func listEmployeeToPage(page : String, withToken token : String, withCompletion completion : (arrayEmployees : NSMutableArray?, nextPage : String?, errorResponse : ErrorResponse?, successful : Bool) -> Void) {
        
        OSPWebSender.doGETWithToken(page, withToken: token) {(response, successful) in
            
            if (response != nil) {
                if (successful) {
                    let dic = response as! NSDictionary
                    var nextPage = dic["next"] as? String
                    nextPage = nextPage?.replace(Constants.WEB_SERVICES, withString: "")
                    let arrayResponse = dic["results"] as? NSArray
                    
                    let arrayTemp = NSMutableArray()
                    arrayResponse?.enumerateObjectsUsingBlock({ (obj, idx, stop) in
                        
                        arrayTemp.addObject(OSPWebTranslator.parseUserBE(obj as! NSDictionary))
                    })
                    
                    completion(arrayEmployees: arrayTemp, nextPage: nextPage, errorResponse: nil, successful: true)
                } else {
                   completion(arrayEmployees: nil, nextPage: nil, errorResponse: OSPWebTranslator.parseErrorMessage(response as! [String : AnyObject]), successful: false)
                }
            } else {
                 completion(arrayEmployees: nil, nextPage: nil, errorResponse: nil, successful: false)
            }
        }
    }
    
    class func listEmployeeWithText(text : String, withToken token : String, withCompletion completion : (arrayEmployees : NSMutableArray?, nextPage : String?, errorResponse : ErrorResponse?, successful : Bool) -> Void) {
        
        let path = "api/employee/list/?search=\(text)"
        
        OSPWebSender.doGETWithToken(path, withToken: token) {(response, successful) in
            
            if (response != nil) {
                if (successful) {
                    let dic = response as! NSDictionary
                    var nextPage = dic["next"] as? String
                    nextPage = nextPage?.replace(Constants.WEB_SERVICES, withString: "")
                    let arrayResponse = dic["results"] as? NSArray
                    
                    let arrayTemp = NSMutableArray()
                    arrayResponse?.enumerateObjectsUsingBlock({ (obj, idx, stop) in
                        
                        arrayTemp.addObject(OSPWebTranslator.parseUserBE(obj as! NSDictionary))
                    })
                    
                    completion(arrayEmployees: arrayTemp, nextPage: nextPage, errorResponse: nil, successful: true)
                } else {
                    completion(arrayEmployees: nil, nextPage: nil, errorResponse: OSPWebTranslator.parseErrorMessage(response as! [String : AnyObject]), successful: false)
                }
            } else {
                completion(arrayEmployees: nil, nextPage: nil, errorResponse: nil, successful: false)
            }
        }
    }
    
    class func listStarKeywordWithToken(token : String, withCompletion completion : (arrayKeywords : NSMutableArray?, nextPage : String?, errorResponse : ErrorResponse?, successful : Bool) -> Void) {
        
        let path = "api/star/keyword/list/"
        
        OSPWebSender.doGETWithToken(path, withToken: token) {(response, successful) in
            
            if (response != nil) {
                if (successful) {
                    let dic = response as! NSDictionary
                    var nextPage = dic["next"] as? String
                    nextPage = nextPage?.replace(Constants.WEB_SERVICES, withString: "")
                    let arrayResponse = dic["results"] as? NSArray
                    
                    let arrayTemp = NSMutableArray()
                    arrayResponse?.enumerateObjectsUsingBlock({ (obj, idx, stop) in
                        
                        arrayTemp.addObject(OSPWebTranslator.parseStarKeywordBE(obj as! NSDictionary))
                    })
                    
                    completion(arrayKeywords: arrayTemp, nextPage: nextPage, errorResponse: nil, successful: true)
                } else {
                    completion(arrayKeywords: nil, nextPage: nil, errorResponse: OSPWebTranslator.parseErrorMessage(response as! [String : AnyObject]), successful: false)
                }
            } else {
                completion(arrayKeywords: nil, nextPage: nil, errorResponse: nil, successful: false)
            }
        }
    }
    
    class func listStarKeywordToPage(page : String, withToken token : String, withCompletion completion : (arrayKeywords : NSMutableArray?, nextPage : String?, errorResponse : ErrorResponse?, successful : Bool) -> Void) {
        
        OSPWebSender.doGETWithToken(page, withToken: token) {(response, successful) in
            
            if (response != nil) {
                if (successful) {
                    let dic = response as! NSDictionary
                    var nextPage = dic["next"] as? String
                    nextPage = nextPage?.replace(Constants.WEB_SERVICES, withString: "")
                    let arrayResponse = dic["results"] as? NSArray
                    
                    let arrayTemp = NSMutableArray()
                    arrayResponse?.enumerateObjectsUsingBlock({ (obj, idx, stop) in
                        
                        arrayTemp.addObject(OSPWebTranslator.parseStarKeywordBE(obj as! NSDictionary))
                    })
                    
                    completion(arrayKeywords: arrayTemp, nextPage: nextPage, errorResponse: nil, successful: true)
                } else {
                    completion(arrayKeywords: nil, nextPage: nil, errorResponse: OSPWebTranslator.parseErrorMessage(response as! [String : AnyObject]), successful: false)
                }
            } else {
                completion(arrayKeywords: nil, nextPage: nil, errorResponse: nil, successful: false)
            }
        }
    }
    
    class func listStarKeywordWithText(text : String, withToken token : String, withCompletion completion : (arrayEmployees : NSMutableArray?, nextPage : String?, errorResponse : ErrorResponse?, successful : Bool) -> Void) {
        
        let path = "api/star/keyword/list/?search=\(text)"
        
        OSPWebSender.doGETWithToken(path, withToken: token) {(response, successful) in
            
            if (response != nil) {
                if (successful) {
                    let dic = response as! NSDictionary
                    var nextPage = dic["next"] as? String
                    nextPage = nextPage?.replace(Constants.WEB_SERVICES, withString: "")
                    let arrayResponse = dic["results"] as? NSArray
                    
                    let arrayTemp = NSMutableArray()
                    arrayResponse?.enumerateObjectsUsingBlock({ (obj, idx, stop) in
                        
                        arrayTemp.addObject(OSPWebTranslator.parseStarKeywordBE(obj as! NSDictionary))
                    })
                    
                    completion(arrayEmployees: arrayTemp, nextPage: nextPage, errorResponse: nil, successful: true)
                } else {
                    completion(arrayEmployees: nil, nextPage: nil, errorResponse: OSPWebTranslator.parseErrorMessage(response as! [String : AnyObject]), successful: false)
                }
            } else {
                completion(arrayEmployees: nil, nextPage: nil, errorResponse: nil, successful: false)
            }
        }
    }
    
    class func listEvents(completion : (arrayEmployees : NSMutableArray?, nextPage : String?, errorResponse : ErrorResponse?, successful : Bool) -> Void) {
        
        let path = "api/event/list/"
        
        OSPWebSender.doGET(path) {(response, successful) in
            
            if (response != nil) {
                if (successful) {
                    let dic = response as! NSDictionary
                    var nextPage = dic["next"] as? String
                    nextPage = nextPage?.replace(Constants.WEB_SERVICES, withString: "")
                    let arrayResponse = dic["results"] as? NSArray
                    
                    let arrayTemp = NSMutableArray()
                    arrayResponse?.enumerateObjectsUsingBlock({ (obj, idx, stop) in
                        
                        arrayTemp.addObject(OSPWebTranslator.parseEvent(obj as! NSDictionary))
                    })
                    
                    completion(arrayEmployees: arrayTemp, nextPage: nextPage, errorResponse: nil, successful: true)
                } else {
                    completion(arrayEmployees: nil, nextPage: nil, errorResponse: OSPWebTranslator.parseErrorMessage(response as! [String : AnyObject]), successful: false)
                }
            } else {
                completion(arrayEmployees: nil, nextPage: nil, errorResponse: nil, successful: false)
            }
        }
    }
    
    class func listEmployeeKeywordWithToken(starKeyword : StarKeywordBE, withToken token : String, withCompletion completion : (arrayEmployees : NSMutableArray?, nextPage : String?, errorResponse : ErrorResponse?, successful : Bool) -> Void) {
        
        let path = "api/star/keyword/\(starKeyword.keyword_pk!)/list/"
        
        OSPWebSender.doGETWithToken(path, withToken: token) {(response, successful) in
            
            if (response != nil) {
                if (successful) {
                    let dic = response as! NSDictionary
                    var nextPage = dic["next"] as? String
                    nextPage = nextPage?.replace(Constants.WEB_SERVICES, withString: "")
                    let arrayResponse = dic["results"] as? NSArray
                    
                    let arrayTemp = NSMutableArray()
                    arrayResponse?.enumerateObjectsUsingBlock({ (obj, idx, stop) in
                        
                        arrayTemp.addObject(OSPWebTranslator.parseUserTagBE(obj as! NSDictionary))
                    })
                    
                    completion(arrayEmployees: arrayTemp, nextPage: nextPage, errorResponse: nil, successful: true)
                } else {
                    completion(arrayEmployees: nil, nextPage: nil, errorResponse: OSPWebTranslator.parseErrorMessage(response as! [String : AnyObject]), successful: false)
                }
            } else {
                completion(arrayEmployees: nil, nextPage: nil, errorResponse: nil, successful: false)
            }
        }
    }
    
    class func listEmployeeKeywordToPage(page : String, withToken token : String, withCompletion completion : (arrayEmployees : NSMutableArray?, nextPage : String?, errorResponse : ErrorResponse?, successful : Bool) -> Void) {
        
        OSPWebSender.doGETWithToken(page, withToken: token) {(response, successful) in
            
            if (response != nil) {
                if (successful) {
                    let dic = response as! NSDictionary
                    var nextPage = dic["next"] as? String
                    nextPage = nextPage?.replace(Constants.WEB_SERVICES, withString: "")
                    let arrayResponse = dic["results"] as? NSArray
                    
                    let arrayTemp = NSMutableArray()
                    arrayResponse?.enumerateObjectsUsingBlock({ (obj, idx, stop) in
                        
                        arrayTemp.addObject(OSPWebTranslator.parseUserTagBE(obj as! NSDictionary))
                    })
                    
                    completion(arrayEmployees: arrayTemp, nextPage: nextPage, errorResponse: nil, successful: true)
                } else {
                    completion(arrayEmployees: nil, nextPage: nil, errorResponse: OSPWebTranslator.parseErrorMessage(response as! [String : AnyObject]), successful: false)
                }
            } else {
                completion(arrayEmployees: nil, nextPage: nil, errorResponse: nil, successful: false)
            }
        }
    }
    
    class func listUserRankingToKind(kind : String, withToken token : String, withCompletion completion : (arrayUsersRanking : NSMutableArray?, errorResponse : ErrorResponse?, successful : Bool) -> Void) {
        
        let path = "api/employee/list/top/\(kind)/15/"
        
        OSPWebSender.doGETWithToken(path, withToken: token) {(response, successful) in
            
            if (response != nil) {
                if (successful) {
                    let arrayResponse : NSArray? = response as? NSArray
                    let arrayTemp = NSMutableArray()
                    
                    arrayResponse?.enumerateObjectsUsingBlock({ (obj, idx, stop) in
                        arrayTemp.addObject(OSPWebTranslator.parseUserRankingBE(obj as! NSDictionary))
                    })
                    
                    completion(arrayUsersRanking: arrayTemp, errorResponse: nil, successful: successful)
                } else {
                    completion(arrayUsersRanking: nil, errorResponse: OSPWebTranslator.parseErrorMessage(response as! [String : AnyObject]), successful: successful)
                }
            } else {
                completion(arrayUsersRanking: nil, errorResponse: nil, successful: successful)
            }
        }
    }
    
    class func rateUser(rate : RateUserBE, withToken token : String, withCompletion completion : (errorResponse : ErrorResponse?, successful : Bool) -> Void) {
        
        let userFromID = rate.rate_fromUser!.user_pk
        let userToID = rate.rate_toUser!.user_pk
        
        let path = "api/star/\(userFromID!)/give/star/to/\(userToID!)/"
        
        let dic : [String : AnyObject] =
            ["category"    : rate.rate_category!.category_pk!,
             "subcategory" : rate.rate_subCategory!.subCategory_pk!,
             "keyword"     : rate.rate_keyword!.keyword_pk!,
             "text"        : rate.rate_comment]
        
        OSPWebSender.doPOSTWithToken(path, withParameters: dic, withToken: token) {(response, successful) in
            
            if (response != nil) {
                if (successful) {
                    let errorResponse = ErrorResponse()
                    completion(errorResponse: errorResponse, successful: successful)
                } else {
                    completion(errorResponse: OSPWebTranslator.parseErrorMessage(response as! [String : AnyObject]), successful: successful)
                }
            } else {
                completion(errorResponse: nil, successful: successful)
            }
        }
    }
    
    class func listKeyWordsWithToken(token : String, withCompletion completion : (arrayKeywords : NSMutableArray?, errorResponse : ErrorResponse?, successful : Bool) -> Void) {
        
        let path = "api/category/keyword/list/"
        
        OSPWebSender.doGETWithToken(path, withToken: token) {(response, successful) in
            
            if (response != nil) {
                if (successful) {
                    let arrayResponse : NSArray? = response as? NSArray
                    let arrayTemp = NSMutableArray()
                    
                    arrayResponse?.enumerateObjectsUsingBlock({ (obj, idx, stop) in
                        arrayTemp.addObject(OSPWebTranslator.parseKeywordBE(obj as! NSDictionary))
                    })
                    
                    completion(arrayKeywords: arrayTemp, errorResponse: nil, successful: successful)
                } else {
                    completion(arrayKeywords: nil, errorResponse: OSPWebTranslator.parseErrorMessage(response as! [String : AnyObject]), successful: successful)
                }
            } else {
                completion(arrayKeywords: nil, errorResponse: nil, successful: successful)
            }
        }
    }
    
    class func listAllCategoriesToUser(user : User, withToken token : String, withCompletion completion : (arrayCategories : NSMutableArray?, errorResponse : ErrorResponse?, successful : Bool) -> Void) {
        
        let userID = user.user_pk
        let path = "api/employee/\(userID!)/category/list/"
        
        OSPWebSender.doGETWithToken(path, withToken: token) {(response, successful) in
            
            if (response != nil) {
                if (successful) {
                    let arrayResponse : NSArray? = response as? NSArray
                    let arrayTemp = NSMutableArray()
                    
                    arrayResponse?.enumerateObjectsUsingBlock({ (obj, idx, stop) in
                        arrayTemp.addObject(OSPWebTranslator.parseCategoryBE(obj as! NSDictionary))
                    })
                    
                    completion(arrayCategories: arrayTemp, errorResponse: nil, successful: successful)
                } else {
                    completion(arrayCategories: nil, errorResponse: OSPWebTranslator.parseErrorMessage(response as! [String : AnyObject]), successful: successful)
                }
            } else {
                completion(arrayCategories: nil, errorResponse: nil, successful: successful)
            }
        }
    }
    
    class func listStarUserSubCategoriesToUser(user : User, toSubCategory subCategory : StarSubCategoryBE, withToken token : String, withCompletion completion : (arrayUsers : NSMutableArray?, nextPage : String?, errorResponse : ErrorResponse?, successful : Bool) -> Void) {
        
        let userID = user.user_pk
        let path = "api/star/\(userID!)/subcategory/\(subCategory.starSubCategoy_id!)/list/"
        
        OSPWebSender.doGETWithToken(path, withToken: token) {(response, successful) in
            
            if (response != nil) {
                if (successful) {
                    
                    let dic = response as! NSDictionary
                    var nextPage = dic["next"] as? String
                    nextPage = nextPage?.replace(Constants.WEB_SERVICES, withString: "")
                    let arrayResponse = dic["results"] as? NSArray
                    
                    let arrayTemp = NSMutableArray()
                    arrayResponse?.enumerateObjectsUsingBlock({ (obj, idx, stop) in
                        
                        arrayTemp.addObject(OSPWebTranslator.parseUserQualifyBE(obj as! NSDictionary))
                    })
                    
                    completion(arrayUsers: arrayTemp, nextPage: nextPage, errorResponse: nil, successful: true)
                } else {
                    completion(arrayUsers: nil, nextPage: nil, errorResponse: OSPWebTranslator.parseErrorMessage(response as! [String : AnyObject]), successful: successful)
                }
            } else {
                completion(arrayUsers: nil, nextPage: nil, errorResponse: nil, successful: successful)
            }
        }
    }
    
    class func listStarUserSubCategoriesToPage(page : String, withToken token : String, withCompletion completion : (arrayUsers : NSMutableArray?, nextPage : String?, errorResponse : ErrorResponse?, successful : Bool) -> Void) {
        
        OSPWebSender.doGETWithToken(page, withToken: token) {(response, successful) in
            
            if (response != nil) {
                if (successful) {
                    let dic = response as! NSDictionary
                    var nextPage = dic["next"] as? String
                    nextPage = nextPage?.replace(Constants.WEB_SERVICES, withString: "")
                    let arrayResponse = dic["results"] as? NSArray
                    
                    let arrayTemp = NSMutableArray()
                    arrayResponse?.enumerateObjectsUsingBlock({ (obj, idx, stop) in
                        
                        arrayTemp.addObject(OSPWebTranslator.parseUserQualifyBE(obj as! NSDictionary))
                    })
                    
                    completion(arrayUsers: arrayTemp, nextPage: nextPage, errorResponse: nil, successful: true)
                } else {
                    completion(arrayUsers: nil, nextPage: nil, errorResponse: OSPWebTranslator.parseErrorMessage(response as! [String : AnyObject]), successful: false)
                }
            } else {
                completion(arrayUsers: nil, nextPage: nil, errorResponse: nil, successful: false)
            }
        }
    }
    
    // MARK: - Logout
    
    class func doLogout(token : String, withCompletion completion : (errorResponse : ErrorResponse?, successful : Bool) -> Void) {
        
        let path = "/api/employee/logout/"
        
        OSPWebSender.doGETWithToken(path, withToken: token) {(response, successful) in
            
            if (response != nil) {
                if (successful) {
                    
                    completion(errorResponse: nil, successful: successful)
                } else {
                    completion(errorResponse: OSPWebTranslator.parseErrorMessage(response as! [String : AnyObject]), successful: successful)
                }
            } else {
                completion(errorResponse: nil, successful: successful)
            }
        }
    }
}