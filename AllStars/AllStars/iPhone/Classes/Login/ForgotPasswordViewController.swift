//
//  ForgotPasswordViewController.swift
//  AllStars
//
//  Created by Ricardo Hernan Herrera Valle on 7/20/16.
//  Copyright © 2016 Belatrix SF. All rights reserved.
//

import Foundation

class ForgotPasswordViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var titleLabel         : UILabel!
    @IBOutlet weak var subtitleLabel      : UILabel!
    @IBOutlet weak var emailTextField     : UITextField!
    @IBOutlet weak var requestButton      : UIButton!
    @IBOutlet weak var forgotPwdIndicator : UIActivityIndicatorView!
    @IBOutlet weak var imgPwd : UIImageView!
    
    // MARK: - Initialization
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setViews()
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(ForgotPasswordViewController.tapCloseKeyboard))
        
        self.view.addGestureRecognizer(tapGesture)
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.tapCloseKeyboard()
    }
    
    // MARK: - UI
    func setViews() {
        
        requestButton.backgroundColor = UIColor.colorPrimary()
        emailTextField.delegate = self
        
        let image = UIImage(named: "key.png")
        imgPwd.image = image?.imageWithRenderingMode(.AlwaysTemplate)
        imgPwd.tintColor = UIColor.colorPrimary()
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
    
    func tapCloseKeyboard() {
        self.view.endEditing(true)
    }
    
    // MARK: - WebServices
    func requestPassword(email : String) -> Void {
        lockScreen()
        
        tapCloseKeyboard()
        
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