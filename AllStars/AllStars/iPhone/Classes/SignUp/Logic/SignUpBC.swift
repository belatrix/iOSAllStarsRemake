//
//  SignUpBC.swift
//  AllStars
//
//  Created by Flavio Franco Tunqui on 6/8/16.
//  Copyright © 2016 Belatrix SF. All rights reserved.
//

import UIKit

class SignUpBC: NSObject {

    class func createUser(mail : String, withCompletion completion : (successful : Bool) -> Void) {
        
        if (mail.trim().isEmpty) {
            OSPUserAlerts.showSimpleAlert("app_name".localized, withMessage: "mail_empty".localized, withAcceptButton: "ok".localized)
            completion(successful: false)
            return
        }
        
        if (!Util.isValidEmail(mail)) {
            OSPUserAlerts.showSimpleAlert("app_name".localized, withMessage: "mail_invalid".localized, withAcceptButton: "ok".localized)
            completion(successful: false)
            return
        }
        
        OSPWebModel.createUser(mail) { (errorResponse, successful) in
            
            if (errorResponse != nil) {
                if (successful) {
                    OSPUserAlerts.showSimpleAlert("app_name".localized, withMessage: errorResponse!.message!, withAcceptButton: "got_it".localized)
                    completion(successful: true)
                } else {
                    OSPUserAlerts.showSimpleAlert("generic_title_problem".localized, withMessage: errorResponse!.message!, withAcceptButton: "ok".localized)
                    completion(successful: false)
                }
            } else {
                OSPUserAlerts.showSimpleAlert("generic_title_problem".localized, withMessage: "server_error".localized, withAcceptButton: "ok".localized)
                completion(successful: false)
            }
        }
    }
}