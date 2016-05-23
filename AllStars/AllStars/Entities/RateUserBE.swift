//
//  RateUserBE.swift
//  AllStars
//
//  Created by Kenyi Rodriguez Vergara on 12/05/16.
//  Copyright © 2016 Belatrix SF. All rights reserved.
//

import UIKit

class RateUserBE: NSObject {

    var rate_fromUser       : User?
    var rate_toUser         : User?
    var rate_category       : CategoryBE?
    var rate_subCategory    : SubCategoryBE?
    var rate_keyword        : KeywordBE?
    var rate_comment        : String = ""
}
