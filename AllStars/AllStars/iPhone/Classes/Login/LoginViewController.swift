//
//  LoginViewController.swift
//  AllStars
//
//  Created by Kenyi Rodriguez Vergara on 5/05/16.
//  Copyright © 2016 Belatrix SF. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var txtUser              : UITextField!
    @IBOutlet weak var txtPassword          : UITextField!
    @IBOutlet weak var activityEnter        : UIActivityIndicatorView!
    @IBOutlet weak var constraintCenterForm : NSLayoutConstraint!
    @IBOutlet weak var viewFormLogin        : UIView!
    
    //MARK: - UITextFieldDelegate
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        
        if self.txtUser == textField {
            self.txtPassword.becomeFirstResponder()
        }else{
            self.clickBtnEnterUser(nil)
        }
        
        return true
    }
    
    //MARK: - WebServices
    func loginWithUser(objUser : User) -> Void {
        
        self.view.userInteractionEnabled = false
        self.activityEnter.startAnimating()
        
        LoginBC.loginWithUser(objUser, withController: self) { (userSession : UserSession?, accountState : String?) in
            
            self.view.userInteractionEnabled = true
            self.activityEnter.stopAnimating()
            
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
    
    func getInfoCurrentUser() -> Void {
        
        self.view.userInteractionEnabled = false
        self.activityEnter.startAnimating()
        
        LoginBC.getUserSessionInfoConCompletion { (user : User?) in
         
            self.view.userInteractionEnabled = true
            self.activityEnter.stopAnimating()
            
            if user != nil {
//                self.dismissViewControllerAnimated(true, completion: nil)
                let storyBoard : UIStoryboard = UIStoryboard(name: "TabBar", bundle:nil)
                let customTabBarViewController = storyBoard.instantiateViewControllerWithIdentifier("CustomTabBarViewController") as! CustomTabBarViewController
                let nav : UINavigationController = UINavigationController.init(rootViewController: customTabBarViewController)
                nav.navigationBarHidden = true
                self.presentViewController(nav, animated: true, completion: nil)
            }
        }
    }
    
    //MARK: - IBActions
    @IBAction func clickBtnEnterUser(sender: AnyObject?) {
        
        let objUser = User()
        objUser.user_username = self.txtUser.text
        objUser.user_password = self.txtPassword.text
        
        self.loginWithUser(objUser)
    }
    
    @IBAction func tapCloseKeyboard(sender: AnyObject) {
        
        self.view.endEditing(true)
    }
    
    @IBAction func clickBtnNewUser(sender: UIButton) {
        let sb = UIStoryboard(name: "SignUp", bundle: nil)
        let signUpViewController = sb.instantiateViewControllerWithIdentifier("SignUpViewController") as! SignUpViewController
        self.presentViewController(signUpViewController, animated: true, completion: nil)
    }
    
    //MARK: - Keyboard Notification
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
    
    //MARk: -
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(LoginViewController.keyboardWillShown(_:)), name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(LoginViewController.keyboardWillBeHidden(_:)), name: UIKeyboardWillHideNotification, object: nil)
    }
    
    deinit{
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
}