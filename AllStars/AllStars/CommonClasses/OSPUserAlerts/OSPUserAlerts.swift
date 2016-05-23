//
//  OSPUserAlerts.swift
//  BookShelf
//
//  Created by Kenyi Rodriguez on 18/04/16.
//  Copyright © 2016 Online Studio Productions. All rights reserved.
//

import UIKit

class OSPUserAlerts: NSObject {

    class func mostrarAlertaConTitulo(titulo : String, conMensaje mensaje : String, conBotonCancelar cancelar : String, enController controller : UIViewController?, conCompletion completion : (()->Void)?){
        
        let alertController = UIAlertController(title: titulo, message: mensaje, preferredStyle: UIAlertControllerStyle.Alert)
        let accionCancelar = UIAlertAction(title: cancelar, style: UIAlertActionStyle.Cancel) { (action : UIAlertAction) in
            
            if completion != nil {
                completion!()
            }
        }
        
        alertController.addAction(accionCancelar)
        
        if controller == nil {
            
            let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
            appDelegate.window?.rootViewController?.presentViewController(alertController, animated: true, completion: nil)
            
        }else{
            controller?.presentViewController(alertController, animated: true, completion: nil)
        }
        
    }
    
    
    class func mostrarAlertaConTitulo(titulo : String, conMensaje mensaje : String, conBotonCancelar cancelar : String, conBotonAceptar aceptar : String, enController controller : UIViewController?, conCompletionCancelar completionCancelar : (()->Void)?, conCompletionAceptar completionAceptar : (()->Void)?){
        
        let alertController = UIAlertController(title: titulo, message: mensaje, preferredStyle: UIAlertControllerStyle.Alert)
        let accionCancelar = UIAlertAction(title: cancelar, style: UIAlertActionStyle.Cancel) { (action : UIAlertAction) in
            
            if completionCancelar != nil {
                completionCancelar!()
            }
        }
        
        
        let accionAceptar = UIAlertAction(title: aceptar, style: UIAlertActionStyle.Default) { (action : UIAlertAction) in
            
            if completionAceptar != nil {
                completionAceptar!()
            }
        }
        
        
        alertController.addAction(accionCancelar)
        alertController.addAction(accionAceptar)
        
        if controller == nil {
            
            let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
            appDelegate.window?.rootViewController?.presentViewController(alertController, animated: true, completion: nil)
            
        }else{
            controller?.presentViewController(alertController, animated: true, completion: nil)
        }
        
    }
}
