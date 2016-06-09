//
//  UserSession.swift
//  AllStars
//
//  Created by Flavio Franco Tunqui on 6/9/16.
//  Copyright © 2016 Belatrix SF. All rights reserved.
//

import UIKit

class UserSession: NSObject {
    
    var session_reset_password_code     : String?
    var session_base_profile_complete   : Bool?
    var session_user_id                 : NSNumber?
    var session_token                   : String?
}