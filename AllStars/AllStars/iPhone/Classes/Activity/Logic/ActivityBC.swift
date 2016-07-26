//
//  ActivityBC.swift
//  AllStars
//
//  Created by Ricardo Hernan Herrera Valle on 7/25/16.
//  Copyright © 2016 Belatrix SF. All rights reserved.
//

import Foundation

struct ActivityBC {
    
    func listActivities(withCompletion completion : (arrayActivities : [Activity]?, nextPage : String?) -> Void) {
        
        let objUser = LogInBC.getCurrenteUserSession()
        
        if let userID = objUser?.user_pk,
            let token = objUser?.user_token {
            
            OSPWebModel.listActivities(userID.stringValue, withToken: token) { (arrayActivities, nextPage, errorResponse, successful) in
                
                if (arrayActivities != nil) {
                    completion(arrayActivities: arrayActivities!, nextPage: nextPage)
                } else if (errorResponse != nil) {
                    OSPUserAlerts.showSimpleAlert("generic_title_problem".localized, withMessage: errorResponse!.message!, withAcceptButton: "ok".localized)
                    completion(arrayActivities: [Activity](), nextPage: nil)
                } else {
                    OSPUserAlerts.showSimpleAlert("generic_title_problem".localized, withMessage: "server_error".localized, withAcceptButton: "ok".localized)
                    completion(arrayActivities: [Activity](), nextPage: nil)
                }
            }
        } else {
            
            OSPUserAlerts.showSimpleAlert("app_name".localized, withMessage: "token_invalid".localized, withAcceptButton: "ok".localized)
            completion(arrayActivities: [Activity](), nextPage: nil)
        }
    }
    
    func listActivitiesToPage(page : String, withCompletion completion : (arrayActivities : [Activity]?, nextPage : String?) -> Void) {
        
        let objUser = LogInBC.getCurrenteUserSession()
        
        if let token = objUser?.user_token {
            
            OSPWebModel.listActivitiesToPage(page, withToken: token) { (arrayActivities, nextPage, errorResponse, successful) in
                
                if (arrayActivities != nil) {
                    completion(arrayActivities: arrayActivities!, nextPage: nextPage)
                } else if (errorResponse != nil) {
                    OSPUserAlerts.showSimpleAlert("generic_title_problem".localized, withMessage: errorResponse!.message!, withAcceptButton: "ok".localized)
                    completion(arrayActivities: [Activity](), nextPage: nil)
                } else {
                    OSPUserAlerts.showSimpleAlert("generic_title_problem".localized, withMessage: "server_error".localized, withAcceptButton: "ok".localized)
                    completion(arrayActivities: [Activity](), nextPage: nil)
                }
            }
        } else {
            
            OSPUserAlerts.showSimpleAlert("app_name".localized, withMessage: "token_invalid".localized, withAcceptButton: "ok".localized)
            completion(arrayActivities: [Activity](), nextPage: nil)
        }
    }
}