//
//  CustomTabBarViewController.swift
//  AllStars
//
//  Created by Kenyi Rodriguez Vergara on 5/05/16.
//  Copyright © 2016 Belatrix SF. All rights reserved.
//

import UIKit

class CustomTabBarViewController: UITabBarController {

    
    lazy var arrayButtonsTab : NSMutableArray = {
       
        let _arrayButtonsTab = NSMutableArray()
        return _arrayButtonsTab
    }()
    
    
    override func viewDidLoad() {
        
        let screenSize = UIScreen.mainScreen().bounds.size
        let tabBarView = UIView(frame:CGRectMake(0,screenSize.height - 49, screenSize.width, 49))
        tabBarView.backgroundColor = UIColor.whiteColor()
        tabBarView.layer.shadowOffset = CGSizeMake(0, 0)
        tabBarView.layer.shadowRadius = 3
        tabBarView.layer.shadowOpacity = 0.4
        self.view.addSubview(tabBarView)
        
        let numerTabs = 4
        let widthItemTab = UIScreen.mainScreen().bounds.size.width / CGFloat(numerTabs)

        for index in 0...(numerTabs - 1) {
           
            let button = UIButton(type: .System)
            button.setImage(UIImage(named: "iconTabBar_\(index).png"), forState: .Normal)
            button.frame = CGRectMake(widthItemTab * CGFloat(index), 0, widthItemTab, 49)
            button.tintColor = UIColor.darkGrayColor()
            button.tag = index
            button.addTarget(self, action: #selector(CustomTabBarViewController.tapBarButton(_:)), forControlEvents: UIControlEvents.TouchUpInside)
            tabBarView.addSubview(button)
            self.arrayButtonsTab.addObject(button)
        }
        
        self.tapBarButton(self.arrayButtonsTab[0] as! UIButton)
        
        super.viewDidLoad()
    }
    
    
    func tapBarButton(sender : UIButton) {
        
        self.selectedIndex = sender.tag
        
        self.arrayButtonsTab.enumerateObjectsUsingBlock { (obj : AnyObject, idx : Int, stop : UnsafeMutablePointer<ObjCBool>) in
            let btn = obj as! UIButton
            btn.tintColor = UIColor.darkGrayColor()
        }
        
        sender.tintColor = UIColor(red: 37.0/255.0, green: 185.0/255.0, blue: 1, alpha: 1)
    }
    
    
    override func viewWillAppear(animated: Bool) {
        
        super.viewWillAppear(animated)
    }

    
    override func viewDidAppear(animated: Bool) {
        
        let objUser = LoginBC.getCurrenteUserSession()
        
        if objUser == nil {
            self.performSegueWithIdentifier("LoginViewController", sender: nil)
        }
        
        super.viewDidAppear(animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
