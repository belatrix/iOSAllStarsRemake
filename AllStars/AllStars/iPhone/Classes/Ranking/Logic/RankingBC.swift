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
        
        let currentUser = LoginBC.getCurrenteUserSession()
        
        if currentUser?.user_token == nil || kind == nil {
            completion(arrayUsersRanking: NSMutableArray())
            return
        }
        
        
        OSPWebModel.listUserRankingToKind(kind!, withToken: currentUser!.user_token!) { (arrayUsersRanking) in
            
            completion(arrayUsersRanking: arrayUsersRanking)
        }
    }

    
    
    

    class func listUserRankingTotalScoreWithCompletion(completion : (arrayUsersRanking : NSMutableArray) -> Void) {
        
        let currentUser = LoginBC.getCurrenteUserSession()
        
        if currentUser?.user_token == nil {
            completion(arrayUsersRanking: NSMutableArray())
            return
        }
        
        
        OSPWebModel.listUserRankingToKind("total_score", withToken: currentUser!.user_token!) { (arrayUsersRanking) in
            
            completion(arrayUsersRanking: arrayUsersRanking)
        }
    }
    
    
    
    
    class func listUserRankingLastMonthWithCompletion(completion : (arrayUsersRanking : NSMutableArray) -> Void) {
        
        let currentUser = LoginBC.getCurrenteUserSession()
        
        if currentUser?.user_token == nil {
            completion(arrayUsersRanking: NSMutableArray())
            return
        }
        
        
        OSPWebModel.listUserRankingToKind("last_month_score", withToken: currentUser!.user_token!) { (arrayUsersRanking) in
            
            completion(arrayUsersRanking: arrayUsersRanking)
        }
    }
    
    
    
    
    class func listUserRankingCurrentMonthWithCompletion(completion : (arrayUsersRanking : NSMutableArray) -> Void) {
        
        let currentUser = LoginBC.getCurrenteUserSession()
        
        if currentUser?.user_token == nil {
            completion(arrayUsersRanking: NSMutableArray())
            return
        }
        
        
        OSPWebModel.listUserRankingToKind("current_month_score", withToken: currentUser!.user_token!) { (arrayUsersRanking) in
            
            completion(arrayUsersRanking: arrayUsersRanking)
        }
    }
    
    
}
