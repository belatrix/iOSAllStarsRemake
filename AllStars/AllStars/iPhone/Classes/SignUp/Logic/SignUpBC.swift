//
//  SignUpBC.swift
//  AllStars
//
//  Created by Flavio Franco Tunqui on 6/8/16.
//  Copyright © 2016 Belatrix SF. All rights reserved.
//

import UIKit

class SignUpBC: NSObject {

    class func createUser(mail : String, withController controller : UIViewController, withCompletion completion : (message : String) -> Void) {
        
        if (mail == "") {
            OSPUserAlerts.mostrarAlertaConTitulo("Error", conMensaje: "Email must not be empty", conBotonCancelar: "Accept", enController: controller, conCompletion: nil)
            completion(message: "")
            return
        }
        
        if (!Util.isValidEmail(mail)) {
            OSPUserAlerts.mostrarAlertaConTitulo("Error", conMensaje: "Email must be valid", conBotonCancelar: "Accept", enController: controller, conCompletion: nil)
            completion(message: "")
            return
        }
        
        OSPWebModel.createUser(mail) { (message : String) in
            
            if message == "" {
                OSPUserAlerts.mostrarAlertaConTitulo("Error", conMensaje: "We could't create your account", conBotonCancelar: "Accept", enController: controller, conCompletion: nil)
            } else {
                OSPUserAlerts.mostrarAlertaConTitulo("Create Account", conMensaje: message, conBotonCancelar: "Accept", enController: controller, conCompletion: nil)
            }
            
            completion(message: message)
        }
    }
}