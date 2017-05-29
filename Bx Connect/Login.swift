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
import PromiseKit
import SwiftyBeaver
import SafariServices

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
        
        guard let userValue = self.userTextField.text, userValue.isValidName else {
            self.showAlert(with: "Wrong User")
            return
        }
        
        guard let passwordValue = self.passwordTextField.text, passwordValue.isValidPassword else {
            self.showAlert(with: "Wrong Password")
            return
        }
        
        self.showActivity(in: sender)
        
        self.performSegue(withIdentifier: K.segue.tabController, sender: nil)
        
    }
    
    @IBAction func showPrivacyPolicy(_ sender: Any) {
        let urlPrivacyPolicy = URL(string: K.url.privacyPolicy)
        let safari = SFSafariViewController(url: urlPrivacyPolicy!)
        self.present(safari, animated: true)
    }

    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == K.segue.tabController {
            let tabBarVC = segue.destination as! UITabBarController
            let profileVC = tabBarVC.viewControllers?[0] as! ProfileVC
            profileVC.employee = self.employee
        }
    }
    
    
    // MARK: - Functions
    

    func authenticationFor(user:String, with password:String) -> Promise<Any> {
        let authParamaters = ["username":user, "password":password]
        return Promise { fulfill, reject in
            Alamofire.request(Api.Url.authenticate, method: .post, parameters:authParamaters)
                .responseJSON().then { response -> Void in
                    fulfill(response)
                }.catch { error in
                   reject(error)
                }
        }
    }
    
    func getUserData(with auth:Authenticate) -> Promise<Any> {
        let urlEmployeeId = URL(string: Api.Url.employee(with: auth.userId!))
        var urlEmployeeRequest = URLRequest(url: urlEmployeeId!)
        self.log.debug("Token \(auth.userId)")
        self.log.debug("Token \(auth.token)")
        urlEmployeeRequest.addValue("Authorization", forHTTPHeaderField: "Token \(auth.token)")
        return Promise { fulfill, reject in
            Alamofire.request(urlEmployeeRequest)
                .responseJSON().then { response -> Void in
                    self.log.debug(response)
                    fulfill(response)
                }.catch { error in
                    reject(error)
            }
        }
    }
    
    func showAlert(with message:String) {
        let alert = UIAlertController(title: K.app.name, message: message, preferredStyle: .alert)
        let btnOk = UIAlertAction(title: "OK", style: .default)
        alert.addAction(btnOk)
        self.present(alert, animated: true)
    }
    
    func showActivity(in view:UIView) {
        let activityView = UIActivityIndicatorView()
        activityView.startAnimating()
        activityView.hidesWhenStopped = true
        let positionX = view.frame.size.width - 25
        let positionY = view.frame.size.height / 2
        activityView.frame = CGRect(x: positionX, y: positionY, width: 25, height: 0)
        view.addSubview(activityView)
        
    }
    
    func connect() {
        let userValue = ""
        let passwordValue = ""
        self.authenticationFor(user: userValue, with: passwordValue).then { data -> Authenticate in
            let json = JSON(data)
            guard (json["detail"].string == nil) else { throw BxError.unauthorized  }
            return Authenticate(data: json)
            }.then { authenticatePermisons -> Void in
                self.authenticate = authenticatePermisons
                self.getUserData(with: authenticatePermisons).then { data -> Void in
                    let json = JSON(data)
                    self.log.debug(json)
                    guard (json["detail"].string == nil) else { throw BxError.unauthorized  }
                    self.log.debug(json)
                    self.employee = Employee(data: json)
                    self.log.debug(self.employee?.email ?? "no email")
                    
                    }.catch { error in
                        self.log.error(error)
                }
            }.catch { error in
                switch error {
                case BxError.unauthorized:
                    self.log.error("bx error detail")
                default:
                    print("error \(error)")
                }
        }
    }

}

