//
//  DefaultsKeys.swift
//  Bx Connect
//
//  Created by Erik Fernando Flores Quispe on 25/05/17.
//  Copyright © 2017 Belatrix. All rights reserved.
//

import SwiftyUserDefaults

extension DefaultsKeys {
    static var token = DefaultsKey<String>("token")
    static var userID = DefaultsKey<Int>("userID")
    static var employee = DefaultsKey<Employee>("employee")
}
