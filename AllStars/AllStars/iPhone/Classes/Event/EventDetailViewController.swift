//
//  EventDetailViewController.swift
//  AllStars
//
//  Created by Ricardo Hernan Herrera Valle on 7/19/16.
//  Copyright © 2016 Belatrix SF. All rights reserved.
//

import Foundation

class EventDetailViewController: UIViewController {
    
    // MARK: - Variables
    @IBOutlet weak var eventTitleLabel: UILabel!
    @IBOutlet weak var eventImage: UIImageView!
    @IBOutlet weak var eventDateLabel: UILabel!
    @IBOutlet weak var eventLocationLabel: UILabel!
    @IBOutlet weak var eventDescriptionTextView: UITextView!
    
    // MARK: - Public variables
    var event: Event! {
        
        didSet{
            if self.isViewLoaded() {
                
                self.fillUI()
            }
        }
    }
    
    // MARK: - Initializaton
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let _ = event
            else { return }
        
        fillUI()
        
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    // MARK: - Style
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
    }
    
    // MARK: - UI
    func fillUI() {
        
        self.eventTitleLabel.text = self.event.event_title!
        
        if let datetime = self.event.event_datetime {
            self.eventDateLabel.text = OSPDateManager.convertirFecha(datetime, alFormato: "dd MMM yyyy HH:mm", locale: "en_US")
        } else {
            self.eventDateLabel.text = "No date"
        }
        
        if let location = self.event.event_location where location != "" {
            
            self.eventLocationLabel.text = location
        } else {
            
            self.eventLocationLabel.text = "---"
        }
        
        if let desc = self.event.event_location where desc != "" {
            
            self.eventDescriptionTextView.text = desc
        }
        
        if (self.event.event_image! != "") {
            OSPImageDownloaded.descargarImagenEnURL(self.event.event_image!,
                                                    paraImageView: self.eventImage,
                                                    conPlaceHolder: UIImage(named: "placeholder_general.png"))
            { (correct : Bool, nameImage : String!, image : UIImage!) in
                
                if nameImage == self.event.event_image! {
                    self.eventImage.image = image
                }
            }
        } else {
            self.eventImage.image = UIImage(named: "placeholder_general.png")
        }
    }
    
    // MARK: - UserInteraction
    
    @IBAction func goBack(sender: AnyObject) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
}