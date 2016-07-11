//
//  SearchBC.swift
//  AllStars
//
//  Created by Kenyi Rodriguez Vergara on 10/05/16.
//  Copyright © 2016 Belatrix SF. All rights reserved.
//

import UIKit

class SearchBC: NSObject {
    
    class func listEmployeeWithCompletion(completion : (arrayEmployees : NSMutableArray?, nextPage : String?) -> Void) {
        
        let objUser = LogInBC.getCurrenteUserSession()
        
        if objUser!.user_token == nil {
            OSPUserAlerts.showSimpleAlert("app_name".localized, withMessage: "token_invalid".localized, withAcceptButton: "ok".localized)
            completion(arrayEmployees: NSMutableArray(), nextPage: nil)
            return
        }
        
        OSPWebModel.listEmployeeWithToken(objUser!.user_token!) { (arrayEmployees, nextPage, errorResponse, successful) in
            
            if (arrayEmployees != nil) {
                completion(arrayEmployees: arrayEmployees!, nextPage: nextPage)
            } else if (errorResponse != nil) {
                OSPUserAlerts.showSimpleAlert("generic_title_problem".localized, withMessage: errorResponse!.message!, withAcceptButton: "ok".localized)
                completion(arrayEmployees: NSMutableArray(), nextPage: nil)
            } else {
                OSPUserAlerts.showSimpleAlert("generic_title_problem".localized, withMessage: "server_error".localized, withAcceptButton: "ok".localized)
                completion(arrayEmployees: NSMutableArray(), nextPage: nil)
            }
        }
    }

    class func listEmployeeToPage(page : String, withCompletion completion : (arrayEmployees : NSMutableArray?, nextPage : String?) -> Void) {
        
        let objUser = LogInBC.getCurrenteUserSession()
        
        if objUser!.user_token == nil {
            OSPUserAlerts.showSimpleAlert("app_name".localized, withMessage: "token_invalid".localized, withAcceptButton: "ok".localized)
            completion(arrayEmployees: NSMutableArray(), nextPage: nil)
            return
        }
        
        OSPWebModel.listEmployeeToPage(page, withToken: objUser!.user_token!) { (arrayEmployees, nextPage, errorResponse, successful) in
            if (arrayEmployees != nil) {
                completion(arrayEmployees: arrayEmployees!, nextPage: nextPage)
            } else if (errorResponse != nil) {
                OSPUserAlerts.showSimpleAlert("generic_title_problem".localized, withMessage: errorResponse!.message!, withAcceptButton: "ok".localized)
                completion(arrayEmployees: NSMutableArray(), nextPage: nil)
            } else {
                OSPUserAlerts.showSimpleAlert("generic_title_problem".localized, withMessage: "server_error".localized, withAcceptButton: "ok".localized)
                completion(arrayEmployees: NSMutableArray(), nextPage: nil)
            }
        }
    }
    
    class func listEmployeeWithText(text : String, withCompletion completion : (arrayEmployees : NSMutableArray?, nextPage : String?) -> Void) {
        
        let objUser = LogInBC.getCurrenteUserSession()
        
        if objUser!.user_token == nil {
            OSPUserAlerts.showSimpleAlert("app_name".localized, withMessage: "token_invalid".localized, withAcceptButton: "ok".localized)
            completion(arrayEmployees: NSMutableArray(), nextPage: nil)
            return
        }
        
        let newSearchText = text.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLFragmentAllowedCharacterSet())
        if newSearchText == nil || newSearchText == "" {
            return
        }
        
