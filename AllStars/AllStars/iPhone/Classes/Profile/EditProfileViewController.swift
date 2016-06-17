//
//  EditProfileViewController.swift
//  AllStars
//
//  Created by Flavio Franco Tunqui on 6/2/16.
//  Copyright © 2016 Belatrix SF. All rights reserved.
//

import UIKit

class EditProfileViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextViewDelegate {

    @IBOutlet weak var imgUser                  : UIImageView!
    @IBOutlet weak var edtFirstName             : UITextField!
    @IBOutlet weak var edtLastName              : UITextField!
    @IBOutlet weak var edtSkypeId               : UITextField!
    @IBOutlet weak var tableLocations           : UITableView!
    @IBOutlet weak var scrollContent            : UIScrollView!
    @IBOutlet weak var constraintHeightContent  : NSLayoutConstraint!
    @IBOutlet weak var viewLoading              : UIView!
    @IBOutlet weak var lblErrorMessage          : UILabel!
    @IBOutlet weak var activityLocations        : UIActivityIndicatorView!
    @IBOutlet weak var activityUpdating         : UIActivityIndicatorView!
    @IBOutlet weak var btnCancel                : UIButton!

    // photo
    var imagePickerController = UIImagePickerController()
    var hasNewImage = false
    var selectedImage  = UIImage()
    
    var objUser : User?
    var arrayLocations = NSMutableArray()
    var isNewUser : Bool?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        OSPCrop.makeRoundView(self.imgUser)
        
        // imagePicker
        imagePickerController.delegate = self
        imagePickerController.allowsEditing = true
        
        if (isNewUser!) {
            btnCancel.hidden = true
        }
        
        self.updateUserInfo()
    }
    
    // MARK: - IBActions
    @IBAction func btnUploadPhotoTIU(sender: UIButton) {
        self.view.endEditing(true)
        
        let actionSheet = UIActionSheet(title: "Upload from", delegate: self, cancelButtonTitle: "cancel".localized, destructiveButtonTitle: nil, otherButtonTitles: "camera".localized, "gallery".localized)
        actionSheet.showInView(self.view)
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
    
    // MARK: - UIActionSheetDelegate
    func actionSheet(actionSheet: UIActionSheet, clickedButtonAtIndex buttonIndex: Int) {
        switch buttonIndex{
        case 0:
            break
        case 1:
            imagePickerController.sourceType = UIImagePickerControllerSourceType.Camera
            self.presentViewController(imagePickerController, animated: true, completion: { imageP in })
            break
        case 2:
            imagePickerController.sourceType = UIImagePickerControllerSourceType.SavedPhotosAlbum
            self.presentViewController(imagePickerController, animated: true, completion: { imageP in })
            break
        default:
            break
        }
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
        
        self.activityLocations.startAnimating()
        
        ProfileBC.listLocationsWithCompletion { (arrayLocations) in
            
            self.activityLocations.stopAnimating()
            
            self.arrayLocations = arrayLocations
            
            self.lblErrorMessage.text = "no_availables_locations".localized
            self.viewLoading.alpha = CGFloat(!Bool(self.arrayLocations.count))
            
            let height = Int(self.scrollContent.bounds.size.height) - 113
            let newHeight = Int(self.tableLocations.frame.origin.y) + self.arrayLocations.count * 36
            
            self.constraintHeightContent.constant = newHeight > height ? CGFloat(newHeight) : CGFloat(height)
            
            self.tableLocations.reloadData()
        }
    }
    
    func updateDataUser() -> Void {
        self.view.userInteractionEnabled = false
        self.activityUpdating.startAnimating()
        
        ProfileBC.updateInfoToUser(objUser!, newUser: isNewUser!, hasImage: hasNewImage, withController: self, withCompletion: {(user) in
            
            self.view.userInteractionEnabled = true
            self.activityUpdating.stopAnimating()
            
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
        self.view.userInteractionEnabled = false
        self.activityUpdating.startAnimating()

        let imageData = UIImageJPEGRepresentation(selectedImage, 0.5)
        
        ProfileBC.updatePhotoToUser(objUser!, withController: self, withImage: imageData!, withCompletion: {(user) in
            
            self.view.userInteractionEnabled = true
            self.activityUpdating.stopAnimating()
            
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
    
    func openTabBar() {
        let storyBoard : UIStoryboard = UIStoryboard(name: "TabBar", bundle:nil)
        let customTabBarViewController = storyBoard.instantiateViewControllerWithIdentifier("CustomTabBarViewController") as! CustomTabBarViewController
        let nav : UINavigationController = UINavigationController.init(rootViewController: customTabBarViewController)
        nav.navigationBarHidden = true
        self.presentViewController(nav, animated: true, completion: nil)
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
    
    // MARK: - Style
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
    }
}