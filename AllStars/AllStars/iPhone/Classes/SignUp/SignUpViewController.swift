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
        self.view.endEditing(true)
        
        self.createUser(txtEmail.text!)
    }
    
    @IBAction func btnBackTUI(sender: UIButton) {
        self.view.endEditing(true)
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    // MARK: - WebServices
    func createUser(email : String) -> Void {
        
        self.view.userInteractionEnabled = false
        self.activityIndicator.startAnimating()
        
        SignUpBC.createUser(email, withController: self) { (message : String) in
            
            self.view.userInteractionEnabled = true
            self.activityIndicator.stopAnimating()
            
//            self.dismissViewControllerAnimated(true, completion: nil)
        }
    }
    
    // MARK: - UITextFieldDelegate
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        // call WS
        
        return true
    }
}