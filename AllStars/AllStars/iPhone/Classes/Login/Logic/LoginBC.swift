//
//  LoginBC.swift
//  AllStars
//
//  Created by Kenyi Rodriguez Vergara on 5/05/16.
//  Copyright © 2016 Belatrix SF. All rights reserved.
//

import UIKit

class LoginBC: NSObject {
    
    
    
    

    class func loginWithUser(user : User, withController controller : UIViewController, withCompletion completion : (user : User?) -> Void) {
        
        OSPWebModel.loginWithUser(user) { (user : User?, messageError : String?) in
            
            if user == nil && messageError != nil {
                OSPUserAlerts.mostrarAlertaConTitulo("Error", conMensaje: messageError!, conBotonCancelar: "Accept", enController: controller, conCompletion: nil)
            }
            
            self.saveSesionOfUser(user)
            completion(user: user)
        }
    }
    
    
 
    class func getUserSessionInfoConCompletion(completion : (user : User?) -> Void) {
        
        let objUser = self.getCurrenteUserSession()
        
        if objUser == nil || objUser?.user_token == nil {
            completion(user: nil)
            return
        }
        
    
        OSPWebModel.getUserInfo(objUser!, withToken: objUser!.user_token!) { (user, messageError) in
            
            user?.user_id = objUser?.user_id
            user?.user_token = objUser?.user_token
            self.saveSesionOfUser(user)
            
            completion(user: user)
        }
    }
    
    
    
    class func user(user : User?, isEqualToUser newUser : User?) -> Bool{
        
        let userID1 = user?.user_id != nil ? user?.user_id : user?.user_pk
        let userID2 = newUser?.user_id != nil ? newUser?.user_id : newUser?.user_pk
        
        return userID1 == userID2 ? true : false
    }
    
    
    
    class func saveSesionOfUser(user : User?){
        
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        appDelegate.objUserSession = user
    }
    
    
    class func getCurrenteUserSession() -> User? {
    
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        return appDelegate.objUserSession
    }
}
