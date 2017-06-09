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
        //self.moreNavigationController.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName:#colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)]
        self.moreNavigationController.navigationBar.barStyle = .black
        
        if #available(iOS 11.0, *) {
            self.moreNavigationController.navigationBar.prefersLargeTitles = true
        } else {
            // Fallback on earlier versions
        }
        
    }
    
    /*
     UIView*          edit_views = [tabBarController.view.subviews objectAtIndex:1];
     UINavigationBar* bar        = [[edit_views subviews]objectAtIndex:1];
     
     bar.barTintColor = [UIColor redColor];
     bar.tintColor    = [UIColor whiteColor];
     for (int i = 3; i < [edit_views.subviews count]; i++)
     {
     UIButton *button = [[edit_views subviews]objectAtIndex:i];
     button.tintColor = [UIColor redColor];
     }
     */

}
