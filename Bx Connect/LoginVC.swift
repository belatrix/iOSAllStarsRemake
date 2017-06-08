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
import SwiftyUserDefaults
import Moya

enum LoginError:Swift.Error {
    case invalidUser
    case invalidPassword
}

class LoginVC: UIViewController {
    
    // MARK: - Properties
    
    @IBOutlet weak var userTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var createAccountButton: UIButton!
    var employee:Employee?
    let log = SwiftyBeaver.self
    let provider = MoyaProvider<ConnectAPI>(endpointClosure: endpointClosure)
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Please.addCornerRadiusTo(button: loginButton,createAccountButton)
    }
    
    // MARK: - Actions
    
    @IBAction func login(_ sender: UIButton) {
        do {
            let textField = try self.validateTextField(user: self.userTextField, password: self.passwordTextField)
            let activity = Please.showActivityButton(in: sender)
            self.authenticationFor(user: textField.0, with: textField.1, completionHandler: { json in
                
                activity.stopAnimating()
                self.log.verbose(json)
                
                if let detail = json["detail"].string {
                    Please.showAlert(withMessage: detail, in: self)
                    return
                }
                
                let authenticate = Authenticate(data: json)
                authenticate.saveInDefaults()
                
                self.getUserData(with: authenticate.userID!, completionHandler: { json in
                    self.log.verbose(json)
                    if let detail = json["detail"].string {
                        Please.showAlert(withMessage: detail, in: self)
                        return
                    }
                    self.employee = Employee(data: json)
                    
                    self.performSegue(withIdentifier: K.Segue.tabController, sender: nil)
                })
                
            })
        } catch let error as LoginError{
            self.handle(error)
        } catch {
            self.log.error("Login Error")
        }
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
        
        self.provider.request(.authenticate(user: user, password: password)) { result in
            switch result {
            case let .success(moyaResponse):
                let data = moyaResponse.data
                completionHandler(JSON(data))
            case let .failure(error):
                self.log.error(error)
            }
        }
        
    }
    
    func getUserData(with id:Int, completionHandler: @escaping (_ json:JSON)->Void) {
        
        self.provider.request(.employee(id: id)) { result in
            switch result {
            case let .success(moyaResponse):
                let data = moyaResponse.data
                completionHandler(JSON(data))
            case let .failure(error):
                self.log.error(error)
            }
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

