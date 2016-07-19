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
import Firebase
import FirebaseInstanceID
import FirebaseMessaging

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var objUserSession : User?

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        // PUSH Notification
        let settings: UIUserNotificationSettings = UIUserNotificationSettings(forTypes: [.Alert, .Badge, .Sound], categories: nil)
        application.registerUserNotificationSettings(settings)
        application.registerForRemoteNotifications()

        // Firebase
        FIRApp.configure()
        
        // AddObserver
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(self.tokenRefreshNotification), name: kFIRInstanceIDTokenRefreshNotification, object: nil)
        
        // start Facebook
        FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
        
        // start Twitter
        Fabric.with([Twitter.self])
        
        // UI
        self.window!.tintColor = UIColor.belatrix()
        self.window!.backgroundColor = UIColor.colorPrimary()
        
        let session_id                      : Int       = SessionUD.sharedInstance.getUserPk()
        let session_tokken                  : String    = SessionUD.sharedInstance.getUserToken()
        let session_base_profile_complete   : Bool      = SessionUD.sharedInstance.getUserBaseProfileComplete()
        
        if (session_id != -1 && session_tokken != "" && session_base_profile_complete == true) {
            let session : User = User()
            session.user_pk = session_id
            session.user_token = session_tokken
            session.user_base_profile_complete = session_base_profile_complete
            session.user_pk = SessionUD.sharedInstance.getUserPk()
            session.user_first_name = SessionUD.sharedInstance.getUserFirstName()
            session.user_last_name = SessionUD.sharedInstance.getUserLastName()
            session.user_skype_id = SessionUD.sharedInstance.getUserSkypeId()
            
            objUserSession = session
            
            let storyBoard : UIStoryboard = UIStoryboard(name: "TabBar", bundle:nil)
            let tabBarViewController = storyBoard.instantiateViewControllerWithIdentifier("CustomTabBarViewController") as! UITabBarController
            
            UITabBar.appearance().tintColor = UIColor.belatrix()
            
            self.window?.rootViewController = tabBarViewController

        }
        
        return true
    }
    
    func application(application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData) {
        print("DeviceToken: \(deviceToken.description)")

        let tokenChars = UnsafePointer<CChar>(deviceToken.bytes)
        var tokenString = ""
        
        for i in 0..<deviceToken.length {
            tokenString += String(format: "%02.2hhx", arguments: [tokenChars[i]])
        }
        
        FIRInstanceID.instanceID().setAPNSToken(deviceToken, type: FIRInstanceIDAPNSTokenType.Unknown)
        
        print("DeviceTokenFormatted:", tokenString)
    }
    
    func application(application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: NSError) {
        print("Error: \(error.localizedDescription)")
        SessionUD.sharedInstance.setUserPushToken("")
    }
    
    func application(application: UIApplication, didRegisterUserNotificationSettings notificationSettings: UIUserNotificationSettings) {
        if notificationSettings.types != .None {
            application.registerForRemoteNotifications()
        }
    }
    
    func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject],
                     fetchCompletionHandler completionHandler: (UIBackgroundFetchResult) -> Void) {
        
        let session_id                      : Int       = SessionUD.sharedInstance.getUserPk()
        let session_tokken                  : String    = SessionUD.sharedInstance.getUserToken()
        let session_base_profile_complete   : Bool      = SessionUD.sharedInstance.getUserBaseProfileComplete()
        
        if (session_id != -1 && session_tokken != "" && session_base_profile_complete == true) {
            print("userInfo: \(userInfo)")
            
            let dicPUSH = userInfo["aps"]!["alert"] as! NSDictionary
            let title = dicPUSH["title"] as! String
            let body = dicPUSH["body"] as! String
            
            let notification = UILocalNotification()
            notification.alertTitle = title
            notification.alertBody = body
            notification.alertAction = "Open"
            notification.fireDate = nil
            notification.soundName = UILocalNotificationDefaultSoundName
            notification.userInfo = ["title": title, "from": ""]
            
            UIApplication.sharedApplication().scheduleLocalNotification(notification)
        }
    }
    
    func tokenRefreshNotification(notification: NSNotification) {
        if let refreshedToken = FIRInstanceID.instanceID().token() {
            print("InstanceID token: \(refreshedToken)")
            
            SessionUD.sharedInstance.setUserPushToken(refreshedToken)
            
            connectToFcm()
        }
    }
    
    func connectToFcm() {
        FIRMessaging.messaging().connectWithCompletion { (error) in
            if (error != nil) {
                print("Unable to connect with FCM. \(error)")
            } else {
                print("Connected to FCM.")
            }
        }
    }
    
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
        FIRMessaging.messaging().disconnect()
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        application.applicationIconBadgeNumber = 0
        
        FBSDKAppEvents.activateApp()
        
        connectToFcm()
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
}