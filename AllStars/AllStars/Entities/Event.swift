//
//  Event.swift
//  AllStars
//
//  Created by Flavio Franco Tunqui on 7/6/16.
//  Copyright © 2016 Belatrix SF. All rights reserved.
//

import UIKit

class Event: NSObject {
    var event_pk                    : NSNumber?
    var event_title                 : String?
    var event_description           : String?
    var event_datetime              : NSDate?
    var event_image                 : String?
    var event_location              : String?
    var event_is_registration_open  : Bool?
    var event_collaborators         : NSNumber?
    var event_participants          : NSNumber?
}