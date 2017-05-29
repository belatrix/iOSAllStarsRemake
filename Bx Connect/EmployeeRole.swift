//
//  EmployeeRole.swift
//  Bx Connect
//
//  Created by Erik Fernando Flores Quispe on 25/05/17.
//  Copyright © 2017 Belatrix. All rights reserved.
//

import UIKit
import SwiftyJSON

class EmployeeRole: NSObject {
    
    var pk:Int?
    var name:String?
    
    init(data:JSON) {
        self.pk = data["pk"].int
        self.name = data["name"].string
    }

}

extension EmployeeRole {
    
    static func getList(data: JSON) -> [EmployeeRole]{
        var list:[EmployeeRole] = []
        for (_,subJson):(String, JSON) in data {
            list.append(EmployeeRole(data: subJson))
        }
        return list
    }

}
