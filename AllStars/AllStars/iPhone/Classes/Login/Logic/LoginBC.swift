//
//  LoginBC.swift
//  AllStars
//
//  Created by Kenyi Rodriguez Vergara on 5/05/16.
//  Copyright © 2016 Belatrix SF. All rights reserved.
//

import UIKit

class LogInBC: NSObject {

    class func logInWithUser(user : User, withController controller : UIViewController, withCompletion completion : (userSession : UserSession?, accountState : String?) -> Void) {
        
        if (user.user_username == nil || user.user_username!.trim().isEmpty == true) {
            OSPUserAlerts.showSimpleAlert("app_name".localized, withMessage: "username_empty".localized, withAcceptButton: "ok".localized)
            
            completion(userSession: nil, accountState: "")
            return
        }
        
        if (user.user_password == nil || user.user_password!.trim().isEmpty == true) {
            OSPUserAlerts.showSimpleAlert("app_name".localized, withMessage: "password_empty".localized, withAcceptButton: "ok".localized)
            
            completion(userSession: nil, accountState: "")
            return
        }
        
        OSPWebModel.logInUser(user) {(userSession, errorResponse, successful) in
            
            if (userSession != nil) {
                let userTemp = User()
                userTemp.user_token = userSession!.session_token!
                userTemp.user_pk = userSession!.session_user_id!
                userTemp.user_base_profile_complete = userSession!.session_base_profile_complete!
                
                self.saveSessionOfUser(userTemp)
                
                if (userSession!.session_reset_password_code == nil) {
                    if (userSession!.session_base_profile_complete!) {
                        completion(userSession: userSession, accountState: Constants.PROFILE_COMPLETE)
                    } else {
                        completion(userSession: userSession, accountState: Constants.PROFILE_INCOMPLETE)
                    }
                } else {
                    completion(userSession: userSession, accountState: Constants.PASSWORD_RESET_INCOMPLETE)
                }
            } else if (errorResponse != nil) {
                OSPUserAlerts.showSimpleAlert("generic_title_problem".localized, withMessage: errorResponse!.message!, withAcceptButton: "ok".localized)
                
                completion(userSession: userSession, accountState: "")
            } else {
                OSPUserAlerts.showSimpleAlert("generic_title_problem".localized, withMessage: "server_error".localized, withAcceptButton: "ok".localized)
                
                completion(userSession: userSession, accountState: "")
            }
        }
    }
    
    class func registerUserDevice(userDevice : UserDevice, withCompletion completion : (userDevice : UserDevice?) -> Void) {
        
        let objUser = self.getCurrenteUserSession()
        
        if (objUser == nil || objUser!.user_token == nil) {
            OSPUserAlerts.showSimpleAlert("app_name".localized, withMessage: "token_invalid".localized, withAcceptButton: "ok".localized)
            
            completion(userDevice: nil)
            return
        }
        
        OSPWebModel.registerUserDevice(userDevice, withToken: objUser!.user_token!) {(userDevice, errorResponse, successful) in
            
            if (userDevice != nil) {
                completion(userDevice: userDevice)
            } else if (errorResponse != nil) {
                OSPUserAlerts.showSimpleAlert("generic_title_problem".localized, withMessage: errorResponse!.message!, withAcceptButton: "ok".localized)
                completion(userDevice: nil)
            } else {
                OSPUserAlerts.showSimpleAlert("generic_title_problem".localized, withMessage: "server_error".localized, withAcceptButton: "ok".localized)
                completion(userDevice: nil)
            }
        }
    }
    
    class func resetUserPassword(userSession : UserSession, currentPassword : String, newPassword : String, repeatNewPassword : String, withController controller : UIViewController, withCompletion completion : (user : User?) -> Void) {
        
        if userSession.session_token == nil {
            OSPUserAlerts.showSimpleAlert("app_name".localized, withMessage: "token_invalid".localized, withAcceptButton: "ok".localized)
            
            completion(user: nil)
            return
        }
        
        if (currentPassword == "") {
            OSPUserAlerts.showSimpleAlert("app_name".localized, withMessage: "old_password_empty".localized, withAcceptButton: "ok".localized)
            
            completion(user: nil)
            return
        }
        
        if (newPassword == "" || repeatNewPassword == "") {
            OSPUserAlerts.showSimpleAlert("app_name".localized, withMessage: "new_password_empty".localized, withAcceptButton: "ok".localized)
            
            completion(user: nil)
            return
        }
        
        if (newPassword == repeatNewPassword) {
            if (newPassword.characters.count >= Constants.MIN_PASSWORD_LENGTH) {
                OSPWebModel.resetUserPassword(userSession, currentPassword: currentPassword, newPassword: newPassword) {(user, errorResponse, successful) in
                    
                    if (user != nil) {
                        saveSessionOfUser(user)
                        completion(user: user)
                    } else if (errorResponse != nil) {
                        OSPUserAlerts.showSimpleAlert("generic_title_problem".localized, withMessage: errorResponse!.message!, withAcceptButton: "ok".localized)
                        completion(user: nil)
                    } else {
                        OSPUserAlerts.showSimpleAlert("generic_title_problem".localized, withMessage: "server_error".localized, withAcceptButton: "ok".localized)
                        completion(user: nil)
                    }
                }
            } else {
                OSPUserAlerts.showSimpleAlert("app_name".localized, withMessage: "new_password_length".localized + " \(Constants.MIN_PASSWORD_LENGTH) "  + "characters".localized, withAcceptButton: "ok".localized)
                
                completion(user: nil)
            }
        } else {
            OSPUserAlerts.showSimpleAlert("app_name".localized, withMessage: "new_password_match".localized, withAcceptButton: "ok".localized)
            
            completion(user: nil)
        }
    }
 
