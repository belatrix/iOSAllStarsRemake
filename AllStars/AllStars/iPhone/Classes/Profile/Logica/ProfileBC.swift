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
}
