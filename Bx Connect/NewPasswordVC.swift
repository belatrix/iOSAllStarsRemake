//
//  NewPasswordVC.swift
//  Bx Connect
//
//  Created by Erik Fernando Flores Quispe on 26/05/17.
//  Copyright © 2017 Belatrix. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import SwiftyBeaver

enum NewPasswordError: Error {
    case invalidEmail
}

class NewPasswordVC: UIViewController {
    
    @IBOutlet weak var userTextField: UITextField!
     let log = SwiftyBeaver.self
    
    //MARK: - LifeCycle

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    //MARK: - Actions
    
    @IBAction func requestPassword(_ sender: UIButton) {
        do {
            let userEmail = try self.validateTextField(user:self.userTextField)
            let userActivity = Please.showActivityButton(in: sender)
            self.requestNewPassword(withEmail: userEmail) { json in
                userActivity.stopAnimating()
                Please.showAlert(withMessage: json["detail"].string!, in: self)
                self.userTextField.text = ""
                Please.makeFeedback(type: .success)
            }
        } catch let error as NewPasswordError {
            self.handle(error)
        } catch {
            self.log.error("New error in NewPassword")
        }
    }
    
    @IBAction func closeModal(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    //MARK: - Functions
    
    func validateTextField(user:UITextField) throws -> String  {
        guard let userEmail = user.text, userEmail.isValidEmail else {
            throw NewPasswordError.invalidEmail
        }
        return userEmail
    }

    func requestNewPassword(withEmail email:String, completionHandler: @escaping (_ json:JSON)->Void){
        Alamofire.request(Api.Url.resetPassword(with: email)).responseJSON { response in
            guard response.result.error == nil else {
                self.log.error(response.result.error!)
                return
            }
            guard let json = response.result.value else {
                self.log.error(response.result.error!)
                return
            }
            completionHandler(JSON(json))
        }
    }
    
    func handle(_ error:NewPasswordError) {
        switch error {
        case .invalidEmail:
            Please.showAlert(withMessage: "Wrong Email", in: self)
        }
        Please.makeFeedback(type: .error)
    }

}
