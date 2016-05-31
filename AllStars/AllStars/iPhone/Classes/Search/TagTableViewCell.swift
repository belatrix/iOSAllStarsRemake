//
//  TagTableViewCell.swift
//  AllStars
//
//  Created by Flavio Franco Tunqui on 5/31/16.
//  Copyright © 2016 Belatrix SF. All rights reserved.
//

import UIKit

class TagTableViewCell: UITableViewCell {

    @IBOutlet weak var lblNameTag: UILabel!
    
    var objStarKeywordBE = StarKeywordBE()

    func updateData() -> Void {
        
        self.lblNameTag?.text = self.objStarKeywordBE.keyword_name!
    }
}