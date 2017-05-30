//
//  Login.swift
//  Bx Connect
//
//  Created by Erik Fernando Flores Quispe on 23/05/17.
//  Copyright © 2017 Belatrix. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import SwiftyBeaver
import SafariServices

enum LoginError:Error {
    case invalidUser
    case invalidPassword
}

class Login: UIViewController {
    
    // MARK: - Properties
    @IBOutlet weak var userTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    var employee:Employee?
    var authenticate:Authenticate!
    let log = SwiftyBeaver.self
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - Actions
    @IBAction func login(_ sender: UIButton) {
        do {
            let textField = try self.validateTextField(user: self.userTextField, password: self.passwordTextField)
            let activity = Please.showActivityButton(in: sender)
            self.authenticationFor(user: textField.0, with: textField.1, completionHandler: { json in
                activity.stopAnimating()
                if let detail = json["detail"].string {
                    Please.showAlert(withMessage: detail, in: self)
                    return
                }
                self.log.verbose(json)
            })
        } catch let error as LoginError{
            self.handle(error)
        } catch {
            self.log.error("Login Error")
        }
        
        //self.performSegue(withIdentifier: K.Segue.tabController, sender: nil)
    }
    
    @IBAction func showPrivacyPolicy(_ sender: Any) {
        let urlPrivacyPolicy = URL(string: K.Url.privacyPolicy)
        let safari = SFSafariViewController(url: urlPrivacyPolicy!)
        self.present(safari, animated: true)
    }

    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == K.Segue.tabController {
            let tabBarVC = segue.destination as! UITabBarController
            let profileVC = tabBarVC.viewControllers?[0] as! ProfileVC
            profileVC.employee = self.employee
        }
    }
    
    
    // MARK: - Functions
    
    func validateTextField(user:UITextField, password:UITextField) throws -> (String,String) {
        guard let userValue = user.text, userValue.isValidName else {
            throw LoginError.invalidUser
        }
        
        guard let passwordValue = password.text, passwordValue.isValidPassword else {
            throw LoginError.invalidPassword
        }
        return (userValue, passwordValue)
    }

    func authenticationFor(user:String, with password:String, completionHandler: @escaping (_ json:JSON)->Void) {
        let authParamaters = ["username":user, "password":password]
        Alamofire.request(Api.Url.authenticate, method: .post, parameters:authParamaters).responseJSON() { response -> Void in
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
    
    func getUserData(with auth:Authenticate, completionHandler: @escaping (_ json:JSON)->Void) {
        let urlEmployeeId = URL(string: Api.Url.employee(with: auth.userId!))
        var urlEmployeeRequest = URLRequest(url: urlEmployeeId!)
        urlEmployeeRequest.addValue("Authorization", forHTTPHeaderField: "Token \(auth.token)")
        
        Alamofire.request(urlEmployeeRequest).responseJSON() { response -> Void in
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
    
    func handle(_ error:LoginError) {
        switch error {
        case .invalidUser:
            Please.showAlert(withMessage: "Wrong User", in: self)
        case .invalidPassword:
            Please.showAlert(withMessage: "Wrong Password", in: self)
        }
        Please.makeFeedback(type: .error)
    }
    

}

