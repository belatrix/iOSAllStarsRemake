//
//  Color.swift
//  API-PayMe
//
//  Created by Flavio Franco Tunqui on 2/21/16.
//  Copyright © 2016 Solera. All rights reserved.
//

import UIKit

extension UIColor {
    
    class func colorPrimary() -> UIColor {
        return UIColor(rgba: 0xF3743E, alphaCGFloat: 1)
    }
    
    class func colorPrimaryLight() -> UIColor {
        return UIColor(rgba: 0x008bb5, alphaCGFloat: 1)
    }
    
    class func colorPrimaryDark() -> UIColor {
        return UIColor(rgba: 0x00313f, alphaCGFloat: 1)
    }
    
    class func colorAccent() -> UIColor {
        return UIColor(rgba: 0xFC5632, alphaCGFloat: 1)
    }
    
    class func lightAccent() -> UIColor {
        return UIColor(rgba: 0xFF9E80, alphaCGFloat: 1)
    }
    
    class func darkAccent() -> UIColor {
        return UIColor(rgba: 0x1A4F9F, alphaCGFloat: 1)
    }
    
    class func belatrix() -> UIColor {
        return UIColor(rgba: 0xFF8F03, alphaCGFloat: 1)
    }
    
    class func score() -> UIColor {
        return UIColor(rgba: 0xE6E6E6, alphaCGFloat: 1)
    }
}