//
//  UIColorExtension.swift
//  API-PayMe
//
//  Created by Flavio Franco Tunqui on 2/21/16.
//  Copyright © 2016 Solera. All rights reserved.
//

import UIKit

extension UIColor {
    public convenience init(rgba: UInt32, alphaCGFloat : CGFloat) {
        let red = CGFloat((rgba & 0xFF0000) >> 16)/256.0
        let green = CGFloat((rgba & 0xFF00) >> 8)/256.0
        let blue = CGFloat(rgba & 0xFF)/256.0
        self.init(red:red, green:green, blue:blue, alpha:alphaCGFloat)
    }
}