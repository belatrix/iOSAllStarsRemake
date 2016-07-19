//
//  OSPUserAlerts.swift
//  BookShelf
//
//  Created by Kenyi Rodriguez on 18/04/16.
//  Copyright © 2016 Online Studio Productions. All rights reserved.
//

import UIKit

class OSPUserAlerts: NSObject {
    
    class func showSimpleAlert(title: String, withMessage message : String, withAcceptButton accept: String) {
        let alert = UIAlertView()
        alert.title = title
        alert.message = message
        alert.addButtonWithTitle(accept)
        alert.show()
    }
}