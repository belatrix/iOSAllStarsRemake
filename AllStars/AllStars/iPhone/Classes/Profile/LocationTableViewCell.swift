//
//  LocationTableViewCell.swift
//  AllStars
//
//  Created by Flavio Franco Tunqui on 6/2/16.
//  Copyright © 2016 Belatrix SF. All rights reserved.
//

import UIKit

class LocationTableViewCell: UITableViewCell {

    @IBOutlet weak var lblLocationName: UILabel!
    
    var objLocationBE = LocationBE()
    
    func updateData() -> Void {
        
        self.lblLocationName?.text = self.objLocationBE.location_name!
    }
}