//
//  ResetPasswordViewController.swift
//  AllStars
//
//  Created by Flavio Franco Tunqui on 6/9/16.
//  Copyright © 2016 Belatrix SF. All rights reserved.
//

import UIKit

class ResetPasswordViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var edtCurrentPassword           : UITextField!
    @IBOutlet weak var edtNewPassword           : UITextField!
    @IBOutlet weak var edtRepeatNewPassword     : UITextField!
    @IBOutlet weak var actReset                 : UIActivityIndicatorView!
    @IBOutlet weak var imgReset                 : UIImageView!
    @IBOutlet weak var viewCurrentPassword      : UIView!
    @IBOutlet weak var viewNewPassword          : UIView!
    @IBOutlet weak var viewRepeatOldPassword    : UIView!
    @IBOutlet weak var btnReset                 : UIButton!
    
    var userSession : UserSession?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setViews()
    }
    
    // MARK: - UI
    func setViews() {
        viewCurrentPassword.backgroundColor = UIColor.colorPrimary()
        viewNewPassword.backgroundColor = UIColor.colorPrimary()
        viewRepeatOldPassword.backgroundColor = UIColor.colorPrimary()
        
        btnReset.backgroundColor = UIColor.colorPrimary()
        
        let image = UIImage(named: "lock")
        imgReset.image = image?.imageWithRenderingMode(.AlwaysTemplate)
        imgReset.tintColor = UIColor.colorPrimary()
    }
    
    func lockScreen() {
        self.view.userInteractionEnabled = false
        self.actReset.startAnimating()
    }
    
    func unlockScreen() {
        self.view.userInteractionEnabled = true
        self.actReset.stopAnimating()
    }
    
    // MARK: - IBActions
    @IBAction func btnResetTUI(sender: UIButton) {
        resetPassword(userSession!)
    }
    
    @IBAction func tapCloseKeyboard(sender: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }
    
    // MARK: - WebServices
    func resetPassword(objUser : UserSession) -> Void {
        
        lockScreen()
        
        let currentPasswordString = self.edtCurrentPassword.text!
        let newPasswordString = self.edtNewPassword.text!
        let repeatNewPasswordString = self.edtRepeatNewPassword.text!
        
        LogInBC.resetUserPassword(objUser, currentPassword: currentPasswordString, newPassword : newPasswordString, repeatNewPassword: repeatNewPasswordString, withController: self) { (user : User?) in
            
            self.unlockScreen()
            
            if (user != nil) {
                
                SessionUD.sharedInstance.setUserNeedsResetPwd(false)
                
                if (user!.user_base_profile_complete!) {
                    self.getInfoCurrentUser()
                } else {
                    let sb = UIStoryboard(name: "Profile", bundle: nil)
                    let editProfileViewController = sb.instantiateViewControllerWithIdentifier("EditProfileViewController") as! EditProfileViewController
                    editProfileViewController.objUser = user
                    editProfileViewController.isNewUser = true
                    self.presentViewController(editProfileViewController, animated: true, completion: nil)
                }
            }
        }
    }
    
    func getInfoCurrentUser() -> Void {
        
        lockScreen()
        
        LogInBC.getUserSessionInformation { (user : User?) in
            
            self.unlockScreen()
            
            if (user != nil) {
                let storyBoard : UIStoryboard = UIStoryboard(name: "TabBar", bundle:nil)
                let tabBarViewController = storyBoard.instantiateViewControllerWithIdentifier("CustomTabBarViewController") as! UITabBarController

                tabBarViewController.delegate = UIApplication.sharedApplication().delegate as! AppDelegate
                tabBarViewController.moreNavigationController.delegate = UIApplication.sharedApplication().delegate as! AppDelegate
                
                self.presentViewController(tabBarViewController, animated: true, completion: nil)
            }
        }
    }
    
    // MARK: - UITextFieldDelegate
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        
        if self.edtCurrentPassword == textField {
            self.edtNewPassword.becomeFirstResponder()
        } else if self.edtNewPassword == textField {
            self.edtRepeatNewPassword.becomeFirstResponder()
        } else {
            resetPassword(userSession!)
        }
        
        return true
    }
}