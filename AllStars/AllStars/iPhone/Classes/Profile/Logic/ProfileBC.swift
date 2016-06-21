//
//  ProfileBC.swift
//  AllStars
//
//  Created by Kenyi Rodriguez Vergara on 6/05/16.
//  Copyright © 2016 Belatrix SF. All rights reserved.
//

import UIKit

class ProfileBC: NSObject {
    
    class func listLocations(completion : (arrayLocations : NSMutableArray?) -> Void) {
        
        let objUser = LoginBC.getCurrenteUserSession()
        
        if objUser!.user_token == nil {
            OSPUserAlerts.showSimpleAlert("app_name".localized, withMessage: "token_invalid".localized, withAcceptButton: "ok".localized)
            completion(arrayLocations: NSMutableArray())
            return
        }
        
        
        OSPWebModel.listLocations(objUser!.user_token!) { (arrayLocations, errorResponse, successful) in
            if (arrayLocations != nil) {
                completion(arrayLocations: arrayLocations!)
            } else if (errorResponse != nil) {
                OSPUserAlerts.showSimpleAlert("generic_title_problem".localized, withMessage: errorResponse!.message!, withAcceptButton: "ok".localized)
                completion(arrayLocations: NSMutableArray())
            } else {
                OSPUserAlerts.showSimpleAlert("generic_title_problem".localized, withMessage: "server_error".localized, withAcceptButton: "ok".localized)
                completion(arrayLocations: NSMutableArray())
            }
        }
    }
    
    class func updateInfoToUser(user : User, newUser isNewUser : Bool, hasImage hasNewImage : Bool, withController controller: UIViewController, withCompletion completion : (user : User?) -> Void) {
        
        let objUser = LoginBC.getCurrenteUserSession()
        
        if objUser!.user_token == nil {
            OSPUserAlerts.showSimpleAlert("app_name".localized, withMessage: "token_invalid".localized, withAcceptButton: "ok".localized)
            completion(user: nil)
            return
        }
        
        if (isNewUser) {
            if (!hasNewImage) {
                OSPUserAlerts.showSimpleAlert("app_name".localized, withMessage: "photo_empty".localized, withAcceptButton: "ok".localized)
                completion(user: nil)
                return
            }
        }
        
        if (user.user_first_name == nil || user.user_first_name == "") {
            OSPUserAlerts.showSimpleAlert("app_name".localized, withMessage: "first_name_empty".localized, withAcceptButton: "ok".localized)
            completion(user: nil)
            return
        }
        
        if (user.user_last_name == nil || user.user_last_name == "") {
            OSPUserAlerts.showSimpleAlert("app_name".localized, withMessage: "last_name_empty".localized, withAcceptButton: "ok".localized)
            completion(user: nil)
            return
        }
        
        
        if (user.user_skype_id == nil || user.user_skype_id == "") {
            OSPUserAlerts.showSimpleAlert("app_name".localized, withMessage: "skype_id_empty".localized, withAcceptButton: "ok".localized)
            completion(user: nil)
            return
        }
        
        if (user.user_location_id == nil) {
            OSPUserAlerts.showSimpleAlert("app_name".localized, withMessage: "location_empty".localized, withAcceptButton: "ok".localized)
            completion(user: nil)
            return
        }
        
        OSPWebModel.updateUser(user, withToken: objUser!.user_token!) {(user, errorResponse, successful) in

            if (user != nil) {
                LoginBC.saveSessionOfUser(user)
                
                completion(user: user!)
            } else if (errorResponse != nil) {
                OSPUserAlerts.showSimpleAlert("generic_title_problem".localized, withMessage: errorResponse!.message!, withAcceptButton: "ok".localized)
                completion(user: nil)
            } else {
                OSPUserAlerts.showSimpleAlert("generic_title_problem".localized, withMessage: "server_error".localized, withAcceptButton: "ok".localized)
                completion(user: nil)
            }
        }
    }
    
    class func updatePhotoToUser(user : User, withController controller: UIViewController, withImage image : NSData, withCompletion completion : (user : User?) -> Void) {
        
        let objUser = LoginBC.getCurrenteUserSession()
        
        if objUser!.user_token == nil {
            OSPUserAlerts.showSimpleAlert("app_name".localized, withMessage: "token_invalid".localized, withAcceptButton: "ok".localized)
            completion(user: nil)
            return
        }
        
