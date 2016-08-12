//
//  ProfileBC.swift
//  AllStars
//
//  Created by Kenyi Rodriguez Vergara on 6/05/16.
//  Copyright © 2016 Belatrix SF. All rights reserved.
//

import UIKit

class ProfileBC: NSObject {
    
    // MARK: - Userinfo
    class func listLocations(completion : (arrayLocations : NSMutableArray?) -> Void) {
        
        let objUser = LogInBC.getCurrenteUserSession()
        
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
        
        let objUser = LogInBC.getCurrenteUserSession()
        
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
                LogInBC.saveSessionOfUser(user)
                
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
        
        let objUser = LogInBC.getCurrenteUserSession()
        
        if objUser!.user_token == nil {
            OSPUserAlerts.showSimpleAlert("app_name".localized, withMessage: "token_invalid".localized, withAcceptButton: "ok".localized)
            completion(user: nil)
            return
        }
        
        OSPWebModel.updatePhoto(user, withToken: objUser!.user_token!, withImage: image) {(user, errorResponse, successful) in
            
            if (user != nil) {
                LogInBC.saveSessionOfUser(user)
                
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
        
        let objUser = LogInBC.getCurrenteUserSession()
        
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
    
    class func getUserSkills(user : User, withCompletion completion : (skills : [KeywordBE]?, nextPage : String?) -> Void) {
        
        let objUser = LogInBC.getCurrenteUserSession()
        
        guard let token = objUser!.user_token
            else {
                OSPUserAlerts.showSimpleAlert("app_name".localized, withMessage: "token_invalid".localized, withAcceptButton: "ok".localized)
                completion(skills: [KeywordBE](), nextPage :nil)
                return
        }
        
        OSPWebModel.listUserSkills(user, withToken: token) { (skills, nextPage, errorResponse, successful) in
            if (skills != nil) {
                completion(skills: skills!, nextPage: nextPage)
            } else if (errorResponse != nil) {
                OSPUserAlerts.showSimpleAlert("generic_title_problem".localized, withMessage: errorResponse!.message!, withAcceptButton: "ok".localized)
                completion(skills: [KeywordBE](), nextPage: nil)
            } else {
                OSPUserAlerts.showSimpleAlert("generic_title_problem".localized, withMessage: "server_error".localized, withAcceptButton: "ok".localized)
                completion(skills: [KeywordBE](), nextPage: nil)
            }
        }
    }
    
    class func getUserSkillsToPage(page : String, withCompletion completion : (skills : [KeywordBE]?, nextPage : String?) -> Void) {
        
        let objUser = LogInBC.getCurrenteUserSession()
        
        guard let token = objUser!.user_token
            else {
                OSPUserAlerts.showSimpleAlert("app_name".localized, withMessage: "token_invalid".localized, withAcceptButton: "ok".localized)
                completion(skills: [KeywordBE](), nextPage :nil)
                return
        }
        
        OSPWebModel.listUserSkillsToPage(page, withToken: token) { (skills, nextPage, errorResponse, successful) in
            if (skills != nil) {
                completion(skills: skills!, nextPage: nextPage)
            } else if (errorResponse != nil) {
                OSPUserAlerts.showSimpleAlert("generic_title_problem".localized, withMessage: errorResponse!.message!, withAcceptButton: "ok".localized)
                completion(skills: [KeywordBE](), nextPage: nil)
            } else {
                OSPUserAlerts.showSimpleAlert("generic_title_problem".localized, withMessage: "server_error".localized, withAcceptButton: "ok".localized)
                completion(skills: [KeywordBE](), nextPage: nil)
            }
        }
    }
    
    class func addUserSkill(skillName: String, withCompletion completion : (skills : [KeywordBE]?, successful : Bool) -> Void) {
        
        let objUser = LogInBC.getCurrenteUserSession()
        
        guard let token = objUser!.user_token
            else {
                OSPUserAlerts.showSimpleAlert("app_name".localized, withMessage: "token_invalid".localized, withAcceptButton: "ok".localized)
                completion(skills: [KeywordBE](), successful: false)
                return
        }
        
        OSPWebModel.addSkillToUser(objUser!, skillName: skillName, withToken: token) { (skills, errorResponse, successful) in
         
            if (skills != nil) {
                completion(skills: skills!, successful: successful)
            } else if (errorResponse != nil) {
                OSPUserAlerts.showSimpleAlert("generic_title_problem".localized, withMessage: errorResponse!.message!, withAcceptButton: "ok".localized)
                completion(skills: [KeywordBE](), successful: successful)
            } else {
                OSPUserAlerts.showSimpleAlert("generic_title_problem".localized, withMessage: "server_error".localized, withAcceptButton: "ok".localized)
                completion(skills: [KeywordBE](), successful: successful)
            }
        }
    }
    
    class func deleteUserSkill(skillName: String, withCompletion completion : (skills : [KeywordBE]?, successful: Bool) -> Void) {
        
        let objUser = LogInBC.getCurrenteUserSession()
        
        guard let token = objUser!.user_token
            else {
                OSPUserAlerts.showSimpleAlert("app_name".localized, withMessage: "token_invalid".localized, withAcceptButton: "ok".localized)
                completion(skills: [KeywordBE](), successful: false)
                return
        }
        
        OSPWebModel.deleteUserSkill(objUser!, skillName: skillName, withToken: token) { (skills, errorResponse, successful) in
            
            if (skills != nil) {
                completion(skills: skills!, successful: successful)
            } else if (errorResponse != nil) {
                OSPUserAlerts.showSimpleAlert("generic_title_problem".localized, withMessage: errorResponse!.message!, withAcceptButton: "ok".localized)
                completion(skills: [KeywordBE](), successful: successful)
            } else {
                OSPUserAlerts.showSimpleAlert("generic_title_problem".localized, withMessage: "server_error".localized, withAcceptButton: "ok".localized)
                completion(skills: [KeywordBE](), successful: successful)
            }
        }
    }
    
    // MARK: - Keywords
    class func listStarSubCategoriesToUser(user : User, withCompletion completion : (arrayCategories : NSMutableArray?) -> Void) {
        
        let objUser = LogInBC.getCurrenteUserSession()
        
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
        
    class func listStarUserSubCategoriesToUser(user : User, toSubCategory subCategory : StarSubCategoryBE, withCompletion completion : (arrayUsers : NSMutableArray?, nextPage : String?) -> Void) {
        
        let objUser = LogInBC.getCurrenteUserSession()
        
        if objUser!.user_token == nil {
            OSPUserAlerts.showSimpleAlert("app_name".localized, withMessage: "token_invalid".localized, withAcceptButton: "ok".localized)
            completion(arrayUsers: NSMutableArray(), nextPage: nil)
            return
        }
        
        OSPWebModel.listStarUserSubCategoriesToUser(user, toSubCategory: subCategory, withToken: objUser!.user_token!) { (arrayUsers, nextPage, errorResponse, successful) in
            
            if (arrayUsers != nil) {
                let sortDate = NSSortDescriptor.init(key: "userQualify_date", ascending: false)
                arrayUsers!.sortUsingDescriptors([sortDate])
                
                completion(arrayUsers: arrayUsers!, nextPage: nextPage)
            } else if (errorResponse != nil) {
                OSPUserAlerts.showSimpleAlert("generic_title_problem".localized, withMessage: errorResponse!.message!, withAcceptButton: "ok".localized)
                completion(arrayUsers: NSMutableArray(), nextPage: nil)
            } else {
                OSPUserAlerts.showSimpleAlert("generic_title_problem".localized, withMessage: "server_error".localized, withAcceptButton: "ok".localized)
                completion(arrayUsers: NSMutableArray(), nextPage: nil)
            }
        }
    }
    
    class func listStarUserSubCategoriesToPage(page : String, withCompletion completion : (arrayUsers : NSMutableArray?, nextPage : String?) -> Void) {
        
        let objUser = LogInBC.getCurrenteUserSession()
        
        if objUser!.user_token == nil {
            OSPUserAlerts.showSimpleAlert("app_name".localized, withMessage: "token_invalid".localized, withAcceptButton: "ok".localized)
            completion(arrayUsers: NSMutableArray(), nextPage: nil)
            return
        }
        
        OSPWebModel.listStarUserSubCategoriesToPage(page, withToken: objUser!.user_token!) { (arrayUsers, nextPage, errorResponse, successful) in
            if (arrayUsers != nil) {
                completion(arrayUsers: arrayUsers!, nextPage: nextPage)
            } else if (errorResponse != nil) {
                OSPUserAlerts.showSimpleAlert("generic_title_problem".localized, withMessage: errorResponse!.message!, withAcceptButton: "ok".localized)
                completion(arrayUsers: NSMutableArray(), nextPage: nil)
            } else {
                OSPUserAlerts.showSimpleAlert("generic_title_problem".localized, withMessage: "server_error".localized, withAcceptButton: "ok".localized)
                completion(arrayUsers: NSMutableArray(), nextPage: nil)
            }
        }
    }
    
    // MARK: - Utils
    class func validateUser(user : User?, isEqualToUser newUser : User?) -> Bool {
        
        let userID1 = user?.user_pk
        let userID2 = newUser?.user_pk
        
        return userID1 == userID2 ? true : false
    }
}
