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
        let attributeStars = [NSForegroundColorAttributeName : UIColor(colorLiteralRed: 255.0/255.0, green: 157.0/255.0, blue: 12.0/255.0, alpha: 1).CGColor]
        
        let atributteStringName = NSMutableAttributedString(string: "\(self.objSubCategory.starSubCategoy_name!)  ", attributes: attributeName)
        let atributteStringStars = NSMutableAttributedString(string: "\(self.objSubCategory.starSubCategoy_numStars!)  ", attributes: attributeStars)
        atributteStringName.appendAttributedString(atributteStringStars)
        
        self.title.attributedText = atributteStringName
        
    }
}
