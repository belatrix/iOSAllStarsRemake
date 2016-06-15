//
//  ResetPasswordViewController.swift
//  AllStars
//
//  Created by Flavio Franco Tunqui on 6/9/16.
//  Copyright © 2016 Belatrix SF. All rights reserved.
//

import UIKit

class ResetPasswordViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var edtOldPassword: UITextField!
    @IBOutlet weak var edtNewPassword: UITextField!
    @IBOutlet weak var edtRepeatNewPassword: UITextField!
    @IBOutlet weak var actIndicator: UIActivityIndicatorView!
    
    var userSession : UserSession?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    //MARK: - IBActions
    @IBAction func btnResetTUI(sender: UIButton) {
        resetPassword(userSession!)
    }
    
    @IBAction func tapCloseKeyboard(sender: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }
    
    //MARK: - WebServices
    func resetPassword(objUser : UserSession) -> Void {
        
        self.view.userInteractionEnabled = false
        self.actIndicator.startAnimating()
        
        let oldPasswordString = self.edtOldPassword.text!
        let newPasswordString = self.edtNewPassword.text!
        let repeatNewPasswordString = self.edtRepeatNewPassword.text!
        
        LoginBC.resetUserPassword(objUser, oldPassword: oldPasswordString, newPassword : newPasswordString, repeatNewPassword: repeatNewPasswordString, withController: self) { (user : User?, messageError : String?) in
            
            self.view.userInteractionEnabled = true
            self.actIndicator.stopAnimating()

            if (user != nil && user!.user_base_profile_complete!) {
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
    
    func getInfoCurrentUser() -> Void {
        
        self.view.userInteractionEnabled = false
        self.actIndicator.startAnimating()
        
        LoginBC.getUserSessionInfoConCompletion { (user : User?) in
            
            self.view.userInteractionEnabled = true
            self.actIndicator.stopAnimating()
            
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
    
    //MARK: - UITextFieldDelegate
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        
        if self.edtOldPassword == textField {
            self.edtNewPassword.becomeFirstResponder()
        } else if self.edtNewPassword == textField {
            self.edtRepeatNewPassword.becomeFirstResponder()
        } else {
            resetPassword(userSession!)
        }
        
        return true
    }
}