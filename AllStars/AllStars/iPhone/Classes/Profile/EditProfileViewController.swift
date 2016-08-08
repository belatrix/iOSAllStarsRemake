//
//  EditProfileViewController.swift
//  AllStars
//
//  Created by Flavio Franco Tunqui on 6/2/16.
//  Copyright © 2016 Belatrix SF. All rights reserved.
//

import UIKit

class EditProfileViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextViewDelegate {

    @IBOutlet weak var viewHeader               : UIView!
    @IBOutlet weak var imgUser                  : UIImageView!
    @IBOutlet weak var edtFirstName             : UITextField!
    @IBOutlet weak var edtLastName              : UITextField!
    @IBOutlet weak var edtSkypeId               : UITextField!
    @IBOutlet weak var tableLocations           : UITableView!
    @IBOutlet weak var scrollContent            : UIScrollView!
    @IBOutlet weak var constraintHeightContent  : NSLayoutConstraint!
    @IBOutlet weak var viewLoading              : UIView!
    @IBOutlet weak var lblErrorMessage          : UILabel!
    @IBOutlet weak var actUpdating              : UIActivityIndicatorView!
    @IBOutlet weak var actLocations             : UIActivityIndicatorView!
    @IBOutlet weak var btnCancel                : UIButton!
    @IBOutlet weak var btnUploadPhoto           : UIButton!
    @IBOutlet weak var viewFirstName            : UIView!
    @IBOutlet weak var viewLastName             : UIView!
    @IBOutlet weak var viewSkypeId              : UIView!

    // photo
    var imagePickerController = UIImagePickerController()
    var hasNewImage = false
    var selectedImage  = UIImage()
    
    var objUser : User?
    var arrayLocations = NSMutableArray()
    var isNewUser : Bool?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setViews()
        
        // imagePicker
        imagePickerController.delegate = self
        imagePickerController.allowsEditing = true
        
