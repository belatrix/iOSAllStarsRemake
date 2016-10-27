//
//  RecommendBC.swift
//  AllStars
//
//  Created by Kenyi Rodriguez Vergara on 11/05/16.
//  Copyright © 2016 Belatrix SF. All rights reserved.
//

import UIKit

class RecommendBC: NSObject {
    
    class func rateUser(rate : RateUserBE, withController controller : UIViewController, withCompletion completion : (successful : Bool) -> Void) {
        
        let objUser = LogInBC.getCurrenteUserSession()
        
        if objUser!.user_token == nil {
            OSPUserAlerts.showSimpleAlert("app_name".localized, withMessage: "token_invalid".localized, withAcceptButton: "ok".localized)
            completion(successful: false)
            return
        }
        
        if rate.rate_category == nil {
            OSPUserAlerts.showSimpleAlert("app_name".localized, withMessage: "category_empty".localized, withAcceptButton: "ok".localized)
            completion(successful: false)
            return
        }
        
        if rate.rate_subCategory == nil {
            OSPUserAlerts.showSimpleAlert("app_name".localized, withMessage: "subcategory_empty".localized, withAcceptButton: "ok".localized)
            completion(successful: false)
            return
        }
        
        if rate.rate_keyword == nil {
            OSPUserAlerts.showSimpleAlert("app_name".localized, withMessage: "keyword_empty".localized, withAcceptButton: "ok".localized)
            completion(successful: false)
            return
        }
        
        
        if rate.rate_category?.category_comment_requiered == 1 && rate.rate_comment.characters.count == 0 {
            OSPUserAlerts.showSimpleAlert("app_name".localized, withMessage: "description_empty".localized, withAcceptButton: "ok".localized)
            completion(successful: false)
            return
        }
        
        rate.rate_fromUser = objUser
        
        OSPWebModel.rateUser(rate, withToken: objUser!.user_token!) { (errorResponse, successful) in
            
            if (errorResponse != nil) {
                if (successful) {
                    OSPUserAlerts.showSimpleAlert("app_name".localized, withMessage: "recommendation_completed".localized, withAcceptButton: "got_it".localized)
                    completion(successful: true)
                } else {
                    OSPUserAlerts.showSimpleAlert("generic_title_problem".localized, withMessage: errorResponse!.message ?? "server_error".localized, withAcceptButton: "ok".localized)
                    completion(successful: false)
                }
            } else {
                OSPUserAlerts.showSimpleAlert("generic_title_problem".localized, withMessage: "server_error".localized, withAcceptButton: "ok".localized)
                completion(successful: false)
            }
        }
    }
    
    class func listKeyWordsWithCompletion(completion : (arrayKeywords : NSMutableArray) -> Void) {
        
        let objUser = LogInBC.getCurrenteUserSession()
        
        if objUser!.user_token == nil {
            OSPUserAlerts.showSimpleAlert("app_name".localized, withMessage: "token_invalid".localized, withAcceptButton: "ok".localized)
            completion(arrayKeywords: NSMutableArray())
            return
        }
        
        OSPWebModel.listKeyWordsWithToken (objUser!.user_token!) { (arrayKeywords, errorResponse, successful) in
            if (arrayKeywords != nil) {
                completion(arrayKeywords: arrayKeywords!)
            } else if (errorResponse != nil) {
                OSPUserAlerts.showSimpleAlert("generic_title_problem".localized, withMessage: errorResponse!.message!, withAcceptButton: "ok".localized)
                completion(arrayKeywords: NSMutableArray())
            } else {
                OSPUserAlerts.showSimpleAlert("generic_title_problem".localized, withMessage: "server_error".localized, withAcceptButton: "ok".localized)
                completion(arrayKeywords: NSMutableArray())
            }
        }
    }
    
    class func listAllCategoriesToUser(user : User, withCompletion completion : (arrayCategories : NSMutableArray) -> Void)  {
        
        let objUser = LogInBC.getCurrenteUserSession()
        
        if objUser!.user_token == nil {
            OSPUserAlerts.showSimpleAlert("app_name".localized, withMessage: "token_invalid".localized, withAcceptButton: "ok".localized)
            completion(arrayCategories: NSMutableArray())
            return
        }
        
        OSPWebModel.listAllCategoriesToUser (objUser!, withToken: objUser!.user_token!) { (arrayKeywords, errorResponse, successful) in
            if (arrayKeywords != nil) {
                completion(arrayCategories: arrayKeywords!)
            } else if (errorResponse != nil) {
                OSPUserAlerts.showSimpleAlert("generic_title_problem".localized, withMessage: errorResponse!.message!, withAcceptButton: "ok".localized)
                completion(arrayCategories: NSMutableArray())
            } else {
                OSPUserAlerts.showSimpleAlert("generic_title_problem".localized, withMessage: "server_error".localized, withAcceptButton: "ok".localized)
                completion(arrayCategories: NSMutableArray())
            }
        }
    }
}
