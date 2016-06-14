//
//  StarUserInfoTableViewCell.swift
//  AllStars
//
//  Created by Kenyi Rodriguez Vergara on 9/05/16.
//  Copyright © 2016 Belatrix SF. All rights reserved.
//

import UIKit


class StarUserInfoTableViewCell: UITableViewCell {

    
    @IBOutlet weak var imgAvatar        : UIImageView!
    @IBOutlet weak var lblCategory      : UILabel!
    @IBOutlet weak var lblFullName      : UILabel!
    @IBOutlet weak var lblDate          : UILabel!
    @IBOutlet weak var txtInfo          : UITextView!
    @IBOutlet weak var containerView    : UIView!
    @IBOutlet weak var btnKeyword       : UIButton!
    @IBOutlet weak var constraintKeyword: NSLayoutConstraint!
    
    var objUserQualify = UserQualifyBE()
    
    func updateData() -> Void {
        
        self.lblDate.text = OSPDateManager.convertirFecha(self.objUserQualify.userQualify_date, alFormato: "dd MMM yyyy HH:mm", locale: "en_US")
        self.lblFullName.text = "\(self.objUserQualify.userQualify_firstName!) \(self.objUserQualify.userQualify_lastName!)"
        self.lblCategory.text = self.objUserQualify.userQualify_categoryName!
        self.txtInfo.text = self.objUserQualify.userQualify_text!
        self.btnKeyword.setTitle("#\(self.objUserQualify.userQualify_keywordName!)", forState: .Normal)
        
        let maximumLabelSize = CGSizeMake(320, CGFloat.max)
        self.constraintKeyword.constant = self.btnKeyword.sizeThatFits(maximumLabelSize).width + 12
        
        if let url_photo = self.objUserQualify.userQualify_userAvatar {
            OSPImageDownloaded.descargarImagenEnURL(url_photo, paraImageView: self.imgAvatar, conPlaceHolder: nil) { (correct : Bool, nameImage : String!, image : UIImage!) in
                
                if nameImage == url_photo {
                    self.imgAvatar.image = image
                }
            }
        } else {
            self.imgAvatar.image = UIImage(named: "ic_user.png")
        }
    }
    
    override func drawRect(rect: CGRect) {
        
        OSPCrop.makeRoundView(self.imgAvatar)

        self.containerView.layer.cornerRadius = 4
        self.containerView.layer.borderWidth = 0.5
        self.containerView.layer.borderColor = UIColor(red: 200.0/255.0, green: 200.0/255.0, blue: 200.0/255.0, alpha: 1).CGColor
    }
    
    class func getHeightToCellWithTextDescription(description : String) -> CGFloat {
        
        let width = UIScreen.mainScreen().bounds.size.width - 24
        let font = UIFont(name: "HelveticaNeue-Thin", size: 13)
        let attributedText = NSAttributedString(string: description, attributes: [NSFontAttributeName : font!])
        let rect = attributedText.boundingRectWithSize(CGSizeMake(width, CGFloat.max), options: .UsesLineFragmentOrigin, context: nil)
        let size = rect.size
        return size.height + 95
    }
}