//
//  UserRankingTableViewCell.swift
//  AllStars
//
//  Created by Kenyi Rodriguez Vergara on 13/05/16.
//  Copyright © 2016 Belatrix SF. All rights reserved.
//

import UIKit

class UserRankingTableViewCell: UITableViewCell {

    @IBOutlet weak var lblScore     : UILabel!
    @IBOutlet weak var imgAvatar    : UIImageView!
    @IBOutlet weak var lblName      : UILabel!
    @IBOutlet weak var imgCup       : UIImageView!
    
    
    var objUser = UserRankingBE()
    var indexPath : NSIndexPath?
    
    
    func updateData() -> Void {
        
        self.lblName.text = "\(self.objUser.userRanking_firstName!) \(self.objUser.userRanking_lastName!)"
        self.lblScore.text = "\(self.objUser.userRanking_value!)"
        
        if let url_photo = self.objUser.userRanking_avatar {
            OSPImageDownloaded.descargarImagenEnURL(url_photo, paraImageView: self.imgAvatar, conPlaceHolder: nil)
        } else {
            self.imgAvatar.image = UIImage(named: "ic_user.png")
        }
        
        let idCup = self.indexPath?.row > 2 ? 3 : self.indexPath?.row
        self.imgCup.image = UIImage(named: "iconCup_\(idCup!).png")
    }
    
    
    override func drawRect(rect: CGRect) {
        
        OSPCrop.makeRoundView(self.imgAvatar)
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
