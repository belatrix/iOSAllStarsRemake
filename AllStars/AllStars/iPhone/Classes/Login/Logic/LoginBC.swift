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
        
        OSPWebModel.loginWithUser(user) { (userSession : UserSession?, messageError : String?) in
            
            if userSession == nil && messageError != nil {
                OSPUserAlerts.mostrarAlertaConTitulo("Error", conMensaje: messageError!, conBotonCancelar: "Accept", enController: controller, conCompletion: nil)
                
                completion(userSession: userSession, accountState: "")
            } else {
                let userTemp = User()
                userTemp.user_token = userSession!.session_token!
                userTemp.user_pk = userSession!.session_user_id!
                
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
        SessionUD.sharedInstance.setUserPk(Int(user!.user_pk!))
        SessionUD.sharedInstance.setUserToken(user!.user_token!)
        
        if let first_name = user!.user_first_name {
            SessionUD.sharedInstance.setUserFirstName(first_name)
        }
        
        if let last_name = user!.user_last_name {
            SessionUD.sharedInstance.setUserLastName(last_name)
        }
        
        if let skype_id = user!.user_skype_id {
            SessionUD.sharedInstance.setUserSkypeId(skype_id)
        }
        
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        appDelegate.objUserSession = user
    }
    
    class func getCurrenteUserSession() -> User? {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        return appDelegate.objUserSession
    }
}