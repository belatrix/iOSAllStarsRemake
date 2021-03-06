//
//  SignUpViewController.swift
//  AllStars
//
//  Created by Flavio Franco Tunqui on 5/31/16.
//  Copyright © 2016 Belatrix SF. All rights reserved.
//

import UIKit

class SignUpViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var edtEmail             : UITextField!
    @IBOutlet weak var actRegister          : UIActivityIndicatorView!
    @IBOutlet weak var imgRegister          : UIImageView!
    @IBOutlet weak var viewEdtEmail         : UIView!
    @IBOutlet weak var btnRegister          : UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setViews()
    }
    
    // MARK: - UI
    func setViews() {
        viewEdtEmail.backgroundColor = UIColor.colorPrimary()
        
        btnRegister.backgroundColor = UIColor.colorPrimary()
        
        let image = UIImage(named: "mail")
        imgRegister.image = image?.imageWithRenderingMode(.AlwaysTemplate)
        imgRegister.tintColor = UIColor.colorPrimary()
    }
    
    func lockScreen() {
        self.view.userInteractionEnabled = false
        self.actRegister.startAnimating()
    }
    
    func unlockScreen() {
        self.view.userInteractionEnabled = true
        self.actRegister.stopAnimating()
    }
    
    // MARK: - IBActions
    @IBAction func btnRegisterTUI(sender: UIButton) {
        self.view.endEditing(true)
        
        self.createUser(edtEmail.text!)
    }
    
    @IBAction func btnBackTUI(sender: UIButton) {
        self.view.endEditing(true)
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func tapCloseKeyboard(sender: AnyObject) {
        self.view.endEditing(true)
    }
    
    // MARK: - WebServices
    func createUser(email : String) -> Void {
        lockScreen()
        
        SignUpBC.createUser(email) { (successful) in
            
            self.unlockScreen()
            
            if (successful) {
                self.dismissViewControllerAnimated(true, completion: nil)
            }
        }
    }
    
    // MARK: - UITextFieldDelegate
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        self.createUser(edtEmail.text!)
        
        return true
    }
}