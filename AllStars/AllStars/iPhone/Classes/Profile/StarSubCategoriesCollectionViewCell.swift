//
//  StarSubCategoriesCollectionViewCell.swift
//  AllStars
//
//  Created by Kenyi Rodriguez Vergara on 6/05/16.
//  Copyright © 2016 Belatrix SF. All rights reserved.
//

import UIKit

class StarSubCategoriesCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var title      : UILabel!
    
    var objSubCategory = StarSubCategoryBE()
    
    func updateData() -> Void {
        
        let attributeName = [NSForegroundColorAttributeName : UIColor.darkGrayColor()]
        let attributeStars = [NSForegroundColorAttributeName : UIColor.belatrix().CGColor]
        
        let atributteStringName = NSMutableAttributedString(string: "\(self.objSubCategory.starSubCategoy_name!)  ", attributes: attributeName)
        let atributteStringStars = NSMutableAttributedString(string: "\(self.objSubCategory.starSubCategoy_numStars!)  ", attributes: attributeStars)
        atributteStringName.appendAttributedString(atributteStringStars)
        
        self.title.attributedText = atributteStringName
    }
}