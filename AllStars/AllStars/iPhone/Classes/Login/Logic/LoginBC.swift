//
//  LoginBC.swift
//  AllStars
//
//  Created by Kenyi Rodriguez Vergara on 5/05/16.
//  Copyright © 2016 Belatrix SF. All rights reserved.
//

import UIKit

class LoginBC: NSObject {

    class func loginWithUser(user : User, withController controller : UIViewController, withCompletion completion : (userSession : UserSession?, accountState : String?) -> Void) {
        
        if (user.user_username == nil || user.user_username!.isEmpty == true) {
            OSPUserAlerts.mostrarAlertaConTitulo("Error", conMensaje: "Username must not be empty", conBotonCancelar: "Accept", enController: controller, conCompletion: nil)
            
            completion(userSession: nil, accountState: "")
            return
        }
        
        if (user.user_password == nil || user.user_password!.isEmpty == true) {
            OSPUserAlerts.mostrarAlertaConTitulo("Error", conMensaje: "Password must not be empty", conBotonCancelar: "Accept", enController: controller, conCompletion: nil)
            
            completion(userSession: nil, accountState: "")
            return
        }
        
        OSPWebModel.loginWithUser(user) { (userSession : UserSession?, messageError : String?) in
            
            if userSession == nil && messageError != nil {
                OSPUserAlerts.mostrarAlertaConTitulo("Error", conMensaje: messageError!, conBotonCancelar: "Accept", enController: controller, conCompletion: nil)
                
                completion(userSession: userSession, accountState: "")
            } else {
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
            }
        }
    }
    
    class func resetUserPassword(userSession : UserSession, oldPassword : String, newPassword : String, repeatNewPassword : String, withController controller : UIViewController, withCompletion completion : (user : User?, messageError : String?) -> Void) {
        
        if userSession.session_token == nil {
            OSPUserAlerts.mostrarAlertaConTitulo("Error", conMensaje: "Problems with your conecction. Try again please.", conBotonCancelar: "Accept", enController: controller, conCompletion: nil)
            completion(user: nil, messageError: "")
            return
        }
        
        if (oldPassword == "") {
            OSPUserAlerts.mostrarAlertaConTitulo("Error", conMensaje: "Old Password must not be empty", conBotonCancelar: "Accept", enController: controller, conCompletion: nil)
            completion(user: nil, messageError: "")
            return
        }
        
        if (newPassword == "" || repeatNewPassword == "") {
            OSPUserAlerts.mostrarAlertaConTitulo("Error", conMensaje: "New Password must not be empty", conBotonCancelar: "Accept", enController: controller, conCompletion: nil)
            completion(user: nil, messageError: "")
            return
        }
        
        if (newPassword == repeatNewPassword) {
            if (newPassword.characters.count >= Constants.MIN_PASSWORD_LENGTH) {
                OSPWebModel.resetUserPassword(userSession, oldPassword: oldPassword, newPassword: newPassword) { (user : User?, messageError : String?) in
                    
                    if user == nil && messageError != nil {
                        OSPUserAlerts.mostrarAlertaConTitulo("Error", conMensaje: messageError!, conBotonCancelar: "Accept", enController: controller, conCompletion: nil)
                        
                        completion(user: nil, messageError: "")
                    } else {
                        saveSessionOfUser(user)
                        
                        completion(user: user, messageError: "")
                    }
                }
            } else {
                OSPUserAlerts.mostrarAlertaConTitulo("Error", conMensaje: "New Password must be at least \(Constants.MIN_PASSWORD_LENGTH) characters", conBotonCancelar: "Accept", enController: controller, conCompletion: nil)
                completion(user: nil, messageError: "")
                return
            }
        } else {
            OSPUserAlerts.mostrarAlertaConTitulo("Error", conMensaje: "The new password doesn't match", conBotonCancelar: "Accept", enController: controller, conCompletion: nil)
            completion(user: nil, messageError: "")
            return
        }
    }
 
    class func getUserSessionInfoConCompletion(completion : (user : User?) -> Void) {
        
        let objUser = self.getCurrenteUserSession()
        
        if objUser == nil || objUser?.user_token == nil {
            completion(user: nil)
            return
        }
    
        OSPWebModel.getUserInfo(objUser!, withToken: objUser!.user_token!) { (user, messageError) in
            
            user?.user_pk = objUser?.user_pk
            user?.user_token = objUser?.user_token
            self.saveSessionOfUser(user)
            
            completion(user: user)
        }
    }
    
    class func user(user : User?, isEqualToUser newUser : User?) -> Bool{
        
        let userID1 = user?.user_pk
        let userID2 = newUser?.user_pk
        
        return userID1 == userID2 ? true : false
    }
    
    class func saveSessionOfUser(user : User?){
        
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
}