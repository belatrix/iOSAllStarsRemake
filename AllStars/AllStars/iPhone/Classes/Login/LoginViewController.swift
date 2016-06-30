//
//  LoginViewController.swift
//  AllStars
//
//  Created by Kenyi Rodriguez Vergara on 5/05/16.
//  Copyright © 2016 Belatrix SF. All rights reserved.
//

import UIKit
import TwitterKit

class LoginViewController: UIViewController, UITextFieldDelegate, FBSDKLoginButtonDelegate {
    
    @IBOutlet weak var edtUser              : UITextField!
    @IBOutlet weak var edtPassword          : UITextField!
    @IBOutlet weak var actLogin             : UIActivityIndicatorView!
    @IBOutlet weak var constraintCenterForm : NSLayoutConstraint!
    @IBOutlet weak var viewFormLogin        : UIView!
    @IBOutlet weak var btnLogin             : UIButton!
    @IBOutlet weak var btnNewUser           : UIButton!
    @IBOutlet weak var lblTitleApp          : UILabel!
    @IBOutlet weak var imgLogoBelatrix      : UIImageView!
    @IBOutlet weak var viewUserName         : UIView!
    @IBOutlet weak var viewPassword         : UIView!
    @IBOutlet weak var btnLogInFacebook     : FBSDKLoginButton!
    @IBOutlet weak var btnLogInTwitter      : TWTRLogInButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setViews()
        
