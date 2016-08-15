//
//  AppDelegate.swift
//  AllStars
//
//  Created by Kenyi Rodriguez Vergara on 5/05/16.
//  Copyright © 2016 Belatrix SF. All rights reserved.
//

import UIKit
import Fabric
import TwitterKit
//import Firebase
//import FirebaseInstanceID
//import FirebaseMessaging

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UITabBarControllerDelegate, UINavigationControllerDelegate {

    var window: UIWindow?
    var objUserSession : User?

    // MARK: Static Properties
    
    static let applicationShortcutUserInfoIconKey = "applicationShortcutUserInfoIconKey"
    
    /// Saved shortcut item used as a result of an app launch, used later when app is activated.
    var launchedShortcutItem: UIApplicationShortcutItem?
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        var tabPos = Tabs.Profile
        
//        // PUSH Notification
//        let settings: UIUserNotificationSettings = UIUserNotificationSettings(forTypes: [.Alert, .Badge, .Sound], categories: nil)
//        application.registerUserNotificationSettings(settings)
//        application.registerForRemoteNotifications()
//        
//        // Firebase
//        FIRApp.configure()
//        
//        // AddObserver
//        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(self.tokenRefreshNotification), name: kFIRInstanceIDTokenRefreshNotification, object: nil)
        
        // start Facebook
        FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
        
        // start Twitter
        Fabric.with([Twitter.self])
        
        // If a shortcut was launched, display its information and take the appropriate action
        if let shortcutItem = launchOptions?[UIApplicationLaunchOptionsShortcutItemKey] as? UIApplicationShortcutItem {
            
            launchedShortcutItem = shortcutItem
        }
        
        // Opened with notification
        if let options = launchOptions,
            let _ = options[UIApplicationLaunchOptionsRemoteNotificationKey] {
            
            tabPos = Tabs.Activities
        }
        
        // UI
        self.window!.tintColor = .belatrix()
        self.window!.backgroundColor = .colorPrimary()
        UIApplication.sharedApplication().statusBarStyle = .LightContent

        let session_id                      : Int       = SessionUD.sharedInstance.getUserPk()
        let session_tokken                  : String    = SessionUD.sharedInstance.getUserToken()
        let session_base_profile_complete   : Bool      = SessionUD.sharedInstance.getUserBaseProfileComplete()
        let session_reset_pwd_needed        : Bool      = SessionUD.sharedInstance.getUserNeedsResetPwd()
        
        if (session_id != -1 && session_tokken != "" && session_base_profile_complete == true && session_reset_pwd_needed == false) {
            let session : User = User()
            session.user_pk = session_id
            session.user_token = session_tokken
            session.user_base_profile_complete = session_base_profile_complete
            session.user_pk = SessionUD.sharedInstance.getUserPk()
            session.user_first_name = SessionUD.sharedInstance.getUserFirstName()
            session.user_last_name = SessionUD.sharedInstance.getUserLastName()
            session.user_skype_id = SessionUD.sharedInstance.getUserSkypeId()
            
            objUserSession = session
            
            self.addShortcutItems()
            
            self.login(tabPos)

        }
        return true
    }
    
