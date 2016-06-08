//
//  Util.swift
//  AllStars
//
//  Created by Flavio Franco Tunqui on 6/8/16.
//  Copyright © 2016 Belatrix SF. All rights reserved.
//

import UIKit

class Util: NSObject {
    
    class func isValidEmail(testStr:String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluateWithObject(testStr)
    }
}