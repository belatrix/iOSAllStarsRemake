//
//  UserSession.swift
//  AllStars
//
//  Created by Flavio Franco Tunqui on 6/9/16.
//  Copyright © 2016 Belatrix SF. All rights reserved.
//

import UIKit

class UserSession: NSObject {
    
    var session_pwd_reset_required      : Bool?
    var session_base_profile_complete   : Bool?
    var session_user_id                 : NSNumber?
    var session_token                   : String?
}