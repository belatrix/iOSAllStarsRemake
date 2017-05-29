//
//  ProfileVC.swift
//  Bx Connect
//
//  Created by Erik Fernando Flores Quispe on 25/05/17.
//  Copyright © 2017 Belatrix. All rights reserved.
//

import UIKit
import SwiftyBeaver

class ProfileVC: UIViewController {
    
    var employee:Employee?
    let log = SwiftyBeaver.self

    override func viewDidLoad() {
        super.viewDidLoad()
        log.debug(employee ?? "No employee")
        log.verbose(employee?.email ?? "no email")
        log.verbose(employee?.firstName ?? "no firstname")
        log.verbose(employee?.lastName ?? "no lastname")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
