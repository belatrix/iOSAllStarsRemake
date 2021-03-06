//
//  LoginViewController.swift
//  AllStars
//
//  Created by Kenyi Rodriguez Vergara on 5/05/16.
//  Copyright © 2016 Belatrix SF. All rights reserved.
//

import UIKit

class LogInViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var edtUser              : UITextField!
    @IBOutlet weak var edtPassword          : UITextField!
    @IBOutlet weak var actLogin             : UIActivityIndicatorView!
    @IBOutlet weak var constraintCenterForm : NSLayoutConstraint!
    @IBOutlet weak var viewFormLogin        : UIView!
    @IBOutlet weak var btnLogin             : UIButton!
    @IBOutlet weak var btnLogInGuest        : UIButton!
    @IBOutlet weak var btnNewUser           : UIButton!
    @IBOutlet weak var btnforgotPassword    : UIButton!
    @IBOutlet weak var lblTitleApp          : UILabel!
    @IBOutlet weak var imgLogoBelatrix      : UIImageView!
    @IBOutlet weak var viewUserName         : UIView!
    @IBOutlet weak var viewPassword         : UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setViews()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(LogInViewController.keyboardWillShown(_:)), name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(LogInViewController.keyboardWillBeHidden(_:)), name: UIKeyboardWillHideNotification, object: nil)
        
    }
    
    deinit{
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        UIApplication.sharedApplication().statusBarStyle = UIStatusBarStyle.Default        
    }
    
    // MARK: - UI
    func setViews() {
        lblTitleApp.textColor = UIColor.belatrix()
        
        btnLogin.backgroundColor = UIColor.colorPrimary()
        btnLogInGuest.backgroundColor = UIColor.colorAccent()
        btnNewUser.setTitleColor(UIColor.colorPrimaryDark(), forState: .Normal)
        btnforgotPassword.setTitleColor(UIColor.colorPrimaryDark(), forState: .Normal)
        
        let image = UIImage(named: "logo")
        imgLogoBelatrix.image = image?.imageWithRenderingMode(.AlwaysTemplate)
        imgLogoBelatrix.tintColor = UIColor.belatrix()
        
        viewUserName.backgroundColor = UIColor.colorPrimary()
        viewPassword.backgroundColor = UIColor.colorPrimary()
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
        createUserAndLogIn()
    }
    
    @IBAction func tapCloseKeyboard(sender: AnyObject) {
        self.view.endEditing(true)
    }
    
    @IBAction func btnNewUserTUI(sender: UIButton) {
        let sb = UIStoryboard(name: "SignUp", bundle: nil)
        let signUpViewController = sb.instantiateViewControllerWithIdentifier("SignUpViewController") as! SignUpViewController
        self.presentViewController(signUpViewController, animated: true, completion: nil)
    }
    
    @IBAction func btnLogInGuestTUI(sender: UIButton) {
        let sb = UIStoryboard(name: "LogIn", bundle: nil)
        let logInGuestViewController = sb.instantiateViewControllerWithIdentifier("LogInGuestViewController") as! LogInGuestViewController
        self.presentViewController(logInGuestViewController, animated: true, completion: nil)
    }
    
    func createUserAndLogIn() {
        let objUser = User()
        objUser.user_username = self.edtUser.text
        objUser.user_password = self.edtPassword.text
        
        self.logInWithUser(objUser)
    }
    
    // MARK: - WebServices
    func logInWithUser(objUser : User) -> Void {
        
        lockScreen()
        
        LogInBC.logInWithUser(objUser, withController: self) { (userSession : UserSession?, accountState : String?) in
            
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
        
        LogInBC.getUserSessionInformation { (user : User?) in
            
            self.unlockScreen()
            
            if (user != nil) {

                let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
                
                appDelegate.login()
                
                appDelegate.addShortcutItems()
            }
        }
    }
    
    // MARK: - UITextFieldDelegate
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        
        if self.edtUser == textField {
            self.edtPassword.becomeFirstResponder()
        }else{
            createUserAndLogIn()
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
}