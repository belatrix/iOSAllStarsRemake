//
//  OSPWebTranslator.swift
//  BookShelf
//
//  Created by Kenyi Rodriguez on 11/04/16.
//  Copyright © 2016 Online Studio Productions. All rights reserved.
//

import UIKit

class OSPWebTranslator: NSObject {
    
    class func parseErrorMessage(objDic : NSDictionary) -> ErrorResponse {
        
        let errorResponse = ErrorResponse()
        
        if let message = objDic["detail"] as? String {
            errorResponse.message = message
        }
        
        return errorResponse
    }
    
    class func parseUserSessionBE(objDic : NSDictionary) -> UserSession {
        
        let objBE = UserSession()
        
        objBE.session_reset_password_code   = objDic["reset_password_code"] != nil ? objDic["reset_password_code"] as? String : ""
        objBE.session_base_profile_complete = objDic["is_base_profile_complete"] != nil ? objDic["is_base_profile_complete"] as? Bool : false
        objBE.session_user_id               = objDic["user_id"] != nil ? NSNumber(integer: objDic["user_id"]!.integerValue) : nil
        objBE.session_token                 = objDic["token"] != nil ? objDic["token"] as? String : ""
        
        return objBE
    }
    
    class func parseUserBE(objDic : NSDictionary) -> User{
        
        let objBE = User()
        
        objBE.user_pk                       = objDic["pk"] != nil ? NSNumber(integer: objDic["pk"]!.integerValue) : nil
        objBE.user_token                    = objDic["token"] as? String
        
        objBE.user_current_month_score      = objDic["current_month_score"] != nil ? NSNumber(integer: objDic["current_month_score"]!.integerValue) : nil
        objBE.user_current_year_score       = objDic["current_year_score"] != nil ? NSNumber(integer: objDic["current_year_score"]!.integerValue) : nil
        objBE.user_email                    = objDic["email"] != nil ? objDic["email"] as? String : ""
        objBE.user_first_name               = objDic["first_name"] != nil ? objDic["first_name"] as? String : ""
        objBE.user_is_active                = objDic["is_active"] != nil ? NSNumber(integer: objDic["is_active"]!.integerValue) : nil
        objBE.user_last_month_score         = objDic["last_month_score"] != nil ? NSNumber(integer: objDic["last_month_score"]!.integerValue) : nil
        objBE.user_last_name                = objDic["last_name"] != nil ? objDic["last_name"] as? String : ""
        objBE.user_last_year_score          = objDic["last_year_score"] != nil ? NSNumber(integer: objDic["last_year_score"]!.integerValue) : nil
        objBE.user_level                    = objDic["level"] != nil ? NSNumber(integer: objDic["level"]!.integerValue) : nil
        objBE.user_role_id                  = objDic["role"] != nil ? NSNumber(integer: objDic["role"]!["id"]!!.integerValue) : nil
        objBE.user_role_name                = objDic["role"]?["name"] != nil ? objDic["role"]?["name"] as? String : ""
        objBE.user_total_score              = objDic["total_score"] != nil ? NSNumber(integer: objDic["total_score"]!.integerValue) : nil
        objBE.user_username                 = objDic["username"] != nil ? objDic["username"] as? String : ""
        objBE.user_base_profile_complete    = objDic["is_base_profile_complete"] != nil ? objDic["is_base_profile_complete"] as? Bool : false
        objBE.user_blocked                  = objDic["is_blocked"] != nil ? objDic["is_blocked"] as? Bool : false
        objBE.user_active                   = objDic["is_active"] != nil ? objDic["is_active"] as? Bool : false
        
        if (objBE.user_base_profile_complete!) {
            objBE.user_location_id          = objDic["location"] != nil ? NSNumber(integer: (objDic["location"]!["id"]!)!.integerValue) : nil
            objBE.user_location_name        = objDic["location"]?["name"] != nil ? objDic["location"]?["name"] as? String : ""
            objBE.user_skype_id             = objDic["skype_id"] != nil ? objDic["skype_id"] as? String : ""
            objBE.user_avatar               = (objDic["avatar"] == nil || objDic["avatar"] is NSNull) ? "" : objDic["avatar"] as? String
        }
        
        return objBE
    }
    
    class func parseLocationBE(objDic : NSDictionary) -> LocationBE {
        
        let objBE = LocationBE()
        
        objBE.location_pk    = NSNumber(integer: (objDic["pk"])!.integerValue)
        objBE.location_name  = objDic["name"] as? String
        objBE.location_icon  = objDic["icon"] as? String
        
        return objBE
    }
    
    class func parseStarSubCategoryBE(objDic : NSDictionary) -> StarSubCategoryBE {
        
        let objBE = StarSubCategoryBE()
        
        objBE.starSubCategoy_id         = objDic["pk"] != nil ? NSNumber(integer: objDic["pk"]!.integerValue) : nil
        objBE.starSubCategoy_name       = objDic["name"] as? String
        objBE.starSubCategoy_numStars   = objDic["num_stars"] != nil ? NSNumber(integer: objDic["num_stars"]!.integerValue) : 0
        
