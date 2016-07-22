//
//  LogInGuestEmailViewController.swift
//  AllStars
//
//  Created by Flavio Franco Tunqui on 7/1/16.
//  Copyright © 2016 Belatrix SF. All rights reserved.
//

import UIKit

class LogInGuestEmailViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var edtEmail                 : UITextField!
    @IBOutlet weak var actRegister              : UIActivityIndicatorView!
    @IBOutlet weak var imgRegister              : UIImageView!
    @IBOutlet weak var viewEdtEmail             : UIView!
    @IBOutlet weak var btnRegister              : UIButton!
    @IBOutlet weak var lblSocialNetworkMessage  : UILabel!
    
    var fullName : String = ""
    var socialNetworkType : Int = 0
    var socialNetworkId : String = ""
    
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
        
        if (socialNetworkType == 1) {
            lblSocialNetworkMessage.text = "facebook_profile_message".localized
        } else if (socialNetworkType == 2) {
            lblSocialNetworkMessage.text = "twitter_profile_message".localized
        }
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
        
        self.createParticipant(fullName, email: edtEmail.text!, socialNetworkType: 1, socialNetworkId: socialNetworkId)
    }
    
    @IBAction func btnBackTUI(sender: UIButton) {
        self.view.endEditing(true)
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func tapCloseKeyboard(sender: AnyObject) {
        self.view.endEditing(true)
    }
    
    // MARK: - WebServices
    func createParticipant(fullName : String?, email : String?, socialNetworkType : Int, socialNetworkId : String) -> Void {
        lockScreen()
        
        LogInBC.createParticipant(fullName, email: email, socialNetworkType: socialNetworkType, socialNetworkId: socialNetworkId) { (userGuest, fieldsCompleted) in
            
            self.unlockScreen()
            
            if (fieldsCompleted) {
                let sb = UIStoryboard(name: "TabBar", bundle: nil)
                let guestTabController = sb.instantiateViewControllerWithIdentifier("GuestTabBarViewController") as! UITabBarController
                self.presentViewController(guestTabController, animated: true, completion: nil)
            }
        }
    }
    
    // MARK: - UITextFieldDelegate
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        self.createParticipant(fullName, email: edtEmail.text!, socialNetworkType: 1, socialNetworkId: socialNetworkId)
        
        return true
    }
}