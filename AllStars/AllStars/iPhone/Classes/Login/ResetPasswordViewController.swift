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
        
        LoginBC.resetUserPassword(objUser, oldPassword: edtOldPassword.text!, newPassword : edtNewPassword.text!, repeatNewPassword: edtRepeatNewPassword.text!, withController: self) { (user : User?, messageError : String?) in
            
            self.view.userInteractionEnabled = true
            self.actIndicator.stopAnimating()
            
//            if (accountState == Constants.PASSWORD_RESET_INCOMPLETE) {
//                let resetPasswordViewController = self.storyboard!.instantiateViewControllerWithIdentifier("ResetPasswordViewController") as! ResetPasswordViewController
//                self.presentViewController(resetPasswordViewController, animated: true, completion: nil)
//            } else if (accountState == Constants.PROFILE_INCOMPLETE) {
//                print("incomplete")
//            } else if (accountState == Constants.PROFILE_COMPLETE) {
////                self.getInfoCurrentUser()
//            }
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