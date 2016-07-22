//
//  EventBC.swift
//  AllStars
//
//  Created by Flavio Franco Tunqui on 7/6/16.
//  Copyright © 2016 Belatrix SF. All rights reserved.
//

import UIKit

class EventBC: NSObject {
    
    class func listEventsWithKeyword(searchString: String?, withCompletion completion : (arrayEvents : NSMutableArray?, nextPage : String?) -> Void) {
        
        OSPWebModel.listEvents(searchString) { (arrayEvents, nextPage, errorResponse, successful) in
            
            if (arrayEvents != nil) {
                completion(arrayEvents: arrayEvents!, nextPage: nextPage)
            } else if (errorResponse != nil) {
                OSPUserAlerts.showSimpleAlert("generic_title_problem".localized, withMessage: errorResponse!.message!, withAcceptButton: "ok".localized)
                completion(arrayEvents: NSMutableArray(), nextPage: nil)
            } else {
                OSPUserAlerts.showSimpleAlert("generic_title_problem".localized, withMessage: "server_error".localized, withAcceptButton: "ok".localized)
                completion(arrayEvents: NSMutableArray(), nextPage: nil)
            }
        }
    }
    
    class func listAllEventsWithCompletion(completion : (arrayEvents : NSMutableArray?, nextPage : String?) -> Void) {
        
        listEventsWithKeyword("") { (arrayEvents, nextPage) in
            completion(arrayEvents: arrayEvents, nextPage: nextPage)
        }
    }
}