        OSPWebModel.listEmployeeWithText(newSearchText!, withToken: objUser!.user_token!) { (arrayEmployees, nextPage, errorResponse, successful) in
            if (arrayEmployees != nil) {
                completion(arrayEmployees: arrayEmployees!, nextPage: nextPage)
            } else if (errorResponse != nil) {
                OSPUserAlerts.showSimpleAlert("generic_title_problem".localized, withMessage: errorResponse!.message!, withAcceptButton: "ok".localized)
                completion(arrayEmployees: NSMutableArray(), nextPage: nil)
            } else {
                OSPUserAlerts.showSimpleAlert("generic_title_problem".localized, withMessage: "server_error".localized, withAcceptButton: "ok".localized)
                completion(arrayEmployees: NSMutableArray(), nextPage: nil)
            }
        }
    }
    
    class func listStarKeywordWithCompletion(completion : (arrayKeywords : NSMutableArray?, nextPage : String?) -> Void) {
        
        let objUser = LogInBC.getCurrenteUserSession()
        
        if objUser!.user_token == nil {
            OSPUserAlerts.showSimpleAlert("app_name".localized, withMessage: "token_invalid".localized, withAcceptButton: "ok".localized)
            completion(arrayKeywords: NSMutableArray(), nextPage: nil)
            return
        }
        
        OSPWebModel.listStarKeywordWithToken(objUser!.user_token!) { (arrayKeywords, nextPage, errorResponse, successful) in
            
            if (arrayKeywords != nil) {
                completion(arrayKeywords: arrayKeywords!, nextPage: nextPage)
            } else if (errorResponse != nil) {
                OSPUserAlerts.showSimpleAlert("generic_title_problem".localized, withMessage: errorResponse!.message!, withAcceptButton: "ok".localized)
                completion(arrayKeywords: NSMutableArray(), nextPage: nil)
            } else {
                OSPUserAlerts.showSimpleAlert("generic_title_problem".localized, withMessage: "server_error".localized, withAcceptButton: "ok".localized)
                completion(arrayKeywords: NSMutableArray(), nextPage: nil)
            }
        }
    }
    
    class func listStarKeywordToPage(page : String, withCompletion completion : (arrayKeywords : NSMutableArray?, nextPage : String?) -> Void) {
        
        let objUser = LogInBC.getCurrenteUserSession()
        
        if objUser!.user_token == nil {
            OSPUserAlerts.showSimpleAlert("app_name".localized, withMessage: "token_invalid".localized, withAcceptButton: "ok".localized)
            completion(arrayKeywords: NSMutableArray(), nextPage: nil)
            return
        }
        
        OSPWebModel.listStarKeywordToPage(page, withToken: objUser!.user_token!) { (arrayKeywords, nextPage, errorResponse, successful) in
            if (arrayKeywords != nil) {
                completion(arrayKeywords: arrayKeywords!, nextPage: nextPage)
            } else if (errorResponse != nil) {
                OSPUserAlerts.showSimpleAlert("generic_title_problem".localized, withMessage: errorResponse!.message!, withAcceptButton: "ok".localized)
                completion(arrayKeywords: NSMutableArray(), nextPage: nil)
            } else {
                OSPUserAlerts.showSimpleAlert("generic_title_problem".localized, withMessage: "server_error".localized, withAcceptButton: "ok".localized)
                completion(arrayKeywords: NSMutableArray(), nextPage: nil)
            }
        }
    }
    
    class func listStarKeywordWithText(text : String, withCompletion completion : (arrayKeywords : NSMutableArray?, nextPage : String?) -> Void) {

        let objUser = LogInBC.getCurrenteUserSession()
        
        if objUser!.user_token == nil {
            OSPUserAlerts.showSimpleAlert("app_name".localized, withMessage: "token_invalid".localized, withAcceptButton: "ok".localized)
            completion(arrayKeywords: NSMutableArray(), nextPage: nil)
            return
        }
        
        let newSearchText = text.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLFragmentAllowedCharacterSet())
        if newSearchText == nil || newSearchText == "" {
            return
        }
        
        OSPWebModel.listStarKeywordWithText(newSearchText!, withToken: objUser!.user_token!) { (arrayKeywords, nextPage, errorResponse, successful) in
            if (arrayKeywords != nil) {
                completion(arrayKeywords: arrayKeywords!, nextPage: nextPage)
            } else if (errorResponse != nil) {
                OSPUserAlerts.showSimpleAlert("generic_title_problem".localized, withMessage: errorResponse!.message!, withAcceptButton: "ok".localized)
                completion(arrayKeywords: NSMutableArray(), nextPage: nil)
            } else {
                OSPUserAlerts.showSimpleAlert("generic_title_problem".localized, withMessage: "server_error".localized, withAcceptButton: "ok".localized)
                completion(arrayKeywords: NSMutableArray(), nextPage: nil)
            }
        }
    }
}