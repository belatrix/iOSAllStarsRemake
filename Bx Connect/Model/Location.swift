//
//  Location.swift
//  Bx Connect
//
//  Created by Erik Fernando Flores Quispe on 25/05/17.
//  Copyright © 2017 Belatrix. All rights reserved.
//

import UIKit
import SwiftyJSON

class Location: NSObject {

    var id:Int?
    var name:String?
    var icon:String?
    var isActive:Bool?
    
    init(data: JSON) {
        self.id = data["id"].int
        self.name = data["name"].string
        self.icon = data["icon"].string
        self.isActive = data["isActive"].bool
    }
}