        return objBE
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    class func translateUserRankingBE(objDic : NSDictionary) -> UserRankingBE {
        
        let objBE = UserRankingBE()
    
        objBE.userRanking_pk        = NSNumber(integer: (objDic["pk"])!.integerValue)
        objBE.userRanking_userName  = objDic["username"] != nil ? objDic["username"] as? String : ""
        objBE.userRanking_firstName = objDic["first_name"] != nil ? objDic["first_name"] as? String : ""
        objBE.userRanking_lastName  = objDic["last_name"] != nil ? objDic["last_name"] as? String : ""
        objBE.userRanking_avatar    = objDic["avatar"] != nil ? objDic["avatar"] as? String : ""
        objBE.userRanking_value     = NSNumber(integer: (objDic["value"])!.integerValue)
        
        return objBE
    }
    
    
    class func translateKeywordBE(objDic : NSDictionary) -> KeywordBE {
        
        let objBE = KeywordBE()
        
        objBE.keyword_name  = objDic["name"] as? String
        objBE.keyword_pk    = NSNumber(integer: (objDic["pk"])!.integerValue)
        
        return objBE
    }
    
    
    class func translateSubCategoryBE(objDic : NSDictionary) -> SubCategoryBE {
        
        let objBE = SubCategoryBE()
        
        objBE.subCategory_name  = objDic["name"] as? String
        objBE.subCategory_pk    = NSNumber(integer: (objDic["pk"])!.integerValue)
        
        return objBE
    }
    
    

    class func translateCategoryBE(objDic : NSDictionary) -> CategoryBE {
        
        let objBE = CategoryBE()
        
        objBE.category_comment_requiered    = NSNumber(integer: (objDic["comment_required"])!.integerValue)
        objBE.category_name                 = objDic["name"] as? String
        objBE.category_pk                   = NSNumber(integer: (objDic["pk"])!.integerValue)
        
        let arraySubCategories = objDic["subcategories"] as? NSArray
        
        arraySubCategories?.enumerateObjectsUsingBlock({ (obj, idx, stop) in
            
            objBE.category_arraySubCategories.addObject(OSPWebTranslator.translateSubCategoryBE(obj as! NSDictionary))
        })
        
        return objBE
    }
    
    
    
    class func translateUserQualifyBE(objDic : NSDictionary) -> UserQualifyBE {
        
        let objBE = UserQualifyBE()
        
        objBE.userQualify_categoryName  = objDic["category"]?["name"] != nil ? objDic["category"]?["name"] as? String : ""
        objBE.userQualify_date          = objDic["date"] != nil ? OSPDateManager.convertirTexto(objDic["date"] as! String, conFormato: "yyyy-MM-dd'T'HH:mm:ss.SSSZ") : NSDate()
        objBE.userQualify_userAvatar    = objDic["from_user"]?["avatar"] != nil ? objDic["from_user"]?["avatar"] as? String : ""
        objBE.userQualify_firstName     = objDic["from_user"]?["first_name"] != nil ? objDic["from_user"]?["first_name"] as? String : ""
        objBE.userQualify_lastName      = objDic["from_user"]?["last_name"] != nil ? objDic["from_user"]?["last_name"] as? String : ""
        objBE.userQualify_userName      = objDic["from_user"]?["username"] != nil ? objDic["from_user"]?["username"] as? String : ""
        objBE.userQualify_userId        = objDic["from_user"] != nil ? NSNumber(integer: (objDic["from_user"]!["pk"]!)!.integerValue) : nil
        objBE.userQualify_keywordID     = objDic["keyword"] != nil ? NSNumber(integer: (objDic["keyword"]!["pk"]!)!.integerValue) : nil
        objBE.userQualify_keywordName   = objDic["keyword"]?["name"] != nil ? objDic["keyword"]?["name"] as? String : ""
        objBE.userQualify_id            = NSNumber(integer: (objDic["pk"])!.integerValue)
        objBE.userQualify_text          = objDic["text"] is NSNull ? "" : objDic["text"] as? String
        
        return objBE
    }
    
    

    
    
    

    
    class func translateUserTagBE(objDic : NSDictionary) -> UserTagBE {
        
        let objBE = UserTagBE()
        
        objBE.user_pk                   = objDic["pk"] != nil ? NSNumber(integer: objDic["pk"]!.integerValue) : nil
        objBE.user_username             = objDic["username"] != nil ? objDic["username"] as? String : ""
        objBE.user_first_name           = objDic["first_name"] != nil ? objDic["first_name"] as? String : ""
        objBE.user_last_name            = objDic["last_name"] != nil ? objDic["last_name"] as? String : ""
        objBE.user_level                = objDic["level"] != nil ? NSNumber(integer: objDic["level"]!.integerValue) : nil
        objBE.user_avatar               = (objDic["avatar"] == nil || objDic["avatar"] is NSNull) ? "" : objDic["avatar"] as? String
        objBE.user_num_stars            = objDic["num_stars"] != nil ? NSNumber(integer: objDic["num_stars"]!.integerValue) : nil
        
        return objBE
    }
    
    class func translateStarKeywordBE(objDic : NSDictionary) -> StarKeywordBE {
        
        let objBE = StarKeywordBE()
        
        objBE.keyword_name              = objDic["name"] as? String
        objBE.keyword_pk                = NSNumber(integer: (objDic["pk"])!.integerValue)
        objBE.keyword_num_stars         = NSNumber(integer: (objDic["num_stars"])!.integerValue)
        
        return objBE
    }
    

}
