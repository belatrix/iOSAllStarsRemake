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
    @IBOutlet weak var backButton: UIButton!
    
    
    lazy var options: [SettingsOptions] = {
        
        let session_id                      : Int       = SessionUD.sharedInstance.getUserPk()
        let session_tokken                  : String    = SessionUD.sharedInstance.getUserToken()
        let session_base_profile_complete   : Bool      = SessionUD.sharedInstance.getUserBaseProfileComplete()
        
        if (session_id != -1 && session_tokken != "" && session_base_profile_complete == true) {
            
            // Registered User
            return [SettingsOptions.notification, SettingsOptions.logOut]
            
        } else {
            // Guest User
            return [SettingsOptions.logOut]
        }
    }()
    
    // MARK: - Initialization
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 60
        
        if let nav = self.navigationController where nav.viewControllers.count > 1 {
            
            backButton.hidden = false
        } else {
            
            backButton.hidden = true
        }
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector:#selector(SettingsViewController.applicationDidBecomeActiveNotification(_:)) , name: "applicationDidBecomeActive", object: nil)
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
    
    deinit {
        
        NSNotificationCenter.defaultCenter().removeObserver(self, name: "applicationDidBecomeActive", object: nil)
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
            
            var titleText = "Turn on push Notifications"
            
            if self.hasPushEnabled() {
                titleText = "Turn off push Notifications"
            }
            
            cell.title.text = titleText
            
            return cell
        
        case .logOut:
            
            guard let cell = tableView.dequeueReusableCellWithIdentifier("logoutCell") as? LogoutCell
                else { fatalError("Settings - No logout cell found") }
            
            cell.title.text = "logout_cell_title".localized
            
            return cell
            
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        let option = options[indexPath.row]
        
        switch option {
            
        case .notification:
            
            let alert = UIAlertController(title: "app_name".localized, message: "Go to Settings -> Belatrix Connect -> Notifications", preferredStyle: .Alert)
            
            let openSettingsAction = UIAlertAction(title: "Settings", style: .Default, handler: { (alert) in
                
                let settingsUrl = NSURL(string: UIApplicationOpenSettingsURLString)
                if let url = settingsUrl where UIApplication.sharedApplication().canOpenURL(url) {
                    UIApplication.sharedApplication().openURL(url)
                }
            })
            
            let cancelAction = UIAlertAction(title: "cancel".localized, style: .Default, handler: nil)
            
            alert.addAction(openSettingsAction)
            alert.addAction(cancelAction)
            
            self.presentViewController(alert, animated: true, completion: nil)
            
        case .logOut:
            
            let logoutCell = tableView.cellForRowAtIndexPath(indexPath) as! LogoutCell
            
            logout(logoutCell)
        
        }
    }
    
    // MARK: - User Interaction
    
    @IBAction func goBack(sender: AnyObject) {
        
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    func logout(logoutCell: LogoutCell!) {
        
        let alert: UIAlertController = UIAlertController(title: "logout_warning".localized, message: nil, preferredStyle: .Alert)
        
        let logoutAction = UIAlertAction(title: "ok".localized, style: .Destructive,
                                         handler: {(alert: UIAlertAction) in
                                            
                                            self.view.userInteractionEnabled = false
                                            
                                            self.logoutAccordingToUserType(logoutCell)
                                        })
        
        let cancelAction = UIAlertAction(title: "cancel".localized, style: .Cancel,
                                         handler: nil)
        
        alert.addAction(logoutAction)
        alert.addAction(cancelAction)
        
        self.presentViewController(alert, animated: true, completion: {})
        
    }
    
    func logoutAccordingToUserType(logoutCell: LogoutCell!) {
        
        let session_id                      : Int       = SessionUD.sharedInstance.getUserPk()
        let session_tokken                  : String    = SessionUD.sharedInstance.getUserToken()
        let session_base_profile_complete   : Bool      = SessionUD.sharedInstance.getUserBaseProfileComplete()
        
        if (session_id != -1 && session_tokken != "" && session_base_profile_complete == true) {
            
            logoutCell.actLogout.startAnimating()
            
            LogInBC.doLogout { (successful) in
                
                self.view.userInteractionEnabled = true
                logoutCell.actLogout.stopAnimating()
                
                if successful {
                    
                    self.showLoginViewController()
                }
            }
            
        } else {
            
            showLoginViewController()
        }
    }
    
    func showLoginViewController() {
        
        SessionUD.sharedInstance.clearSession()
        
        let storyBoard : UIStoryboard = UIStoryboard(name: "LogIn", bundle:nil)
        let logInViewController = storyBoard.instantiateViewControllerWithIdentifier("LogInViewController") as! LogInViewController
        self.presentViewController(logInViewController, animated: true, completion: nil)
    }
    
    // MARK: - Push Notification handler
    func hasPushEnabled() -> Bool {
        //ios 8+
        if UIApplication.sharedApplication().respondsToSelector(#selector(UIApplication.currentUserNotificationSettings)) == true {
            let settings = UIApplication.sharedApplication().currentUserNotificationSettings()
            if (settings?.types.contains(.Alert) == true){
                return true
            }
            else {
                return false
            }
        } else {
            return UIApplication.sharedApplication().isRegisteredForRemoteNotifications()
        }
    }
    
    // MARK: - Notification handler
    func applicationDidBecomeActiveNotification(notification: NSNotification?){
        
        self.tableView.reloadData()
    }
}

extension SettingsViewController {
    
    enum SettingsOptions{
        
        case notification
        case logOut
    }
}

class NotificationCell: UITableViewCell {
    
    @IBOutlet weak var title: UILabel!
    
}

class LogoutCell: UITableViewCell {
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var actLogout: UIActivityIndicatorView!
}