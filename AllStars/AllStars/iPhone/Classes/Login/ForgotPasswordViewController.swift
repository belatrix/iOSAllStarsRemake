//
//  ForgotPasswordViewController.swift
//  AllStars
//
//  Created by Ricardo Hernan Herrera Valle on 7/20/16.
//  Copyright © 2016 Belatrix SF. All rights reserved.
//

import Foundation

class ForgotPasswordViewController: UIViewController {
    
    @IBOutlet weak var titleLabel         : UILabel!
    @IBOutlet weak var subtitleLabel      : UILabel!
    @IBOutlet weak var emailTextField     : UITextField!
    @IBOutlet weak var requestButton      : UIButton!
    @IBOutlet weak var forgotPwdIndicator : UIActivityIndicatorView!
    
    // MARK: - Initialization
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    // MARK: - UI
    func setViews() {
        emailTextField.backgroundColor = UIColor.colorPrimary()
        requestButton.backgroundColor = UIColor.colorPrimary()
    }
    
    func lockScreen() {
        self.view.userInteractionEnabled = false
        self.forgotPwdIndicator.startAnimating()
    }
    
    func unlockScreen() {
        self.view.userInteractionEnabled = true
        self.forgotPwdIndicator.stopAnimating()
    }
    
    // MARK: - User interaction
    @IBAction func requestNewPassword(sender: UIButton!) {
        
        self.view.endEditing(true)
        
        self.requestPassword(emailTextField.text!)
    }
    
    @IBAction func goBack(sender: UIButton!) {
        
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    // MARK: - WebServices
    func requestPassword(email : String) -> Void {
        lockScreen()
        
        LogInBC.forgotPassword(email) { (successful) in
            self.unlockScreen()
            
            if (successful) {
                self.dismissViewControllerAnimated(true, completion: nil)
            }
        }
    }
    
    // MARK: - UITextFieldDelegate
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        self.requestPassword(emailTextField.text!)
        
        return true
    }
}