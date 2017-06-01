//
//  Please.swift
//  Bx Connect
//
//  Created by Erik Fernando Flores Quispe on 30/05/17.
//  Copyright © 2017 Belatrix. All rights reserved.
//

import UIKit

/* Please is my new name for tradicional Util struct */

struct Please {
    static func showAlert(withMessage message:String, in view:UIViewController) {
        let alert = UIAlertController(title: K.App.name, message: message, preferredStyle: .alert)
        let btnOk = UIAlertAction(title: "OK", style: .default)
        alert.addAction(btnOk)
        view.present(alert, animated: true)
    }
    
    static func showActivityButton(in view:UIView) -> UIActivityIndicatorView{
        let activityView = UIActivityIndicatorView()
        activityView.startAnimating()
        activityView.hidesWhenStopped = true
        let positionX = view.frame.size.width - 30
        let positionY = view.frame.size.height / 2
        activityView.frame = CGRect(x: positionX, y: positionY, width: 25, height: 0)
        view.addSubview(activityView)
        return activityView
    }
    
    static func makeFeedback(type:UINotificationFeedbackType) {
        if #available(iOS 10.0, *) {
            var feedbackGenerator : UINotificationFeedbackGenerator? =  nil
            feedbackGenerator = UINotificationFeedbackGenerator()
            feedbackGenerator?.prepare()
            feedbackGenerator?.notificationOccurred(type)
            feedbackGenerator = nil
        }
    }
    
    static func animate(icon:UIView) {
        UIView.animate(withDuration: 0.5, animations: {
            icon.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        }) { confirm in
            UIView.animate(withDuration: 0.2, animations: {
                icon.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
            }) { confirm in
                UIView.animate(withDuration: 0.4, animations: {
                    icon.transform = CGAffineTransform(scaleX: 1, y: 1)
                })
            }
        }
    }
    
    static func addCornerRadiusTo(button:UIButton...) {
        for btn in button {
            btn.layer.cornerRadius = 5
        }
    }
    
}
