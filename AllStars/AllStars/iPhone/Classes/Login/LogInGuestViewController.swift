//
//  LogInGuestViewController.swift
//  AllStars
//
//  Created by Flavio Franco Tunqui on 7/1/16.
//  Copyright © 2016 Belatrix SF. All rights reserved.
//

import UIKit
import TwitterKit

class LogInGuestViewController: UIViewController, FBSDKLoginButtonDelegate {

    @IBOutlet weak var imgLogInGuest        : UIImageView!
    @IBOutlet weak var actFacebook          : UIActivityIndicatorView!
    @IBOutlet weak var actTwitter           : UIActivityIndicatorView!
    @IBOutlet weak var btnLogInFacebook     : FBSDKLoginButton!
    @IBOutlet weak var btnLogInTwitter      : TWTRLogInButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set FBSDKLoginButton
        btnLogInFacebook.readPermissions = ["public_profile", "email", "user_friends"]
        btnLogInFacebook.delegate = self
        
        setViews()
    }
    
    // MARK: - UI
    func setViews() {
        let image = UIImage(named: "users")
        imgLogInGuest.image = image?.imageWithRenderingMode(.AlwaysTemplate)
        imgLogInGuest.tintColor = UIColor.colorPrimary()
    }
    
    func lockScreenFB() {
        self.view.userInteractionEnabled = false
        self.actFacebook.startAnimating()
    }
    
    func unlockScreenFB() {
        self.view.userInteractionEnabled = true
        self.actFacebook.stopAnimating()
    }
    
    func lockScreenTW() {
        self.view.userInteractionEnabled = false
        self.actTwitter.startAnimating()
    }
    
    func unlockScreenTW() {
        self.view.userInteractionEnabled = true
        self.actTwitter.stopAnimating()
    }
    
    // MARK: - IBActions
    @IBAction func btnTwitterTUI(sender: TWTRLogInButton) {
        lockScreenTW()
        
        Twitter.sharedInstance().logInWithMethods([.WebBased]) { session, error in
            
            if (session != nil) {
                let userID = session!.userID
                print("userID: \(userID)");
                let username = session!.userName
                print("userName: \(username)");
                
                let client = TWTRAPIClient.clientWithCurrentUser()
                let request = client.URLRequestWithMethod("GET",
                                                          URL: "https://api.twitter.com/1.1/account/verify_credentials.json",
                                                          parameters: ["include_email": "true", "skip_status": "true"],
                                                          error: nil)
                
                client.sendTwitterRequest(request) { response, data, connectionError in
                    if (connectionError == nil) {
                        do{
                            let parsedResult = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.AllowFragments)
                            //                            print("parsedResult: \(parsedResult)")
                            let email : String = parsedResult.valueForKey("email") as! String
                            let name : String = parsedResult.valueForKey("name") as! String
                            
                            print("email: \(email)")
                            print("name: \(name)")
                            
//                            OSPUserAlerts.showSimpleAlert("app_name".localized, withMessage: "\(username)\n\(name)\n\(email)", withAcceptButton: "ok".localized)
                            
                            self.createParticipant(name, email: email, socialNetworkType: 2, socialNetworkId: userID)
                        } catch let error1 as NSError {
                            print("error: \(error1.localizedDescription)");
                            
                            self.unlockScreenTW()
                        }
                    } else {
                        print("error: cancelled");
                        
                        self.unlockScreenTW()
                    }
                }
            } else {
                print("error: \(error!.localizedDescription)");
                
                self.unlockScreenTW()
            }
        }
    }
    
    @IBAction func btnBackTUI(sender: UIButton) {
        self.view.endEditing(true)
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func tapCloseKeyboard(sender: AnyObject) {
        self.view.endEditing(true)
    }
    
    // MARK: - FBSDKLoginButton delegates
    func loginButton(loginButton: FBSDKLoginButton!, didCompleteWithResult result: FBSDKLoginManagerLoginResult!, error: NSError!) {
        lockScreenFB()
        
        print("User Logged In")
        
        if ((error) != nil) {
            print("Error: \(error.localizedDescription)")
            self.unlockScreenFB()
        } else if result.isCancelled {
            print("Cancelled")
            self.unlockScreenFB()
        } else {
            if result.grantedPermissions.contains("email") {
                returnUserData()
            }
        }
    }
    
    func loginButtonDidLogOut(loginButton: FBSDKLoginButton!) {
        print("User Logged Out")
    }
    
    func returnUserData() {
        let graphRequest : FBSDKGraphRequest = FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "id, name, first_name, last_name, picture.type(large), email"])
        graphRequest.startWithCompletionHandler({ (connection, result, error) -> Void in
            
            if ((error) != nil) {
                self.unlockScreenFB()
                
                print("Error: \(error)")
            } else {
                print("fetched user: \(result)")

                let idUser : String = result.valueForKey("id") as! String
                print("User Id is: \(idUser)")
                let email : String = result.valueForKey("email") as! String
                print("User Email is: \(email)")
                let firstName : String = result.valueForKey("first_name") as! String
                print("User Name is: \(firstName)")
                let lastName : String = result.valueForKey("last_name") as! String
                print("User LastName is: \(lastName)")
                
//                OSPUserAlerts.showSimpleAlert("app_name".localized, withMessage: "\(firstName)\n\(lastName)\n\(email)", withAcceptButton: "ok".localized)
                
                self.createParticipant("\(firstName) \(lastName)", email: email, socialNetworkType: 1, socialNetworkId: idUser)
            }
        })
    }
    
    // MARK: - WebServices
    func createParticipant(fullName : String?, email : String?, socialNetworkType : Int, socialNetworkId : String) -> Void {
//        lockScreen()
        
        LogInBC.createParticipant(fullName, email: email, socialNetworkType: socialNetworkType, socialNetworkId: socialNetworkId) { (userGuest, fieldsCompleted) in
            
            self.unlockScreenFB()
            self.unlockScreenTW()
            
            if (fieldsCompleted) {
                let sb = UIStoryboard(name: "Event", bundle: nil)
                let eventsViewController = sb.instantiateViewControllerWithIdentifier("EventsViewController") as! EventsViewController
                self.presentViewController(eventsViewController, animated: true, completion: nil)
            } else {
                print("no complete")
                let sb = UIStoryboard(name: "LogIn", bundle: nil)
                let logInGuestEmailViewController = sb.instantiateViewControllerWithIdentifier("LogInGuestEmailViewController") as! LogInGuestEmailViewController
                logInGuestEmailViewController.fullName = fullName!
                logInGuestEmailViewController.socialNetworkType = socialNetworkType
                logInGuestEmailViewController.socialNetworkId = socialNetworkId
                self.presentViewController(logInGuestEmailViewController, animated: true, completion: nil)
            }
        }
    }
}