//
//  ErrorResponse.swift
//  AllStars
//
//  Created by Flavio Franco Tunqui on 6/16/16.
//  Copyright © 2016 Belatrix SF. All rights reserved.
//

import UIKit

class ErrorResponse: NSObject {
    var state : NSNumber? {
        didSet {
            verifySessionValid()
        }
    }
    var message : String?
    
    // Validate if Session is Expired or the user is forbidden for the service
    // If so, close the session and ask for login again
    func verifySessionValid () {
        
        if let state = self.state?.integerValue where state == 401 {
            
            let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
            
            appDelegate.sessionExpiredHandler()
        }
    }
}