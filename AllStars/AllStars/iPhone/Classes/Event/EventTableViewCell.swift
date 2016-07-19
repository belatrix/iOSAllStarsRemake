//
//  EventTableViewCell.swift
//  AllStars
//
//  Created by Flavio Franco Tunqui on 7/6/16.
//  Copyright © 2016 Belatrix SF. All rights reserved.
//

import UIKit

class EventTableViewCell: UITableViewCell {
    
    @IBOutlet weak var lblTitle         : UILabel!
    @IBOutlet weak var lblDate          : UILabel!
    @IBOutlet weak var lblLocation     : UILabel!
    @IBOutlet weak var lblDescription   : UILabel!
    @IBOutlet weak var imgEvent         : UIImageView!
    @IBOutlet weak var containerView    : UIView!

    var objEvent = Event()
    
    func updateData() -> Void {
        
        self.lblTitle.text = self.objEvent.event_title!
        
        if let datetime = self.objEvent.event_datetime {
            self.lblDate.text = OSPDateManager.convertirFecha(datetime, alFormato: "dd MMM yyyy HH:mm", locale: "en_US")
        } else {
            self.lblDate.text = "No date"
        }
        
        if let location = self.objEvent.event_location where location != "" {
            
            self.lblLocation.text = location
        } else {
            
            self.lblLocation.text = "---"
        }
        
        if let desc = self.objEvent.event_location where desc != "" {
            
            self.lblDescription.text = desc
        } else {
            
            self.lblDescription.text = "---"
        }
        
        if (self.objEvent.event_image! != "") {
            OSPImageDownloaded.descargarImagenEnURL(self.objEvent.event_image!, paraImageView: self.imgEvent, conPlaceHolder: nil) { (correct : Bool, nameImage : String!, image : UIImage!) in
                
                if nameImage == self.objEvent.event_image! {
                    self.imgEvent.image = image
                }
            }
        } else {
            self.imgEvent.image = UIImage(named: "placeholder_general.png")
        }
    }
}