        // Set FBSDKLoginButton
        btnLogInFacebook.readPermissions = ["public_profile", "email", "user_friends"]
        btnLogInFacebook.delegate = self
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(LoginViewController.keyboardWillShown(_:)), name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(LoginViewController.keyboardWillBeHidden(_:)), name: UIKeyboardWillHideNotification, object: nil)
    }
    
    deinit{
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    // MARK: - UI
    func setViews() {
        lblTitleApp.textColor = UIColor.belatrix()
        
        btnLogin.backgroundColor = UIColor.colorPrimary()
        btnNewUser.setTitleColor(UIColor.colorPrimaryDark(), forState: .Normal)
        
        let image = UIImage(named: "logo")
        imgLogoBelatrix.image = image?.imageWithRenderingMode(.AlwaysTemplate)
        imgLogoBelatrix.tintColor = UIColor.belatrix()
        
        viewUserName.backgroundColor = UIColor.colorPrimary()
        viewPassword.backgroundColor = UIColor.colorPrimary()
        
//        btnLogInTwitter = TWTRLogInButton { (session, error) in
//            if let unwrappedSession = session {
//                let alert = UIAlertController(title: "Logged In",
//                    message: "User \(unwrappedSession.userName) has logged in",
//                    preferredStyle: UIAlertControllerStyle.Alert
//                )
//                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
//                self.presentViewController(alert, animated: true, completion: nil)
//            } else {
//                NSLog("Login error: %@", error!.localizedDescription);
//            }
//        }
        
//        btnLogInTwitter.logInCompletion = {(session, error) -> Void in
//            if let unwrappedSession = session {
//                let alert = UIAlertController(title: "Logged In",
//                                              message: "UserID \(unwrappedSession.userID)\nUserName \(unwrappedSession.userName)",
//                                              preferredStyle: UIAlertControllerStyle.Alert
//                )
//                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
//                self.presentViewController(alert, animated: true, completion: nil)
//            } else {
//                NSLog("Login error: %@", error!.localizedDescription);
//            }
//        }
    }
    
    func lockScreen() {
        self.view.userInteractionEnabled = false
        self.actLogin.startAnimating()
    }
    
    func unlockScreen() {
        self.view.userInteractionEnabled = true
        self.actLogin.stopAnimating()
    }
    
    // MARK: - IBActions
    @IBAction func btnLoginTUI(sender: UIButton) {
        createUserAndLogin()
    }
    
    @IBAction func tapCloseKeyboard(sender: AnyObject) {
        self.view.endEditing(true)
    }
    
    @IBAction func btnNewUserTUI(sender: UIButton) {
        let sb = UIStoryboard(name: "SignUp", bundle: nil)
        let signUpViewController = sb.instantiateViewControllerWithIdentifier("SignUpViewController") as! SignUpViewController
        self.presentViewController(signUpViewController, animated: true, completion: nil)
    }
    
    func createUserAndLogin() {
        let objUser = User()
        objUser.user_username = self.edtUser.text
        objUser.user_password = self.edtPassword.text
        
        self.loginWithUser(objUser)
    }
    
    // MARK: - WebServices
    func loginWithUser(objUser : User) -> Void {
        
        lockScreen()
        
        LoginBC.loginWithUser(objUser, withController: self) { (userSession : UserSession?, accountState : String?) in
            
            self.unlockScreen()
            
            if (userSession != nil) {
                if (accountState == Constants.PASSWORD_RESET_INCOMPLETE) {
                    let resetPasswordViewController = self.storyboard!.instantiateViewControllerWithIdentifier("ResetPasswordViewController") as! ResetPasswordViewController
                    resetPasswordViewController.userSession = userSession
                    self.presentViewController(resetPasswordViewController, animated: true, completion: nil)
                } else if (accountState == Constants.PROFILE_INCOMPLETE) {
                    let userTemp = User()
                    userTemp.user_pk = userSession!.session_user_id!
                    userTemp.user_base_profile_complete = userSession!.session_base_profile_complete!
                    
                    let sb = UIStoryboard(name: "Profile", bundle: nil)
                    let editProfileViewController = sb.instantiateViewControllerWithIdentifier("EditProfileViewController") as! EditProfileViewController
                    editProfileViewController.objUser = userTemp
                    editProfileViewController.isNewUser = true
                    self.presentViewController(editProfileViewController, animated: true, completion: nil)
                } else if (accountState == Constants.PROFILE_COMPLETE) {
                    self.getInfoCurrentUser()
                }
            }
        }
    }
    
    func getInfoCurrentUser() -> Void {
        
        lockScreen()
        
        LoginBC.getUserSessionInformation { (user : User?) in
            
            self.unlockScreen()
            
            if (user != nil) {
                let storyBoard : UIStoryboard = UIStoryboard(name: "TabBar", bundle:nil)
                let customTabBarViewController = storyBoard.instantiateViewControllerWithIdentifier("CustomTabBarViewController") as! CustomTabBarViewController
                let nav : UINavigationController = UINavigationController.init(rootViewController: customTabBarViewController)
                nav.navigationBarHidden = true
                self.presentViewController(nav, animated: true, completion: nil)
            }
        }
    }
    
    // MARK: - UITextFieldDelegate
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        
        if self.edtUser == textField {
            self.edtPassword.becomeFirstResponder()
        }else{
            createUserAndLogin()
        }
        
        return true
    }
    
    // MARK: - Keyboard Notification
    func keyboardWillShown(notification : NSNotification) {
        
        let info : NSDictionary = notification.userInfo!
        let kbSize : CGSize = (info.objectForKey(UIKeyboardFrameBeginUserInfoKey)?.CGRectValue().size)!
        let durationkeyboardAnimation = info.objectForKey(UIKeyboardAnimationDurationUserInfoKey)?.doubleValue
        
        UIView.animateWithDuration(durationkeyboardAnimation!) {
            
            let heightScreen = Int(UIScreen.mainScreen().bounds.size.height / 2)
            let heightFormLogin = Int(self.viewFormLogin.frame.size.height / 2)
            let delta = heightScreen - (Int(kbSize.height) + heightFormLogin)
            
            if delta < 0 {
                self.constraintCenterForm.constant = CGFloat(delta)
                self.view.layoutIfNeeded()
            }
        }
    }
    
    func keyboardWillBeHidden(notification : NSNotification) {
        
        let info : NSDictionary = notification.userInfo!
        let durationkeyboardAnimation = info.objectForKey(UIKeyboardAnimationDurationUserInfoKey)?.doubleValue
        
        UIView.animateWithDuration(durationkeyboardAnimation!) {
            
            self.constraintCenterForm.constant = 0
            self.view.layoutIfNeeded()
        }
    }
    
    // MARK: - TWTRLoginButton delegates
    @IBAction func btnTwitterTUI(sender: TWTRLogInButton) {
        Twitter.sharedInstance().logInWithMethods([.WebBased]) { session, error in
            
            if (session != nil) {
                print("userID: \(session!.userID)");
                print("userName: \(session!.userName)");
                
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
                            let name = parsedResult["name"]
                            let email = parsedResult["email"]
                            print("name: \(name)")
                            print("email: \(email)")
                        } catch let error1 as NSError {
                            print("error: \(error1.localizedDescription)");
                        }
                    }
                }
            } else {
                print("error: \(error!.localizedDescription)");
            }
        }
    }
    
    // MARK: - FBSDKLoginButton delegates
    func loginButton(loginButton: FBSDKLoginButton!, didCompleteWithResult result: FBSDKLoginManagerLoginResult!, error: NSError!) {
        print("User Logged In")
        
        if ((error) != nil) {
            // Process error
            print("Error: \(error)")
        } else if result.isCancelled {
            // Handle cancellations
            print("Cancelled")
        } else {
            if result.grantedPermissions.contains("email") {
                // Do work
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
                print("Error: \(error)")
            } else {
                print("fetched user: \(result)")
                let names : String = result.valueForKey("first_name") as! String
                print("User Name is: \(names)")
                let lastname : String = result.valueForKey("last_name") as! String
                print("User LastName is: \(lastname)")
                let email : String = result.valueForKey("email") as! String
                print("User Email is: \(email)")
                
                // WS
//                self.signUp(email, names: names, lastname: lastname, password: email)
            }
        })
    }
}