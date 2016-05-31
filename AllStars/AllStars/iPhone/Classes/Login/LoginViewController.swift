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
        
        LoginBC.loginWithUser(objUser, withController: self) { (user : User?) in
            
            self.view.userInteractionEnabled = true
            self.activityEnter.stopAnimating()
            
            self.getInfoCurrentUser()
        }
    }
    
    
    func getInfoCurrentUser() -> Void {
        
        self.view.userInteractionEnabled = false
        self.activityEnter.startAnimating()
        
        LoginBC.getUserSessionInfoConCompletion { (user : User?) in
         
            self.view.userInteractionEnabled = true
            self.activityEnter.stopAnimating()
            
            if user != nil {
                self.dismissViewControllerAnimated(true, completion: nil)
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

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
