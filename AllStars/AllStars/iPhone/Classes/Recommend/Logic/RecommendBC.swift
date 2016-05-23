//
//  RecommendBC.swift
//  AllStars
//
//  Created by Kenyi Rodriguez Vergara on 11/05/16.
//  Copyright © 2016 Belatrix SF. All rights reserved.
//

import UIKit

class RecommendBC: NSObject {

    
    
    class func rateUser(rate : RateUserBE, withController controller : UIViewController, withCompletion completion : (isCorrect : Bool) -> Void) {
        
        let currentUser = LoginBC.getCurrenteUserSession()
        
        if currentUser?.user_token == nil {
            OSPUserAlerts.mostrarAlertaConTitulo("Error", conMensaje: "Problems with your conecction. Try again please.", conBotonCancelar: "Accept", enController: controller, conCompletion: nil)
            completion(isCorrect: false)
            return
        }
        
        if rate.rate_category == nil {
            OSPUserAlerts.mostrarAlertaConTitulo("Error", conMensaje: "You need select a category", conBotonCancelar: "Accept", enController: controller, conCompletion: nil)
            completion(isCorrect: false)
            return
        }
        
        if rate.rate_subCategory == nil {
            OSPUserAlerts.mostrarAlertaConTitulo("Error", conMensaje: "You need select a subcategory", conBotonCancelar: "Accept", enController: controller, conCompletion: nil)
            completion(isCorrect: false)
            return
        }
        
        
        if rate.rate_keyword == nil {
            OSPUserAlerts.mostrarAlertaConTitulo("Error", conMensaje: "You need select a keyword", conBotonCancelar: "Accept", enController: controller, conCompletion: nil)
            completion(isCorrect: false)
            return
        }
        
        if rate.rate_category?.category_comment_requiered == 1 && rate.rate_comment.characters.count == 0 {
            
            OSPUserAlerts.mostrarAlertaConTitulo("Error", conMensaje: "You need enter a descripction", conBotonCancelar: "Accept", enController: controller, conCompletion: nil)
            completion(isCorrect: false)
            return
        }
        
        rate.rate_fromUser = currentUser
        
        
        OSPWebModel.rateUser(rate, withToken: currentUser!.user_token!) { (isCorrect) in
            
            if (isCorrect == false) {
                OSPUserAlerts.mostrarAlertaConTitulo("Error", conMensaje: "Problems with your conecction. Try again please.", conBotonCancelar: "Accept", enController: controller, conCompletion: nil)
            }
            
            completion(isCorrect: isCorrect)
        }
    }
    
    
    class func listKeyWordsWithCompletion(completion : (arrayKeywords : NSMutableArray) -> Void) {
        
        OSPWebModel.listKeyWordsWithCompletion { (arrayKeywords) in
            
            completion(arrayKeywords: arrayKeywords)
        }
    
    }
    
    
    
    
    class func listAllCatgoriesToUser(user : User, withCompletion completion : (arrayCategories : NSMutableArray) -> Void)  {
        
        let currentUser = LoginBC.getCurrenteUserSession()
        
        if currentUser?.user_token == nil {
            completion(arrayCategories: NSMutableArray())
            return
        }
        
        OSPWebModel.listAllCatgoriesToUser(user, withToken: currentUser!.user_token!) { (arrayCategories) in
            
            let sortName = NSSortDescriptor(key: "category_name", ascending: true)
            arrayCategories.sortUsingDescriptors([sortName])
            completion(arrayCategories: arrayCategories)
        }
    }
}
