//
//  EmployeeTableViewCell.swift
//  AllStars
//
//  Created by Kenyi Rodriguez Vergara on 10/05/16.
//  Copyright © 2016 Belatrix SF. All rights reserved.
//

import UIKit

class EmployeeTableViewCell: UITableViewCell {

    @IBOutlet weak var imgAvatar    : UIImageView?
    @IBOutlet weak var lblFullName  : UILabel?
    @IBOutlet weak var lblUserName  : UILabel?
    
    var objUserEmployee = User()
    
    
    
    override func drawRect(rect: CGRect) {
        
        OSPCrop.makeRoundView(self.imgAvatar!)
    }
    
    func updateData() -> Void {
        
        self.lblFullName?.text = "\(self.objUserEmployee.user_first_name!) \(self.objUserEmployee.user_last_name!)"
        self.lblUserName?.text = "\(self.objUserEmployee.user_username!)"
        
        OSPImageDownloaded.descargarImagenEnURL(self.objUserEmployee.user_avatar!, paraImageView: self.imgAvatar, conPlaceHolder: nil) { (correct : Bool, nameImage : String!, image : UIImage!) in
            
            if nameImage == self.objUserEmployee.user_avatar!{
                self.imgAvatar?.image = image
            }
        }
    }

}
