//
//  MainTabBarController.swift
//  Bx Connect
//
//  Created by Erik Fernando Flores Quispe on 9/06/17.
//  Copyright © 2017 Belatrix. All rights reserved.
//

import UIKit

class MainTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.moreNavigationController.navigationBar.isTranslucent = false
        self.moreNavigationController.topViewController?.view.tintColor = #colorLiteral(red: 0.9450471997, green: 0.3605467975, blue: 0.04605709761, alpha: 1)
        self.moreNavigationController.navigationBar.barTintColor = #colorLiteral(red: 0.9450471997, green: 0.3605467975, blue: 0.04605709761, alpha: 1)
        self.moreNavigationController.navigationBar.tintColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        self.moreNavigationController.navigationBar.barStyle = .black
        self.customizableViewControllers = nil
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.moreNavigationController.navigationBar.topItem?.rightBarButtonItem = nil
    }
 

}
