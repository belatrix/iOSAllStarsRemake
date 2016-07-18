//
//  SettingsViewController.swift
//  AllStars
//
//  Created by Ricardo Hernan Herrera Valle on 7/18/16.
//  Copyright © 2016 Belatrix SF. All rights reserved.
//

import Foundation

class SettingsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    
    lazy var options: [SettingsOptions] = {
        
        let isGuest = false
        
        if isGuest {
            
            return [SettingsOptions.logOut]
            
        }
        
        return [SettingsOptions.notification, SettingsOptions.logOut]
        
    }()
    
    // MARK: - Initialization
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 60
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        if let rootVC = self.navigationController?.viewControllers.first where
            rootVC == self.tabBarController?.moreNavigationController.viewControllers.first  {
            
            self.navigationController?.setNavigationBarHidden(false, animated: true)
        }
    }
    
    // MARK: - Style
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
    }
    
    // MARK: - UITableViewDelegate, UITableViewDataSource
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return options.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let option = options[indexPath.row]
        
        switch option {
        case .notification:
        
            guard let cell = tableView.dequeueReusableCellWithIdentifier("notificationCell") as? NotificationCell
                else { fatalError("Settings - No notification cell found") }
            
            cell.notificationSwitch.setOn(SessionUD.sharedInstance.getUserIsPushNotificationEnable(), animated: true)
            
            cell.selectionStyle = .None
            
            return cell
        
        case .logOut:
            
            guard let cell = tableView.dequeueReusableCellWithIdentifier("logoutCell")
                else { fatalError("Settings - No logout cell found") }
            
            cell.textLabel?.text = "Logout"
            
            cell.selectionStyle = .None
            
            return cell
            
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let option = options[indexPath.row]
        
        switch option {
            
        case .logOut:
            logout()
            
        default:
            return
        }
    }
    
    // MARK: - User Interaction
    
    func logout() {
    
        SessionUD.sharedInstance.clearSession()
        
        let storyBoard : UIStoryboard = UIStoryboard(name: "LogIn", bundle:nil)
        let logInViewController = storyBoard.instantiateViewControllerWithIdentifier("LogInViewController") as! LogInViewController
        self.presentViewController(logInViewController, animated: true, completion: nil)
    }
    
    @IBAction func enableNotificationChanged(sender: AnyObject) {
        
        let enableSwitch = sender as! UISwitch
        
        SessionUD.sharedInstance.setUserIsPushNotificationEnable(enableSwitch.on)
    }
    
}

extension SettingsViewController {
    
    enum SettingsOptions{
        
        case notification
        case logOut
    }
}

class NotificationCell: UITableViewCell {
    
    @IBOutlet weak var notificationSwitch: UISwitch!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var subtitle: UILabel!
    
}