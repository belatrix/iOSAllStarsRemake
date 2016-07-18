//
//  RankingBC.swift
//  AllStars
//
//  Created by Kenyi Rodriguez Vergara on 13/05/16.
//  Copyright © 2016 Belatrix SF. All rights reserved.
//

import UIKit

class RankingBC: NSObject {
    
    class func listUserRankingWithKind(kind : String?, withCompletion completion : (arrayUsersRanking : NSMutableArray?) -> Void) {
        
        let objUser = LogInBC.getCurrenteUserSession()
        
        if objUser!.user_token == nil {
            OSPUserAlerts.showSimpleAlert("app_name".localized, withMessage: "token_invalid".localized, withAcceptButton: "ok".localized)
            completion(arrayUsersRanking: NSMutableArray())
            return
        }
        
        OSPWebModel.listUserRankingToKind(kind!, withToken: objUser!.user_token!) { (arrayUsersRanking, errorResponse, successful) in
            if (arrayUsersRanking != nil) {
                completion(arrayUsersRanking: arrayUsersRanking!)
            } else if (errorResponse != nil) {
                OSPUserAlerts.showSimpleAlert("generic_title_problem".localized, withMessage: errorResponse!.message!, withAcceptButton: "ok".localized)
                completion(arrayUsersRanking: NSMutableArray())
            } else {
                OSPUserAlerts.showSimpleAlert("generic_title_problem".localized, withMessage: "server_error".localized, withAcceptButton: "ok".localized)
                completion(arrayUsersRanking: NSMutableArray())
            }
        }
    }
    
    class func listStarKeywordWithCompletion(starKeyword : StarKeywordBE, withCompletion completion : (arrayUsers : NSMutableArray, nextPage : String?) -> Void) {
        
        let objUser = LogInBC.getCurrenteUserSession()
        
        if objUser!.user_token == nil {
            OSPUserAlerts.showSimpleAlert("app_name".localized, withMessage: "token_invalid".localized, withAcceptButton: "ok".localized)
            completion(arrayUsers: NSMutableArray(), nextPage: nil)
            return
        }
        
       OSPWebModel.listEmployeeKeywordWithToken(starKeyword, withToken: objUser!.user_token!) { (arrayEmployees, nextPage, errorResponse, successful) in
            
            if (arrayEmployees != nil) {
                completion(arrayUsers: arrayEmployees!, nextPage: nextPage)
            } else if (errorResponse != nil) {
                OSPUserAlerts.showSimpleAlert("generic_title_problem".localized, withMessage: errorResponse!.message!, withAcceptButton: "ok".localized)
                completion(arrayUsers: NSMutableArray(), nextPage: nil)
            } else {
                OSPUserAlerts.showSimpleAlert("generic_title_problem".localized, withMessage: "server_error".localized, withAcceptButton: "ok".localized)
                completion(arrayUsers: NSMutableArray(), nextPage: nil)
            }
        }
    }
    
    class func listStarKeywordToPage(page : String, withCompletion completion : (arrayUsers : NSMutableArray, nextPage : String?) -> Void) {
        
        let objUser = LogInBC.getCurrenteUserSession()
        
        if objUser!.user_token == nil {
            OSPUserAlerts.showSimpleAlert("app_name".localized, withMessage: "token_invalid".localized, withAcceptButton: "ok".localized)
            completion(arrayUsers: NSMutableArray(), nextPage: nil)
            return
        }
        
        OSPWebModel.listEmployeeKeywordToPage(page, withToken: objUser!.user_token!) { (arrayEmployees, nextPage, errorResponse, successful) in
            if (arrayEmployees != nil) {
                completion(arrayUsers: arrayEmployees!, nextPage: nextPage)
            } else if (errorResponse != nil) {
                OSPUserAlerts.showSimpleAlert("generic_title_problem".localized, withMessage: errorResponse!.message!, withAcceptButton: "ok".localized)
                completion(arrayUsers: NSMutableArray(), nextPage: nil)
            } else {
                OSPUserAlerts.showSimpleAlert("generic_title_problem".localized, withMessage: "server_error".localized, withAcceptButton: "ok".localized)
                completion(arrayUsers: NSMutableArray(), nextPage: nil)
            }
        }
    }
}