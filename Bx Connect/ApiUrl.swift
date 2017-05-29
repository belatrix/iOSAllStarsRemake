//
//  ApiUrl.swift
//  Bx Connect
//
//  Created by Erik Fernando Flores Quispe on 24/05/17.
//  Copyright © 2017 Belatrix. All rights reserved.
//

import Foundation

struct Api {
    struct Url {
        static let root = "https://bxconnect.herokuapp.com:443"
        static let authenticate = "\(root)/api/employee/authenticate/"
        static func employee(with id:Int) -> String {
            return "\(root)/api/employee/\(id)"
        }
    }
}
