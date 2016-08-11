//
//  UserProfileImageViewController.swift
//  AllStars
//
//  Created by Ricardo Hernan Herrera Valle on 8/10/16.
//  Copyright © 2016 Belatrix SF. All rights reserved.
//

import Foundation

class UserProfileImageViewController: UIViewController, UIScrollViewDelegate {
    
    @IBOutlet weak var btnBack                  : UIButton!
    @IBOutlet weak var userImageView            : UIImageView!
    @IBOutlet weak var viewHeader               : UIView!
    
    // MARK: - Properties
    var userImage: UIImage! {
        
        didSet {
            
            if self.isViewLoaded() {
                self.userImageView.image = userImage
            }
        }
    }
    
    // MARK: - Initializaion
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setViewsStyle()
        self.userImageView.image = userImage
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(UserProfileImageViewController.clickBtnBack(_:)))
        
        self.userImageView.userInteractionEnabled = true
        self.userImageView.addGestureRecognizer(tapGesture)
    }
    
    // MARK: - UI
    func setViewsStyle() {
        
        viewHeader.backgroundColor = UIColor.colorPrimary()
    }
    
    // MARK: - User interaction
    @IBAction func clickBtnBack(sender: AnyObject) {
        
        var newFrame = self.viewHeader.frame
        
        newFrame.size.height = 114.0
        
        UIView.animateWithDuration(0.5, delay: 0.0,
                                   options: [], animations: {
                                    
                                    self.userImageView.frame.size = CGSizeMake(120.0, 120.0)
                                    self.userImageView.center = CGPointMake(self.view.center.x, 70.0)
                                    self.viewHeader.frame = newFrame
        }) { (success) in
            self.userImageView.layer.cornerRadius = 60.0
            self.dismissViewController()
        }
    }
    
    // MARK: - Navigation
    func dismissViewController() {
        
        self.dismissViewControllerAnimated(false, completion: nil)
    }
    
    // MARK: - UIScrollViewDelegate
    func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
        return self.userImageView
    }
}