        OSPWebModel.updatePhoto(user, withToken: objUser!.user_token!, withImage: image) {(user, errorResponse, successful) in
            
            if (user != nil) {
                LoginBC.saveSessionOfUser(user)
                
                completion(user: user!)
            } else if (errorResponse != nil) {
                OSPUserAlerts.showSimpleAlert("generic_title_problem".localized, withMessage: errorResponse!.message!, withAcceptButton: "ok".localized)
                completion(user: nil)
            } else {
                OSPUserAlerts.showSimpleAlert("generic_title_problem".localized, withMessage: "server_error".localized, withAcceptButton: "ok".localized)
                completion(user: nil)
            }
        }
    }
    
    class func getInfoToUser(user : User, withCompletion completion : (user : User?) -> Void) {
        
        let objUser = LoginBC.getCurrenteUserSession()
        
        if objUser!.user_token == nil {
            OSPUserAlerts.showSimpleAlert("app_name".localized, withMessage: "token_invalid".localized, withAcceptButton: "ok".localized)
            completion(user: nil)
            return
        }
        
        OSPWebModel.getUserInformation(user, withToken: objUser!.user_token!) {(user, errorResponse, successful) in
            
            if (user != nil) {
                completion(user: user)
            } else if (errorResponse != nil) {
                OSPUserAlerts.showSimpleAlert("generic_title_problem".localized, withMessage: errorResponse!.message!, withAcceptButton: "ok".localized)
                completion(user: nil)
            } else {
                OSPUserAlerts.showSimpleAlert("generic_title_problem".localized, withMessage: "server_error".localized, withAcceptButton: "ok".localized)
                completion(user: nil)
            }
        }
    }
    
    class func listStarSubCategoriesToUser(user : User, withCompletion completion : (arrayCategories : NSMutableArray?) -> Void) {
        
        let objUser = LoginBC.getCurrenteUserSession()
        
        if objUser!.user_token == nil {
            OSPUserAlerts.showSimpleAlert("app_name".localized, withMessage: "token_invalid".localized, withAcceptButton: "ok".localized)
            completion(arrayCategories: NSMutableArray())
            return
        }
        
        OSPWebModel.listStarSubCategoriesToUser(user, withToken: objUser!.user_token!) { (arrayCategories, errorResponse, successful) in
            if (arrayCategories != nil) {
                completion(arrayCategories: arrayCategories!)
            } else if (errorResponse != nil) {
                OSPUserAlerts.showSimpleAlert("generic_title_problem".localized, withMessage: errorResponse!.message!, withAcceptButton: "ok".localized)
                completion(arrayCategories: NSMutableArray())
            } else {
                OSPUserAlerts.showSimpleAlert("generic_title_problem".localized, withMessage: "server_error".localized, withAcceptButton: "ok".localized)
                completion(arrayCategories: NSMutableArray())
            }
        }
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    class func listStarUserSubCategoriesToUser(user : User, toSubCategory subCategory : StarSubCategoryBE, withCompletion completion : (arrayUsers : NSMutableArray, nextPage : String?) -> Void) -> NSURLSessionDataTask? {
        
        let currentUser = LoginBC.getCurrenteUserSession()
        
        if currentUser?.user_token == nil {
            completion(arrayUsers: NSMutableArray(), nextPage: nil)
            return nil
        }
        
        return OSPWebModel.listStarUserSubCategoriesToUser(user, toSubCategory: subCategory, withToken: currentUser!.user_token!) { (arrayUsers, nextPage) in
            
            let sortDate = NSSortDescriptor.init(key: "userQualify_date", ascending: false)
            arrayUsers.sortUsingDescriptors([sortDate])
            
            completion(arrayUsers: arrayUsers, nextPage: nextPage)
        }
        
    }
    
    class func listStarUserSubCategoriesToPage(page : String, withCompletion completion : (arrayUsers : NSMutableArray, nextPage : String?) -> Void) -> NSURLSessionDataTask? {
        
        let currentUser = LoginBC.getCurrenteUserSession()
        
        if currentUser?.user_token == nil {
            completion(arrayUsers: NSMutableArray(), nextPage: nil)
            return nil
        }
        
        return OSPWebModel.listStarUserSubCategoriesToPage(page, withToken: currentUser!.user_token!, withCompletion: { (arrayUsers, nextPage) in
            
            let sortDate = NSSortDescriptor.init(key: "userQualify_date", ascending: false)
            arrayUsers.sortUsingDescriptors([sortDate])
            
            completion(arrayUsers: arrayUsers, nextPage: nextPage)
        })
        
        
    }
    
    

    
    

    
    
    

    

    
    class func validateUser(user : User?, isEqualToUser newUser : User?) -> Bool {
        
        let userID1 = user?.user_pk
        let userID2 = newUser?.user_pk
        
        return userID1 == userID2 ? true : false
    }
}