    class func getUserSessionInformation(completion : (user : User?) -> Void) {
        
        let objUser = self.getCurrenteUserSession()
        
        if (objUser == nil || objUser!.user_token == nil) {
            OSPUserAlerts.showSimpleAlert("app_name".localized, withMessage: "token_invalid".localized, withAcceptButton: "ok".localized)
            
            completion(user: nil)
            return
        }
    
        OSPWebModel.getUserInformation(objUser!, withToken: objUser!.user_token!) {(user, errorResponse, successful) in
            
            if (user != nil) {
                user?.user_pk = objUser?.user_pk
                user?.user_token = objUser?.user_token
                saveSessionOfUser(user)
                
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
    
    class func createParticipant(fullName : String?, email : String?, socialNetworkType : Int, socialNetworkId : String, withCompletion completion : (userGuest : UserGuest?, fieldsCompleted : Bool) -> Void) {
        
        if (fullName == nil || fullName!.isEmpty == true || email == nil || email!.isEmpty == true) {
            completion(userGuest: nil, fieldsCompleted: false)
            return
        }

        OSPWebModel.createParticipant(fullName!, email: email!, socialNetworkType: socialNetworkType, socialNetworkId: socialNetworkId) {(userGuest, errorResponse, successful) in
            
            if (userGuest != nil) {
                completion(userGuest: userGuest, fieldsCompleted: true)
            } else if (errorResponse != nil) {
                OSPUserAlerts.showSimpleAlert("generic_title_problem".localized, withMessage: errorResponse!.message!, withAcceptButton: "ok".localized)
                
                completion(userGuest: userGuest, fieldsCompleted: true)
            } else {
                OSPUserAlerts.showSimpleAlert("generic_title_problem".localized, withMessage: "server_error".localized, withAcceptButton: "ok".localized)
                
                completion(userGuest: userGuest, fieldsCompleted: true)
            }
        }
    }
    
    class func saveSessionOfUser(user : User?) {
        
        if let pk = user!.user_pk {
            SessionUD.sharedInstance.setUserPk(Int(pk))
        }
        
        if let token = user!.user_token {
            SessionUD.sharedInstance.setUserToken(token)
        }
        
        if let base_profile_complete = user!.user_base_profile_complete {
            SessionUD.sharedInstance.setUserBaseProfileComplete(base_profile_complete)
        }
        
        if let first_name = user!.user_first_name {
            SessionUD.sharedInstance.setUserFirstName(first_name)
        }
        
        if let last_name = user!.user_last_name {
            SessionUD.sharedInstance.setUserLastName(last_name)
        }
        
        if let skype_id = user!.user_skype_id {
            SessionUD.sharedInstance.setUserSkypeId(skype_id)
        }
        
        getUserSessionFromUD()
    }
    
    class func getUserSessionFromUD() {
        let session : User = User()
        session.user_pk = SessionUD.sharedInstance.getUserPk()
        session.user_token = SessionUD.sharedInstance.getUserToken()
        session.user_base_profile_complete = SessionUD.sharedInstance.getUserBaseProfileComplete()
        session.user_pk = SessionUD.sharedInstance.getUserPk()
        session.user_first_name = SessionUD.sharedInstance.getUserFirstName()
        session.user_last_name = SessionUD.sharedInstance.getUserLastName()
        session.user_skype_id = SessionUD.sharedInstance.getUserSkypeId()
        
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        appDelegate.objUserSession = session
    }
    
    class func getCurrenteUserSession() -> User? {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        return appDelegate.objUserSession
    }
    
    
    // MARK: - Logout
    class func doLogout(withCompletion completion : (successful : Bool) -> Void) {
        
        let objUser = LogInBC.getCurrenteUserSession()
        
        if objUser!.user_token == nil {
            OSPUserAlerts.showSimpleAlert("app_name".localized, withMessage: "token_invalid".localized, withAcceptButton: "ok".localized)
            completion(successful: false)
            return
        }
        
        OSPWebModel.doLogout((objUser?.user_token)!) { (errorResponse, successful) in
            
            if successful {
                completion(successful: true)
            } else if (errorResponse != nil) {
                
                if let errorMessage = errorResponse!.message where errorMessage != "Invalid token." {
                    
                    OSPUserAlerts.showSimpleAlert("generic_title_problem".localized, withMessage: errorMessage, withAcceptButton: "ok".localized)
                    completion(successful: false)
                } else {
                    
                    completion(successful: true)
                }
                
                
            } else {
                OSPUserAlerts.showSimpleAlert("generic_title_problem".localized, withMessage: "server_error".localized, withAcceptButton: "ok".localized)
                completion(successful: false)
            }
        }
    }
    
    // MARK: - Forgot Password
    class func forgotPassword(mail : String, withCompletion completion : (successful : Bool) -> Void) {
        
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
        
        OSPWebModel.forgotPassword(mail) { (response, successful) in
            
            if (response != nil) {
                if (successful) {
                    OSPUserAlerts.showSimpleAlert("app_name".localized, withMessage: response!.message!, withAcceptButton: "got_it".localized)
                    completion(successful: true)
                } else {
                    OSPUserAlerts.showSimpleAlert("generic_title_problem".localized, withMessage: response!.message!, withAcceptButton: "ok".localized)
                    completion(successful: false)
                }
            } else {
                OSPUserAlerts.showSimpleAlert("generic_title_problem".localized, withMessage: "server_error".localized, withAcceptButton: "ok".localized)
                completion(successful: false)
            }
        }
    }
}