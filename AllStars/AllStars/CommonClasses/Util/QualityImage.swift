//
//  QualityImage.swift
//  API-PayMe
//
//  Created by Flavio Franco Tunqui on 2/21/16.
//  Copyright © 2016 Solera. All rights reserved.
//

import UIKit

extension UIImage {
    var highestQualityJPEGNSData:NSData { return UIImageJPEGRepresentation(self, 1.0)! }
    var highQualityJPEGNSData:NSData    { return UIImageJPEGRepresentation(self, 0.75)! }
    var mediumQualityJPEGNSData:NSData  { return UIImageJPEGRepresentation(self, 0.5)! }
    var lowQualityJPEGNSData:NSData     { return UIImageJPEGRepresentation(self, 0.25)! }
    var lowestQualityJPEGNSData:NSData  { return UIImageJPEGRepresentation(self, 0.0)! }
}