        self.updateUserInfo()
    }
    
    // MARK: - Style
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
    }
    
    // MARK: - UI
    func setViews() {
        if (isNewUser!) {
            btnCancel.hidden = true
        }
        
        OSPCrop.makeRoundView(self.imgUser)
        
        self.view.backgroundColor = UIColor.colorPrimary()
        viewHeader.backgroundColor = UIColor.colorPrimary()
        
        viewFirstName.backgroundColor = UIColor.colorPrimary()
        viewLastName.backgroundColor = UIColor.colorPrimary()
        viewSkypeId.backgroundColor = UIColor.colorPrimary()
        
        btnUploadPhoto.backgroundColor = UIColor.belatrix()
    }
    
    func lockScreen() {
        self.view.userInteractionEnabled = false
        self.actUpdating.startAnimating()
    }
    
    func unlockScreen() {
        self.view.userInteractionEnabled = true
        self.actUpdating.stopAnimating()
    }
    
    // MARK: - IBActions
    @IBAction func btnUploadPhotoTIU(sender: UIButton) {
        self.view.endEditing(true)
        
        let alert: UIAlertController = UIAlertController(title: "upload_from".localized, message: nil, preferredStyle: .ActionSheet)
        
        let cameraAction = UIAlertAction(title: "camera".localized, style: .Default,
                                         handler: {(alert: UIAlertAction) in
                                            
                                            self.imagePickerController.sourceType = .Camera
                                            self.presentViewController(self.imagePickerController, animated: true, completion: { imageP in })
                                        })
        
        let galleryAction = UIAlertAction(title: "gallery".localized, style: .Default,
                                         handler: {(alert: UIAlertAction) in
                                            
                                            self.imagePickerController.sourceType = .SavedPhotosAlbum
                                            self.presentViewController(self.imagePickerController, animated: true, completion: { imageP in })
                                            })
        
        let cancelAction = UIAlertAction(title: "Cancel".localized, style: .Cancel,
                                          handler: nil)
        
        alert.addAction(cameraAction)
        alert.addAction(galleryAction)
        alert.addAction(cancelAction)
        
        self.presentViewController(alert, animated: true, completion: {})
    }
    
    @IBAction func btnCancelTUI(sender: UIButton) {
        self.view.endEditing(true)
        
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func btnDoneTUI(sender: UIButton) {
        self.view.endEditing(true)
        
        updateDataUser()
    }
    
    @IBAction func textFieldVCh(sender: UITextField) {
        if (sender == edtFirstName) {
            objUser!.user_first_name = edtFirstName.text
        } else if (sender == edtLastName) {
            objUser!.user_last_name = edtLastName.text
        } else if (sender == edtSkypeId) {
            objUser!.user_skype_id = edtSkypeId.text
        }
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
        
        let locationBE = self.arrayLocations[indexPath.row] as! LocationBE
        
        cell.objLocationBE = locationBE
        cell.updateData()
        
        if (locationBE.location_pk == objUser!.user_location_id) {
            cell.accessoryType = .Checkmark
        } else {
            cell.accessoryType = .None
        }
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let locationBE = self.arrayLocations[indexPath.row] as! LocationBE
        
        objUser!.user_location_id = locationBE.location_pk
        
        tableView.reloadData()
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 36
    }
    
    
    // MARK: - UIImagePickerController delegates
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        if let pickedImage = info[UIImagePickerControllerEditedImage] as? UIImage {
            hasNewImage = true
            
            selectedImage = pickedImage
            
            self.imgUser.image = selectedImage
        } else {
            hasNewImage = false
        }
        
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    // MARK: - WebServices
    func listLocations() -> Void {
        
        self.actLocations.startAnimating()
        
        ProfileBC.listLocations {(arrayLocations) in
            
            self.actLocations.stopAnimating()
            
            self.arrayLocations = arrayLocations!
            
            self.lblErrorMessage.text = "no_availables_locations".localized
            self.viewLoading.alpha = CGFloat(!Bool(self.arrayLocations.count))
            
            let height = Int(self.scrollContent.bounds.size.height) - 113
            let newHeight = Int(self.tableLocations.frame.origin.y) + self.arrayLocations.count * 36
            self.constraintHeightContent.constant = newHeight > height ? CGFloat(newHeight) : CGFloat(height)
            
            self.tableLocations.reloadData()
        }
    }
    
    func updateDataUser() -> Void {
        ProfileBC.updateInfoToUser(objUser!, newUser: isNewUser!, hasImage: hasNewImage, withController: self, withCompletion: {(user) in
            
            self.view.userInteractionEnabled = true
            self.actUpdating.stopAnimating()
            
            if (user != nil) {
                if (self.hasNewImage) {
                    self.updatePhotoUser()
                } else {
                    if (user!.user_base_profile_complete!) {
                        if (self.isNewUser!) {
                            self.openTabBar()
                        } else {
                            self.dismissViewControllerAnimated(true, completion: nil)
                        }
                    }
                }
            }
        })
    }
    
    func updatePhotoUser() -> Void {
        
        lockScreen()

        let imageData = UIImageJPEGRepresentation(selectedImage, 0.5)
        
        ProfileBC.updatePhotoToUser(objUser!, withController: self, withImage: imageData!, withCompletion: {(user) in
            
            self.unlockScreen()
            
             if (user != nil) {
                if (user!.user_base_profile_complete!) {
                    if (self.isNewUser!) {
                        self.openTabBar()
                    } else {
                        self.dismissViewControllerAnimated(true, completion: nil)
                    }
                }
            }
        })
    }

    // MARK: - Other
    func openTabBar() {
        
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    
        appDelegate.login()
        appDelegate.addShortcutItems()
    }
    
    // MARK: - Configuration
    func updateDataUserUI() -> Void {
        
        if let firstName = self.objUser?.user_first_name {
            edtFirstName.text = firstName
        }
        
        if let lastName = self.objUser?.user_last_name {
            edtLastName.text = lastName
        }
        
        if let skypeId = self.objUser?.user_skype_id {
            edtSkypeId.text = skypeId
        }
        
        if let url_photo = self.objUser?.user_avatar{
            if (url_photo != "") {
                OSPImageDownloaded.descargarImagenEnURL(url_photo, paraImageView: self.imgUser, conPlaceHolder: self.imgUser.image)
            } else {
                self.imgUser!.image = UIImage(named: "ic_user.png")
            }
        } else {
            self.imgUser!.image = UIImage(named: "ic_user.png")
        }
    }
    
    func updateUserInfo() -> Void {
        self.updateDataUserUI()
        
        self.listLocations()
    }
    
    // MARK: - UITextField delegates
    func textFieldShouldReturn(textField: UITextField!) -> Bool {
        if (textField == edtFirstName) {
            edtLastName.becomeFirstResponder()
        } else if (textField == edtLastName) {
            edtSkypeId.becomeFirstResponder()
        }
        
        textField.resignFirstResponder()
        return true
    }
    
    // MARK: - Navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "SkillsViewController" {
            
            let skillsNC = segue.destinationViewController as! UINavigationController
            let skillsVC = skillsNC.topViewController as! UserSkillsViewController
            
            skillsVC.objUser = self.objUser!
        }
        
    }
}