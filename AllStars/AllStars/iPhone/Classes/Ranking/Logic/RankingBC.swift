//
//  RankingBC.swift
//  AllStars
//
//  Created by Kenyi Rodriguez Vergara on 13/05/16.
//  Copyright © 2016 Belatrix SF. All rights reserved.
//

import UIKit

class RankingBC: NSObject {
    
    
    class func listUserRankingWithKind(kind : String?, withCompletion completion : (arrayUsersRanking : NSMutableArray) -> Void) {
        
        let currentUser = LogInBC.getCurrenteUserSession()
        
        if currentUser?.user_token == nil || kind == nil {
            completion(arrayUsersRanking: NSMutableArray())
            return
        }
        
        
        OSPWebModel.listUserRankingToKind(kind!, withToken: currentUser!.user_token!) { (arrayUsersRanking) in
            
            completion(arrayUsersRanking: arrayUsersRanking)
        }
    }

    
    
    

    class func listUserRankingTotalScoreWithCompletion(completion : (arrayUsersRanking : NSMutableArray) -> Void) {
        
        let currentUser = LogInBC.getCurrenteUserSession()
        
        if currentUser?.user_token == nil {
            completion(arrayUsersRanking: NSMutableArray())
            return
        }
        
        
        OSPWebModel.listUserRankingToKind("total_score", withToken: currentUser!.user_token!) { (arrayUsersRanking) in
            
            completion(arrayUsersRanking: arrayUsersRanking)
        }
    }
    
    
    
    
    class func listUserRankingLastMonthWithCompletion(completion : (arrayUsersRanking : NSMutableArray) -> Void) {
        
        let currentUser = LogInBC.getCurrenteUserSession()
        
        if currentUser?.user_token == nil {
            completion(arrayUsersRanking: NSMutableArray())
            return
        }
        
        
        OSPWebModel.listUserRankingToKind("last_month_score", withToken: currentUser!.user_token!) { (arrayUsersRanking) in
            
            completion(arrayUsersRanking: arrayUsersRanking)
        }
    }
    
    
    
    
    class func listUserRankingCurrentMonthWithCompletion(completion : (arrayUsersRanking : NSMutableArray) -> Void) {
        
        let currentUser = LogInBC.getCurrenteUserSession()
        
        if currentUser?.user_token == nil {
            completion(arrayUsersRanking: NSMutableArray())
            return
        }
        
        
        OSPWebModel.listUserRankingToKind("current_month_score", withToken: currentUser!.user_token!) { (arrayUsersRanking) in
            
            completion(arrayUsersRanking: arrayUsersRanking)
        }
    }
    
    class func listStarKeywordToPage(page : String, withCompletion completion : (arrayUsers : NSMutableArray, nextPage : String?) -> Void) -> NSURLSessionDataTask? {
        
        let currentUser = LogInBC.getCurrenteUserSession()
        
        if currentUser?.user_token == nil {
            completion(arrayUsers: NSMutableArray(), nextPage : nil)
            return nil
        }
        
        return OSPWebModel.listEmployeeKeywordToPage(page, withToken: currentUser!.user_token!) { (arrayEmployee, nextPage) in
            
            completion(arrayUsers: arrayEmployee, nextPage: nextPage)
        }
    }
    
    class func listStarKeywordWithCompletion(starKeyword : StarKeywordBE, withCompletion completion : (arrayUsers : NSMutableArray, nextPage : String?) -> Void) -> NSURLSessionDataTask? {
        
        let currentUser = LogInBC.getCurrenteUserSession()
        
        if currentUser?.user_token == nil {
            completion(arrayUsers: NSMutableArray(), nextPage : nil)
            return nil
        }
        
        return OSPWebModel.listEmployeeKeywordWithToken(starKeyword, withToken: currentUser!.user_token!) { (arrayEmployee, nextPage) in
            
            completion(arrayUsers: arrayEmployee, nextPage: nextPage)
        }
    }
}