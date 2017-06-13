//
//  String.swift
//  Bx Connect
//
//  Created by Erik Fernando Flores Quispe on 24/05/17.
//  Copyright © 2017 Belatrix. All rights reserved.
//

import Foundation

extension String{
    
    var isValidEmail: Bool {
        return evaluateRegex(Regex.email)
    }
    
    var isValidName: Bool {
        return evaluateRegex(Regex.alphabet)
    }
    
    var isValidAddress: Bool{
        return evaluateRegex(Regex.address)
    }
    
    var isValidAlphaNumeric: Bool{
        return evaluateRegex(Regex.alphNumeric)
    }
    
    var isValidHousePhone: Bool {
        return evaluateRegex(Regex.housePhone)
    }
    
    var isValidMobilePhone: Bool {
        return evaluateRegex(Regex.mobilePhone)
    }
    
    var isValidDni: Bool {
        return evaluateRegex(Regex.dni)
    }
    
    var isValidPassword: Bool {
        return evaluateRegex(Regex.password)
    }
    
    
    func evaluateRegex(_ pattern:String) -> Bool {
        do{
            let regex = try NSRegularExpression(pattern: pattern, options: [.caseInsensitive])
            return regex.firstMatch(in: self, options: [], range: NSMakeRange(0, utf16.count)) != nil
        }catch let error as NSError{
            print("Expresion Error: \(error.localizedDescription)")
        }
        return false
    }
    
}
