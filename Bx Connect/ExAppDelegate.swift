//
//  AppDelegateConfig.swift
//  Bx Connect
//
//  Created by Erik Fernando Flores Quispe on 25/05/17.
//  Copyright © 2017 Belatrix. All rights reserved.
//

import IQKeyboardManagerSwift
import SwiftyBeaver

let log = SwiftyBeaver.self

extension AppDelegate {

    func podsConfig() {
        
        // Keyboard
        IQKeyboardManager.sharedManager().enable = true
        
        // Log system
        let console = ConsoleDestination()
        log.addDestination(console)
    }
    
    func validateRootView() {
        
    }

}
