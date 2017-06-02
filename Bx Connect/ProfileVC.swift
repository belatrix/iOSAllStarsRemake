//
//  ProfileVC.swift
//  Bx Connect
//
//  Created by Erik Fernando Flores Quispe on 25/05/17.
//  Copyright © 2017 Belatrix. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage
import SwiftyBeaver

class ProfileVC: UIViewController {
    
    // MARK: - Properties
    
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var userEmailLabel: UILabel!
    @IBOutlet weak var userSkypeLabel: UILabel!
    @IBOutlet weak var userLocationLabel: UILabel!
    @IBOutlet weak var userImage: UIImageView!
    var employee:Employee!
    let log = SwiftyBeaver.self

    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setImageProfile(withURL: self.employee.avatar!)
        self.setDataInView(ofEmployee: self.employee)
    }
    
    // MARK: - Functions
    
    func setImageProfile(withURL url:String) {
        self.userImage.af_setImage(
            withURL: URL(string: url)!,
            imageTransition: .crossDissolve(0.2)
        )
    }

    func setDataInView(ofEmployee employee:Employee) {
        self.userNameLabel.text = "\(employee.firstName!) \(employee.lastName!)"
        self.userEmailLabel.text = "\(employee.email!)"
        self.userSkypeLabel.text = "Skype: \(employee.skypeId!)"
        self.userLocationLabel.text = "Location: \(employee.location!.name!)"
    }


}
