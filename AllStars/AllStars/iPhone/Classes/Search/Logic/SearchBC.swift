//
//  SearchBC.swift
//  AllStars
//
//  Created by Kenyi Rodriguez Vergara on 10/05/16.
//  Copyright © 2016 Belatrix SF. All rights reserved.
//

import UIKit

class SearchBC: NSObject {
    
//    class func listStarSubCategoriesToUser(user : User, withCompletion completion : (arrayCategories : NSMutableArray?) -> Void) {
//        
//        let objUser = LoginBC.getCurrenteUserSession()
//        
//        if objUser!.user_token == nil {
//            OSPUserAlerts.showSimpleAlert("app_name".localized, withMessage: "token_invalid".localized, withAcceptButton: "ok".localized)
//            completion(arrayCategories: NSMutableArray())
//            return
//        }
//        
//        OSPWebModel.listStarSubCategoriesToUser(user, withToken: objUser!.user_token!) { (arrayCategories, errorResponse, successful) in
//            if (arrayCategories != nil) {
//                completion(arrayCategories: arrayCategories!)
//            } else if (errorResponse != nil) {
//                OSPUserAlerts.showSimpleAlert("generic_title_problem".localized, withMessage: errorResponse!.message!, withAcceptButton: "ok".localized)
//                completion(arrayCategories: NSMutableArray())
//            } else {
//                OSPUserAlerts.showSimpleAlert("generic_title_problem".localized, withMessage: "server_error".localized, withAcceptButton: "ok".localized)
//                completion(arrayCategories: NSMutableArray())
//            }
//        }
//    }
    
    class func listEmployeeWithCompletion(completion : (arrayEmployee : NSMutableArray, nextPage : String?) -> Void) -> NSURLSessionDataTask? {
        
        let currentUser = LoginBC.getCurrenteUserSession()
        
        if currentUser?.user_token == nil {
            completion(arrayEmployee: NSMutableArray(), nextPage : nil)
            return nil
        }
        
        return OSPWebModel.listEmployeeWithToken(currentUser!.user_token!) { (arrayEmployee, nextPage) in
            
            completion(arrayEmployee: arrayEmployee, nextPage: nextPage)
        }
    }

    class func listEmployeeToPage(page : String, withCompletion completion : (arrayEmployee : NSMutableArray, nextPage : String?) -> Void) -> NSURLSessionDataTask?{
        
        let currentUser = LoginBC.getCurrenteUserSession()
        
        if currentUser?.user_token == nil {
            completion(arrayEmployee: NSMutableArray(), nextPage : nil)
            return nil
        }
        
        return OSPWebModel.listEmployeeToPage(page, withToken: currentUser!.user_token!) { (arrayEmployee, nextPage) in
            completion(arrayEmployee: arrayEmployee, nextPage: nextPage)
        }
    }
    
    class func listEmployeeWithText(text : String, withCompletion completion : (arrayEmployee : NSMutableArray, nextPage : String?) -> Void) -> NSURLSessionDataTask? {
        
        let currentUser = LoginBC.getCurrenteUserSession()
        
        if currentUser?.user_token == nil {
            completion(arrayEmployee: NSMutableArray(), nextPage : nil)
            return nil
        }
        
        let newSearchText = text.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLFragmentAllowedCharacterSet())
        if newSearchText == nil {
            return nil
        }
        
        return OSPWebModel.listEmployeeWithText(newSearchText!, withToken: currentUser!.user_token!) { (arrayEmployee, nextPage) in
            
            completion(arrayEmployee: arrayEmployee, nextPage: nextPage)
        }
    }
    

    
    class func listStarKeywordToPage(page : String, withCompletion completion : (arrayKeywords : NSMutableArray, nextPage : String?) -> Void) -> NSURLSessionDataTask? {
        
        let currentUser = LoginBC.getCurrenteUserSession()
        
        if currentUser?.user_token == nil {
            completion(arrayKeywords: NSMutableArray(), nextPage : nil)
            return nil
        }
        
        return OSPWebModel.listStarKeywordToPage(page, withToken: currentUser!.user_token!) { (arrayEmployee, nextPage) in
            
            completion(arrayKeywords: arrayEmployee, nextPage: nextPage)
        }
    }
    
    class func listStarKeywordWithCompletion(completion : (arrayKeywords : NSMutableArray, nextPage : String?) -> Void) -> NSURLSessionDataTask? {
        
        let currentUser = LoginBC.getCurrenteUserSession()
        
        if currentUser?.user_token == nil {
            completion(arrayKeywords: NSMutableArray(), nextPage : nil)
            return nil
        }
        
        return OSPWebModel.listStarKeywordWithToken(currentUser!.user_token!) { (arrayEmployee, nextPage) in
            
            completion(arrayKeywords: arrayEmployee, nextPage: nextPage)
        }
    }
    
    class func listStarKeywordWithText(text : String, withCompletion completion : (arrayKeywords : NSMutableArray, nextPage : String?) -> Void) -> NSURLSessionDataTask? {
        
        let currentUser = LoginBC.getCurrenteUserSession()
        
        if currentUser?.user_token == nil {
            completion(arrayKeywords: NSMutableArray(), nextPage : nil)
            return nil
        }
        
        let newSearchText = text.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLFragmentAllowedCharacterSet())
        if newSearchText == nil {
            return nil
        }
        
        return OSPWebModel.listStarKeywordWithText(newSearchText!, withToken: currentUser!.user_token!) { (arrayEmployee, nextPage) in
            
            completion(arrayKeywords: arrayEmployee, nextPage: nextPage)
        }
    }
}