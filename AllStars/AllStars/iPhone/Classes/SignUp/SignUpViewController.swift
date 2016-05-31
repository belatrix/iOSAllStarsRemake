//
//  SignUpViewController.swift
//  AllStars
//
//  Created by Flavio Franco Tunqui on 5/31/16.
//  Copyright © 2016 Belatrix SF. All rights reserved.
//

import UIKit

class SignUpViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    // MARK: - IBActions
    @IBAction func btnRegisterTUI(sender: UIButton) {
        // call WS
    }
    
    @IBAction func btnBackTUI(sender: UIButton) {
        self.view.endEditing(true)
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    // MARK: - WebServices
//    func loginWithUser(objUser : User) -> Void {
//        
//        self.view.userInteractionEnabled = false
//        self.activityEnter.startAnimating()
//        
//        LoginBC.loginWithUser(objUser, withController: self) { (user : User?) in
//            
//            self.view.userInteractionEnabled = true
//            self.activityEnter.stopAnimating()
//            
//            self.getInfoCurrentUser()
//        }
//    }
//    
//    
//    func getInfoCurrentUser() -> Void {
//        
//        self.view.userInteractionEnabled = false
//        self.activityEnter.startAnimating()
//        
//        LoginBC.getUserSessionInfoConCompletion { (user : User?) in
//            
//            self.view.userInteractionEnabled = true
//            self.activityEnter.stopAnimating()
//            
//            if user != nil {
//                self.dismissViewControllerAnimated(true, completion: nil)
//            }
//        }
//    }
    
    // MARK: - UITextFieldDelegate
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        // call WS
        
        return true
    }
}