//
//  NewAccountVC.swift
//  Bx Connect
//
//  Created by Erik Fernando Flores Quispe on 26/05/17.
//  Copyright © 2017 Belatrix. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import SwiftyBeaver

enum NewAccountError: Error {
    case invalidEmail
}

class NewAccountVC: UIViewController {
    
    // MARK: - Properties
    
    @IBOutlet weak var newUserTextField: UITextField!
    @IBOutlet weak var emailIcon: UIImageView!
    @IBOutlet weak var signUpButton: UIButton!
    let log = SwiftyBeaver.self
    
    // MARK: -  LifeCycle

    override func viewDidLoad() {
        super.viewDidLoad()
        Please.addCornerRadiusTo(button: self.signUpButton)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        Please.animate(icon: self.emailIcon)
    }
    
    // MARK: - Actions
    
    @IBAction func requestAccount(_ sender: UIButton) {
        do {
            let userEmail = try self.validateTextField(user: self.newUserTextField)
            let activity = Please.showActivityButton(in: sender)
            self.requestNewAccount(withEmail: userEmail, completionHandler: { json in
                activity.stopAnimating()
                Please.showAlert(withMessage: json["detail"].string!, in: self)
                self.newUserTextField.text = ""
                Please.makeFeedback(type: .success)
            })
        } catch let error as NewAccountError{
            self.handle(error)
        } catch {
            self.log.error("New error in NewAccount")
        }
    }
    
    
    @IBAction func closeModal(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    // MARK: - Functions
    
    func validateTextField(user:UITextField) throws -> String {
        guard let userEmail = user.text, userEmail.isValidEmail else {
            throw NewAccountError.invalidEmail
        }
        return userEmail
    }
    
    func requestNewAccount(withEmail email:String, completionHandler: @escaping (_ json:JSON) -> Void) {
        let userParameters = ["email":email]
        Alamofire.request(Api.Url.createNewUser, method:.post, parameters:userParameters).responseJSON { response in
            guard response.result.error == nil else {
                self.log.error(response.result.error!)
                return
            }
            guard let json = response.result.value else {
                self.log.error(response.error!)
                return
            }
            completionHandler(JSON(json))
        }
    }
    
    func handle(_ error:NewAccountError) {
        switch error {
        case .invalidEmail:
            Please.showAlert(withMessage: "Wrong Email", in: self)
        }
        Please.makeFeedback(type: .error)
    }


}
