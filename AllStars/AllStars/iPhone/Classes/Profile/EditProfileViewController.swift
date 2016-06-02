//
//  EditProfileViewController.swift
//  AllStars
//
//  Created by Flavio Franco Tunqui on 6/2/16.
//  Copyright © 2016 Belatrix SF. All rights reserved.
//

import UIKit

class EditProfileViewController: UIViewController, UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var imgUser: UIImageView!
    @IBOutlet weak var edtFirstName: UITextField!
    @IBOutlet weak var edtLastName: UITextField!
    @IBOutlet weak var edtSkypeId: UITextField!
    @IBOutlet weak var tableLocations: UITableView!
    @IBOutlet weak var scrollContent: UIScrollView!
    @IBOutlet weak var constraintHeightContent: NSLayoutConstraint!
    @IBOutlet weak var viewLoading              : UIView!
    @IBOutlet weak var lblErrorMessage          : UILabel!
    @IBOutlet weak var activityLocations      : UIActivityIndicatorView!
    
    var objUser : User?
    var arrayLocations = NSMutableArray()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.updateUserInfo()
    }
    
    // MARK: - IBActions
    @IBAction func btnUploadPhotoTIU(sender: UIButton) {
        
    }
    
    @IBAction func btnCancelTUI(sender: UIButton) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func btnDoneTUI(sender: UIButton) {
        
    }
    
    // MARK: - UITableViewDelegate, UITableViewDataSource
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrayLocations.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cellIdentifier = "LocationTableViewCell"
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! LocationTableViewCell
        
//        cell.objStarKeywordBE = self.arrayTags[indexPath.row] as! StarKeywordBE
//        cell.updateData()
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
//        let cell = tableView.cellForRowAtIndexPath(indexPath)
//        cell?.setSelected(false, animated: true)
//        
//        let objBE = self.arrayTags[indexPath.row]
//        self.performSegueWithIdentifier("UserRankingTagViewController", sender: objBE)
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 36
    }
    
    // MARK: - WebServices
    func listLocations() -> Void {
        
        self.activityLocations.startAnimating()
        
        ProfileBC.listLocationsWithCompletion { (arrayLocations) in
            
            self.activityLocations.stopAnimating()
            
            self.arrayLocations = arrayLocations
            
            self.lblErrorMessage.text = "Locations no availables"
            self.viewLoading.alpha = CGFloat(!Bool(self.arrayLocations.count))
            
            let height = Int(self.scrollContent.bounds.size.height) - 113
            let newHeight = Int(self.tableLocations.frame.origin.y) + self.arrayLocations.count * 36
            
            self.constraintHeightContent.constant = newHeight > height ? CGFloat(newHeight) : CGFloat(height)
            
            self.tableLocations.reloadData()
        }
    }
    
    // MARK: - Configuration
    func updateDataUser() -> Void {
        
//        self.lblNameUser.text   = "\(self.objUser!.user_first_name!) \(self.objUser!.user_last_name!)"
//        
//        if let mail = self.objUser!.user_email {
//            self.lblMail.text = mail
//        }
//        
//        if let skype = self.objUser!.user_skype_id {
//            self.lblSkype.text = "Skype: \(skype)"
//        }
//        
//        if let location = self.objUser!.user_location_name {
//            self.lblLocation.text = "Location: \(location)"
//        }
//        
//        if let monthScore = self.objUser!.user_last_month_score {
//            self.lblMothScore.text = "\(monthScore)"
//        }
//        
//        if let score = self.objUser!.user_total_score {
//            self.lblScore.text = "\(score)"
//        }
//        
//        if let level = self.objUser!.user_level {
//            self.lblLevel.text = "\(level)"
//        }
//        
//        if let url_photo = self.objUser?.user_avatar{
//            if (url_photo != "") {
//                OSPImageDownloaded.descargarImagenEnURL(url_photo, paraImageView: self.imgProfile, conPlaceHolder: self.imgProfile.image)
//            } else {
//                self.imgProfile!.image = UIImage(named: "ic_user.png")
//            }
//        } else {
//            self.imgProfile!.image = UIImage(named: "ic_user.png")
//        }
    }
    
    func updateUserInfo() -> Void {
        self.updateDataUser()
        
        self.listLocations()
    }
    
    // MARK: - Style
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
    }
}