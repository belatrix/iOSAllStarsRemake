//
//  UserRankingTagTableViewCell.swift
//  AllStars
//
//  Created by Flavio Franco Tunqui on 6/1/16.
//  Copyright © 2016 Belatrix SF. All rights reserved.
//

import UIKit

class UserRankingTagTableViewCell: UITableViewCell {

    @IBOutlet weak var imgAvatar    : UIImageView?
    @IBOutlet weak var lblFullName  : UILabel?
    @IBOutlet weak var lblLevel  : UILabel?
    @IBOutlet weak var lblNumberStars  : UILabel?
    
    var objUserEmployee = UserTagBE()
    
    override func drawRect(rect: CGRect) {
        
        OSPCrop.makeRoundView(self.imgAvatar!)
    }
    
    func updateData() -> Void {
        
        self.lblFullName?.text = "\(self.objUserEmployee.user_first_name!) \(self.objUserEmployee.user_last_name!)"
        self.lblLevel?.text = "Lvl. \(self.objUserEmployee.user_level!)"
        self.lblNumberStars?.text = "\(self.objUserEmployee.user_num_stars!)"
        
        if let url_photo = self.objUserEmployee.user_avatar{
            if (url_photo != "") {
                OSPImageDownloaded.descargarImagenEnURL(url_photo, paraImageView: self.imgAvatar, conPlaceHolder: nil) { (correct : Bool, nameImage : String!, image : UIImage!) in
                    
                    if nameImage == url_photo {
                        self.imgAvatar?.image = image
                    }
                }
            } else {
                self.imgAvatar!.image = UIImage(named: "ic_user.png")
            }
        } else {
            self.imgAvatar!.image = UIImage(named: "ic_user.png")
        }
    }
}