//    // MARK: - UIUserNotification
//    func application(application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData) {
//        print("DeviceToken: \(deviceToken.description)")
//
//        let tokenChars = UnsafePointer<CChar>(deviceToken.bytes)
//        var tokenString = ""
//        
//        for i in 0..<deviceToken.length {
//            tokenString += String(format: "%02.2hhx", arguments: [tokenChars[i]])
//        }
//        
//        FIRInstanceID.instanceID().setAPNSToken(deviceToken, type: FIRInstanceIDAPNSTokenType.Unknown)
//        
//        print("DeviceTokenFormatted:", tokenString)
//    }
//    
//    func application(application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: NSError) {
//        print("Error: \(error.localizedDescription)")
//        SessionUD.sharedInstance.setUserPushToken("")
//    }
//    
//    func application(application: UIApplication, didRegisterUserNotificationSettings notificationSettings: UIUserNotificationSettings) {
//        if notificationSettings.types != .None {
//            application.registerForRemoteNotifications()
//        }
//    }
//    
//    func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject],
//                     fetchCompletionHandler completionHandler: (UIBackgroundFetchResult) -> Void) {
//        
//        let session_id                      : Int       = SessionUD.sharedInstance.getUserPk()
//        let session_tokken                  : String    = SessionUD.sharedInstance.getUserToken()
//        let session_base_profile_complete   : Bool      = SessionUD.sharedInstance.getUserBaseProfileComplete()
//        
//        if (session_id != -1 && session_tokken != "" && session_base_profile_complete == true) {
//            print("userInfo: \(userInfo)")
//            
//            let dicPUSH = userInfo["aps"]!["alert"] as! NSDictionary
//            let title = dicPUSH["title"] as! String
//            let body = dicPUSH["body"] as! String
//            
//            let notification = UILocalNotification()
//            notification.alertTitle = title
//            notification.alertBody = body
//            notification.alertAction = "Open"
//            notification.fireDate = nil
//            notification.soundName = UILocalNotificationDefaultSoundName
//            notification.userInfo = ["title": title, "from": ""]
//            
//            UIApplication.sharedApplication().scheduleLocalNotification(notification)
//            
//            if ( application.applicationState != .Active ) {
//                // app was already in the foreground
//                guard let tabbarcontroller = self.window?.rootViewController as? UITabBarController
//                    else { return }
//                
//                tabbarcontroller.selectedViewController = tabbarcontroller.viewControllers![Tabs.Activities.rawValue]
//            }
//        }
//    }
//    
//    func tokenRefreshNotification(notification: NSNotification) {
//        if let refreshedToken = FIRInstanceID.instanceID().token() {
//            print("InstanceID token: \(refreshedToken)")
//            
//            SessionUD.sharedInstance.setUserPushToken(refreshedToken)
//            
//            connectToFcm()
//        }
//    }
//    
//    func connectToFcm() {
//        FIRMessaging.messaging().connectWithCompletion { (error) in
//            if (error != nil) {
//                print("Unable to connect with FCM. \(error)")
//            } else {
//                print("Connected to FCM.")
//            }
//        }
//    }
//    
    // MARK: - Lifecycle
    func application(application: UIApplication, openURL url: NSURL, sourceApplication: String?, annotation: AnyObject) -> Bool {
        return FBSDKApplicationDelegate.sharedInstance().application( application, openURL: url, sourceApplication: sourceApplication, annotation: annotation)
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
//        FIRMessaging.messaging().disconnect()
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        application.applicationIconBadgeNumber = 0
        
        FBSDKAppEvents.activateApp()
        
//        connectToFcm()
        
        FBSDKLoginManager().logOut()
        
        NSNotificationCenter.defaultCenter().postNotificationName("applicationDidBecomeActive", object: nil)
        
        guard let shortcut = launchedShortcutItem else { return }
        
        handleShortCutItem(shortcut)
        
        launchedShortcutItem = nil
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    // MARK: - UITabBarControllerDelegate
    func tabBarController(tabBarController: UITabBarController, didEndCustomizingViewControllers viewControllers: [UIViewController], changed: Bool) {
        
        guard changed
            else { return }
        
        var tabOrderArray = [NSNumber]()
        
        for vc in viewControllers {
            
            tabOrderArray.append(NSNumber(integer: vc.tabBarItem.tag))
        }

        NSUserDefaults.standardUserDefaults().setObject(tabOrderArray, forKey:"tabBarOrder")
        NSUserDefaults.standardUserDefaults().synchronize()        
        
    }
    
    // MARK: - UINavigationControllerDelegate
    func navigationController(navigationController: UINavigationController, willShowViewController viewController: UIViewController, animated: Bool) {
        
        let moreNavBar = navigationController.navigationBar
        
        moreNavBar.titleTextAttributes = [NSForegroundColorAttributeName : UIColor.whiteColor(), NSFontAttributeName : UIFont(name: "Helvetica Neue", size: 19.0)! ]
        moreNavBar.tintColor = .whiteColor()
        moreNavBar.barTintColor = UIColor.colorPrimary()
        
        moreNavBar.topItem?.rightBarButtonItem = nil
        
        if let rootViewController = navigationController.topViewController?.view as? UITableView{
            
            rootViewController.separatorStyle = .None
        }
    }
    
    // MARK - Public methods
    
    internal func logOut() {
        
        let storyBoard : UIStoryboard = UIStoryboard(name: "LogIn", bundle:nil)
        let loginVC = storyBoard.instantiateViewControllerWithIdentifier("LogInViewController") as! LogInViewController
        
        self.window?.rootViewController = loginVC
        
        SessionUD.sharedInstance.clearSession()
        
        let application = UIApplication.sharedApplication()
        application.shortcutItems = []
    }
    
    internal func login(selectedTab: Tabs = Tabs.Profile) {
        
        let storyBoard : UIStoryboard = UIStoryboard(name: "TabBar", bundle:nil)
        let tabBarViewController = storyBoard.instantiateViewControllerWithIdentifier("CustomTabBarViewController") as! UITabBarController
        
        UITabBar.appearance().tintColor = UIColor.belatrix()
        
        tabBarViewController.delegate = self
        tabBarViewController.moreNavigationController.delegate = self
        
        tabBarViewController.selectedViewController = tabBarViewController.viewControllers![selectedTab.rawValue]
        
        // Verify TabbarController Order
        let tabBarOrder = NSUserDefaults.standardUserDefaults().arrayForKey("tabBarOrder")
        
        if tabBarOrder != nil {
            
            let defaultViewControllers = tabBarViewController.viewControllers
            var sortedViewControllers = [UIViewController]()
            
            for sortNumber in tabBarOrder! {
                
                sortedViewControllers.append(defaultViewControllers![sortNumber .integerValue])
            }
            
            tabBarViewController.viewControllers = sortedViewControllers
        }
        
        self.window?.rootViewController = tabBarViewController
    }
    
    // MARK: - Shortcut methods
    internal func addShortcutItems() {
        
        let application = UIApplication.sharedApplication()
        
        // Install initial versions of our two extra dynamic shortcuts.
        if let shortcutItems = application.shortcutItems where shortcutItems.isEmpty {
            
            // Construct the items.
            
            let shortcut3 = UIMutableApplicationShortcutItem(type: ShortcutType.Activities.rawValue, localizedTitle: "activities".localized, localizedSubtitle: "activities_sub".localized,
                                                             icon: UIApplicationShortcutIcon(templateImageName: "iconTabBar_activity"),
                                                             userInfo: nil
            )
            
            let shortcut4 = UIMutableApplicationShortcutItem(type: ShortcutType.Contacts.rawValue, localizedTitle: "contacts".localized,
                                                             localizedSubtitle: "contacts_sub".localized,
                                                             icon: UIApplicationShortcutIcon(templateImageName: "iconTabBar_2@3x.png"),
                                                             userInfo: nil
            )
            
            // Update the application providing the initial 'dynamic' shortcut items.
            application.shortcutItems = [shortcut3, shortcut4]
        }
    }
    
    func handleShortCutItem(shortcutItem: UIApplicationShortcutItem) -> Bool {
        
        guard let tabBarController = self.window?.rootViewController as? UITabBarController
            else { return false }
        
        switch shortcutItem.type {
        case ShortcutType.Activities.rawValue:
            
            tabBarController.selectedViewController = tabBarController.viewControllers![Tabs.Activities.rawValue]
            
        case ShortcutType.Contacts.rawValue:
            tabBarController.selectedViewController = tabBarController.viewControllers![Tabs.Contacts.rawValue]
            
        default:
            fatalError("Unhandled shortcut")
        }
        
        return true
    }
    
    /*
     Called when the user activates your application by selecting a shortcut on the home screen, except when
     application(_:,willFinishLaunchingWithOptions:) or application(_:didFinishLaunchingWithOptions) returns `false`.
     You should handle the shortcut in those callbacks and return `false` if possible. In that case, this
     callback is used if your application is already launched in the background.
     */
    func application(application: UIApplication, performActionForShortcutItem shortcutItem: UIApplicationShortcutItem, completionHandler: Bool -> Void) {
        let handledShortCutItem = handleShortCutItem(shortcutItem)
        
        completionHandler(handledShortCutItem)
    }
}

extension AppDelegate {
    
    enum Tabs: Int {
        case Profile = 0
        case Ranking
        case Contacts
        case Tags
        case Activities
        case Events
        case About
        case Settings
    }
    
    enum ShortcutType: String {
        
        case Activities
        case Contacts
    }
}
