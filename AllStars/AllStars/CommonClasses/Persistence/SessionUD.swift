//
//  SettingsUD.swift
//  Climandes
//
//  Created by Flavio Franco Tunqui on 2/1/16.
//  Copyright © 2016 solera. All rights reserved.
//

import UIKit

class SessionUD: NSUserDefaults {
    
    let UD_USER_PK                      : String = "user_pk"
    let UD_USER_TOKEN                   : String = "user_token"
    let UD_USER_FIRST_NAME              : String = "user_first_name"
    let UD_USER_LAST_NAME               : String = "user_last_name"
    let UD_USER_SKYPE_ID                : String = "user_skype_id"
    let UD_USER_BASE_PROFILE_COMPLETE   : String = "base_profile_complete"
    let UD_USER_PUSH_TOKEN              : String = "push_token"
    let UD_USER_PUSH_ENABLE              : String = "push_notification_enable"
    
    static let sharedInstance = SessionUD()
    
    func setUserPk (value : Int) {
        self.setInteger(value, forKey: UD_USER_PK)
    }
    
    func getUserPk () -> Int {
        if let userPK : Int = self.integerForKey(UD_USER_PK) {
            return userPK
        } else {
            return -1
        }
    }
    
    func setUserToken (value : String) {
        self.setValue(value, forKey: UD_USER_TOKEN)
    }
    
    func getUserToken () -> String {
        if let userToken : String = self.stringForKey(UD_USER_TOKEN) {
            return userToken
        } else {
            return ""
        }
    }
    
    func setUserFirstName (value : String) {
        self.setValue(value, forKey: UD_USER_FIRST_NAME)
    }
    
    func getUserFirstName () -> String {
        if let userFirstName : String = self.stringForKey(UD_USER_FIRST_NAME) {
            return userFirstName
        } else {
            return ""
        }
    }
    
    func setUserLastName (value : String) {
        self.setValue(value, forKey: UD_USER_LAST_NAME)
    }
    
    func getUserLastName () -> String {
        if let userLastName : String = self.stringForKey(UD_USER_LAST_NAME) {
            return userLastName
        } else {
            return ""
        }
    }
    
    func setUserSkypeId (value : String) {
        self.setValue(value, forKey: UD_USER_SKYPE_ID)
    }
    
    func getUserSkypeId () -> String {
        if let userSkypeId : String = self.stringForKey(UD_USER_SKYPE_ID) {
            return userSkypeId
        } else {
            return ""
        }
    }
    
    func setUserBaseProfileComplete (value : Bool) {
        self.setBool(value, forKey: UD_USER_BASE_PROFILE_COMPLETE)
    }
    
    func getUserBaseProfileComplete () -> Bool {
        if let userBaseProfileComplete : Bool = self.boolForKey(UD_USER_BASE_PROFILE_COMPLETE) {
            return userBaseProfileComplete
        } else {
            return false
        }
    }
    
    func setUserPushToken (value : String) {
        self.setValue(value, forKey: UD_USER_PUSH_TOKEN)
    }
    
    func getUserPushToken () -> String {
        if let userPUSHToken : String = self.stringForKey(UD_USER_PUSH_TOKEN) {
            return userPUSHToken
        } else {
            return ""
        }
    }
    
    func setUserIsPushNotificationEnable (value : Bool) {
        self.setBool(value, forKey: UD_USER_PUSH_ENABLE)
    }
    
    func getUserIsPushNotificationEnable () -> Bool {
        if let userIsPushNotificationEnable : Bool = self.boolForKey(UD_USER_PUSH_ENABLE) {
            return userIsPushNotificationEnable
        } else {
            return false
        }
    }
    
    func clearSession() {
        self.setUserPk(-1)
        self.setUserToken("")
        self.setUserFirstName("")
        self.setUserLastName("")
        self.setUserSkypeId("")
        self.setUserBaseProfileComplete(false)
        
        FBSDKLoginManager().logOut()
    }
}