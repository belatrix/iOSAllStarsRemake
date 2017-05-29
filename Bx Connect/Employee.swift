//
//  Employee.swift
//  Bx Connect
//
//  Created by Erik Fernando Flores Quispe on 25/05/17.
//  Copyright © 2017 Belatrix. All rights reserved.
//

import UIKit
import SwiftyJSON

class Employee: NSObject {
    
    var pk:Int?
    var username:String?
    var email:String?
    var firstName:String?
    var lastName:String?
    var location:Location?
    var skypeId:String?
    var avatar:String?
    var isBaseProfileComplete:Bool?
    var isPasswordResetRequired:Bool?
    var lastMonthScore:Int?
    var lastYearScore:Int?
    var currentMonthScore:Int?
    var currentYearScore:Int?
    var level:Int?
    var totalScore:Int?
    var isActive:Bool?
    var isBlocked:Bool?
    var isAdmin:String?
    var lastLogin:String?
    var totalGiven:Int?
    var position:Position?
    var roles:[EmployeeRole]?
    
    init(data: JSON) {
        self.pk = data["pk"].int
        self.username = data["username"].string
        self.email = data["email"].string
        self.firstName = data["first_name"].string
        self.lastName = data["last_name"].string
        self.location = Location(data: data["location"])
        self.skypeId = data["skype_id"].string
        self.avatar = data["avatar"].string
        self.isBaseProfileComplete = data["is_base_profile_complete"].bool
        self.isPasswordResetRequired = data["is_password_reset_required"].bool
        self.lastMonthScore = data["last_month_score"].int
        self.lastYearScore = data["last_year_score"].int
        self.currentMonthScore = data["current_month_score"].int
        self.currentYearScore = data["current_year_score"].int
        self.level = data["level"].int
        self.totalScore = data["total_score"].int
        self.isActive = data["is_active"].bool
        self.isBlocked = data["is_blocked"].bool
        self.isAdmin = data["is_admin"].string
        self.lastLogin = data["last_loggin"].string
        self.totalGiven = data["total_given"].int
        self.position = Position(data: data["position"])
        self.roles = EmployeeRole.getList(data: data["roles"])
    }
    

}
