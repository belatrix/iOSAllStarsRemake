//
//  OSPWebResponse.swift
//  BookShelf
//
//  Created by Kenyi Rodriguez on 11/04/16.
//  Copyright © 2016 Online Studio Productions. All rights reserved.
//

import UIKit

class OSPWebResponse: NSObject {

    var respuestaJSON   : AnyObject?
    var statusCode      : NSInteger?
    var respuestaNSData : NSData?
    var error           : NSError?
    var datosCabezera   : NSDictionary?
    var token           : NSString?
    var cookie          : NSString?
    
}
