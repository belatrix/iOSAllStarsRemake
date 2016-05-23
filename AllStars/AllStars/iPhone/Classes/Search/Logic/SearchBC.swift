//
//  SearchBC.swift
//  AllStars
//
//  Created by Kenyi Rodriguez Vergara on 10/05/16.
//  Copyright © 2016 Belatrix SF. All rights reserved.
//

import UIKit

class SearchBC: NSObject {

    
    class func listEmployeeToPage(page : String, withCompletion completion : (arrayEmployee : NSMutableArray, nextPage : String?) -> Void) -> NSURLSessionDataTask?{
        
        let currentUser = LoginBC.getCurrenteUserSession()
        
        if currentUser?.user_token == nil {
            completion(arrayEmployee: NSMutableArray(), nextPage : nil)
            return nil
        }
        
        return OSPWebModel.listEmployeeToPage(page, withToken: currentUser!.user_token!) { (arrayEmployee, nextPage) in
            completion(arrayEmployee: arrayEmployee, nextPage: nextPage)
        }
    }
    
    
    
    
    class func listEmployeeWithText(text : String, withCompletion completion : (arrayEmployee : NSMutableArray, nextPage : String?) -> Void) -> NSURLSessionDataTask? {
        
        let currentUser = LoginBC.getCurrenteUserSession()
        
        if currentUser?.user_token == nil {
            completion(arrayEmployee: NSMutableArray(), nextPage : nil)
            return nil
        }
        
        let newSearchText = text.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLFragmentAllowedCharacterSet())
        if newSearchText == nil {
            return nil
        }
        
        return OSPWebModel.listEmployeeWithText(newSearchText!, withToken: currentUser!.user_token!) { (arrayEmployee, nextPage) in
            
            completion(arrayEmployee: arrayEmployee, nextPage: nextPage)
        }
    }
    
    
    
    
    
    class func listEmployeeWithCompletion(completion : (arrayEmployee : NSMutableArray, nextPage : String?) -> Void) -> NSURLSessionDataTask? {
        
        let currentUser = LoginBC.getCurrenteUserSession()
        
        if currentUser?.user_token == nil {
            completion(arrayEmployee: NSMutableArray(), nextPage : nil)
            return nil
        }
        
        return OSPWebModel.listEmployeeWithToken(currentUser!.user_token!) { (arrayEmployee, nextPage) in
            
            completion(arrayEmployee: arrayEmployee, nextPage: nextPage)
        }
    }
}
