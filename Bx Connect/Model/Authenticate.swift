//
//  Authenticate.swift
//  Bx Connect
//
//  Created by Erik Fernando Flores Quispe on 25/05/17.
//  Copyright © 2017 Belatrix. All rights reserved.
//

import UIKit
import SwiftyJSON
import SwiftyUserDefaults

class Authenticate: NSObject {
    
    var token:String?
    var isPasswordResetRequired:Bool?
    var isBaseProfileComplete:Bool?
    var resetPasswordCode:String?
    var isStaff:Bool?
    var userID:Int?
    
    init(data: JSON) {
        self.token = data["token"].string
        self.isPasswordResetRequired = data["is_password_reset_required"].bool
        self.isBaseProfileComplete = data["is_base_profile_complete"].bool
        self.resetPasswordCode = data["reset_password_code"].string
        self.isStaff = data["is_staff"].bool
        self.userID = data["user_id"].int
    }

}

extension Authenticate {
    func saveInDefaults() {
        Defaults[.token] = self.token!
        Defaults[.userID] = self.userID!
    }
}
