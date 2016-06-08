//
//  ProfileBC.swift
//  AllStars
//
//  Created by Kenyi Rodriguez Vergara on 6/05/16.
//  Copyright © 2016 Belatrix SF. All rights reserved.
//

import UIKit

class ProfileBC: NSObject {

    
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
    
    
    class func getInfoToUser(user : User, withCompletion completion : (user : User?) -> Void) {
        
        let objCurrentUser = LoginBC.getCurrenteUserSession()
        
        OSPWebModel.getUserInfo(user, withToken: objCurrentUser!.user_token!) { (user, messageError) in
            
            completion(user: user)
        }
    }
    
    
    
    class func listStarSubCategoriesToUser(user : User, withCompletion completion : (arrayCategories : NSMutableArray) -> Void) {
        
        let currentUser = LoginBC.getCurrenteUserSession()
        
        if currentUser?.user_token == nil {
            completion(arrayCategories: NSMutableArray())
            return
        }
        
        OSPWebModel.listStarSubCategoriesToUser(user, withToken: currentUser!.user_token!) { (arrayCategories) in
            
            completion(arrayCategories: arrayCategories)
        }
    }
    
    class func listLocationsWithCompletion(completion : (arrayLocations : NSMutableArray) -> Void) {
        
        let currentUser = LoginBC.getCurrenteUserSession()
        
        if currentUser?.user_token == nil {
            completion(arrayLocations: NSMutableArray())
            return
        }
        
        OSPWebModel.listLocationsWithToken (currentUser!.user_token!) { (arrayLocations) in
            
            completion(arrayLocations: arrayLocations)
        }
        
    }
    
    class func updateInfoToUser(user : User, withController controller: UIViewController, withCompletion completion : (isCorrect : Bool) -> Void) {
        
        let objCurrentUser = LoginBC.getCurrenteUserSession()
        
        if objCurrentUser!.user_token == nil {
            OSPUserAlerts.mostrarAlertaConTitulo("Error", conMensaje: "Problems with your conecction. Try again please.", conBotonCancelar: "Accept", enController: controller, conCompletion: nil)
            completion(isCorrect: false)
            return
        }
        
        if (user.user_first_name == nil || user.user_first_name == "") {
            OSPUserAlerts.mostrarAlertaConTitulo("Error", conMensaje: "First Name must not be empty", conBotonCancelar: "Accept", enController: controller, conCompletion: nil)
            completion(isCorrect: false)
            return
        }
        
        if (user.user_last_name == nil || user.user_last_name == "") {
            OSPUserAlerts.mostrarAlertaConTitulo("Error", conMensaje: "Last Name must not be empty", conBotonCancelar: "Accept", enController: controller, conCompletion: nil)
            completion(isCorrect: false)
            return
        }
        
        
        if (user.user_skype_id == nil || user.user_skype_id == "") {
            OSPUserAlerts.mostrarAlertaConTitulo("Error", conMensaje: "Skipe Id must not be empty", conBotonCancelar: "Accept", enController: controller, conCompletion: nil)
            completion(isCorrect: false)
            return
        }
        
        if (user.user_location_id == nil) {
            OSPUserAlerts.mostrarAlertaConTitulo("Error", conMensaje: "Must select a location", conBotonCancelar: "Accept", enController: controller, conCompletion: nil)
            completion(isCorrect: false)
            return
        }
        
        OSPWebModel.updateUser(user, withToken: objCurrentUser!.user_token!) { (isCorrect) in
            
            if (isCorrect == false) {
                OSPUserAlerts.mostrarAlertaConTitulo("Error", conMensaje: "Problems with your conecction. Try again please.", conBotonCancelar: "Accept", enController: controller, conCompletion: nil)
            }
            
            completion(isCorrect: isCorrect)
        }
    }
    
    class func updatePhotoToUser(user : User, withController controller: UIViewController, withImage image : NSData, withCompletion completion : (isCorrect : Bool) -> Void) {
        
        let objCurrentUser = LoginBC.getCurrenteUserSession()
        
        OSPWebModel.updatePhoto(user, withToken: objCurrentUser!.user_token!, withImage: image) { (isCorrect) in
            
            if (isCorrect == false) {
                OSPUserAlerts.mostrarAlertaConTitulo("Error", conMensaje: "Problems with your conecction. Try again please.", conBotonCancelar: "Accept", enController: controller, conCompletion: nil)
            }
            
            completion(isCorrect: isCorrect)
        }
    }
}
