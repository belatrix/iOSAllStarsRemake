    //
//  ProfileViewController.swift
//  AllStars
//
//  Created by Kenyi Rodriguez Vergara on 5/05/16.
//  Copyright © 2016 Belatrix SF. All rights reserved.
//

import UIKit
import CoreSpotlight
import MobileCoreServices

class ProfileViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var viewHeader               : UIView!
    @IBOutlet weak var viewBody                 : UIView!
    @IBOutlet weak var imgProfile               : UIImageView! {
        
        didSet{
            if isViewLoaded() {
                
                print("DidSet imgProfile")
            }
        }
    }
    @IBOutlet weak var btnSkills                : UIButton!
    @IBOutlet weak var lblNameUser              : UILabel!
    @IBOutlet weak var lblMail                  : UILabel!
    @IBOutlet weak var lblSkype                 : UILabel!
    @IBOutlet weak var lblLocation              : UILabel!
    @IBOutlet weak var scrollContent            : UIScrollView!
    @IBOutlet var scoreViews                    : [UIView]!
    @IBOutlet weak var lblMothScore             : UILabel!
    @IBOutlet weak var lblScore                 : UILabel!
    @IBOutlet weak var lblLevel                 : UILabel!
    @IBOutlet weak var clvCategories            : UICollectionView!
    @IBOutlet weak var viewLoading              : UIView!
    @IBOutlet weak var lblErrorMessage          : UILabel!
    @IBOutlet weak var actCategories            : UIActivityIndicatorView!
    @IBOutlet weak var constraintHeightContent  : NSLayoutConstraint!
    @IBOutlet weak var btnAction                : UIButton?
    @IBOutlet weak var btnBack                  : UIButton!
    @IBOutlet weak var viewUserPhoto            : UIView!
    
    var objUser : User?
    var backEnable : Bool?
    var arrayCategories = NSMutableArray()
    
    // MARK: - Initialization
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setViews()
        
        if self.objUser == nil {
            self.objUser = LogInBC.getCurrenteUserSession()
        }
        
        self.btnSkills.setTitle("Skills", forState: .Normal)
        
        if (ProfileBC.validateUser(self.objUser, isEqualToUser: LogInBC.getCurrenteUserSession())) {
            self.btnAction?.setTitle("Edit", forState: .Normal)
            
            registerUserDevice()
        } else {
            self.btnAction?.setTitle("Recommend", forState: .Normal)
        }
        
        if backEnable != nil {
            
            self.btnBack.hidden = false
        } else {

            self.btnBack.hidden = true
        }
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(ProfileViewController.tapProfileImage))
        
        self.imgProfile.userInteractionEnabled = true
        self.imgProfile.addGestureRecognizer(tapGesture)
        
        
    }

    override func viewWillAppear(animated: Bool) {
        if self.objUser != nil {
            self.updateUserInfo()
        }
        
        super.viewWillAppear(animated)        
        
        UIApplication.sharedApplication().statusBarStyle = UIStatusBarStyle.LightContent
        
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        
        if let nav = self.navigationController where nav.viewControllers.count > 1 {
            
            self.btnBack.hidden = false
        } else {
            
            self.btnBack.hidden = true
        }
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        if let rootVC = self.navigationController?.viewControllers.first where
            rootVC == self.tabBarController?.moreNavigationController.viewControllers.first  {
            
            self.navigationController?.setNavigationBarHidden(false, animated: false)
        }
    }
    
    // MARK: - Style
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
    }
    
    // MARK: - UI
    func setViews() {
        self.scrollContent.addSubview(self.refreshControl)
        OSPCrop.makeRoundView(self.imgProfile)
        
        self.view.backgroundColor = UIColor.colorPrimary()
        
        for view in self.scoreViews{
            view.layer.borderWidth = 1
            view.layer.borderColor = UIColor.score().CGColor
        }
        
        viewHeader.backgroundColor = UIColor.colorPrimary()
    }
    
    lazy var refreshControl : UIRefreshControl = {
        let _refreshControl = UIRefreshControl()
        _refreshControl.backgroundColor = .clearColor()
        _refreshControl.tintColor = .whiteColor()
        _refreshControl.addTarget(self, action: #selector(ProfileViewController.updateUserInfo), forControlEvents: .ValueChanged)
        
        return _refreshControl
    }()
    
    // MARK: - IBActions
    @IBAction func btnActionProfileTUI(sender: UIButton) {
        if (ProfileBC.validateUser(self.objUser, isEqualToUser: LogInBC.getCurrenteUserSession())) {
            self.performSegueWithIdentifier("EditProfileViewController", sender: objUser)
        } else {
            self.performSegueWithIdentifier("RecommendViewController", sender: objUser)
        }
    }
    
    @IBAction func clickBtnBack(sender: AnyObject) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    @IBAction func btnLogoutTUI(sender: UIButton) {
        SessionUD.sharedInstance.clearSession()
        
        let storyBoard : UIStoryboard = UIStoryboard(name: "LogIn", bundle:nil)
        let logInViewController = storyBoard.instantiateViewControllerWithIdentifier("LogInViewController") as! LogInViewController
        self.presentViewController(logInViewController, animated: true, completion: nil)
    }
    
    func tapProfileImage() {
        
        var newFrame = self.viewHeader.frame
        
        newFrame.size.height = 64.0
        self.view.backgroundColor = UIColor.whiteColor()
        
        UIView.animateWithDuration(0.5, delay: 0.0,
                                   options: [], animations: {
                                    
                                    self.viewUserPhoto.transform = CGAffineTransformMakeScale(3.2, 3.2)
                                    self.viewUserPhoto.center = self.view.center
                                    self.viewHeader.frame = newFrame
                                    self.viewBody.alpha = 0.0
        }) { (success) in
            
            newFrame.size.height = 114.0
            self.viewHeader.frame = newFrame
            self.view.backgroundColor = UIColor.colorPrimary()
            
            self.viewUserPhoto.transform = CGAffineTransformMakeScale(1.0, 1.0)
            self.viewUserPhoto.center = CGPointMake(self.view.center.x, self.viewHeader.frame.maxY)
            
            self.imgProfile.transform = CGAffineTransformMakeScale(1.0, 1.0)
            self.imgProfile.center = CGPointMake(self.viewUserPhoto.frame.size.width/2, self.viewUserPhoto.frame.size.height/2)
            
            self.viewBody.alpha = 1.0
        }
        
        self.performSelector(#selector(showUserImageViewController), withObject: nil, afterDelay: 0.5)
    }
    
    // MARK: - UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.arrayCategories.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cellIdentifier = "StarSubCategoriesCollectionViewCell"
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(cellIdentifier, forIndexPath: indexPath) as! StarSubCategoriesCollectionViewCell
        
        cell.objSubCategory = self.arrayCategories[indexPath.row] as! StarSubCategoryBE
        cell.updateData()
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        self.performSegueWithIdentifier("StarsCategoriesUserViewController", sender: self.arrayCategories[indexPath.row])
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize{
        
        return CGSizeMake(UIScreen.mainScreen().bounds.size.width, 36)
    }
    
    // MARK: - WebServices
    func listSubCategories() -> Void {
        
        self.actCategories.startAnimating()
        
        ProfileBC.listStarSubCategoriesToUser(self.objUser!) { (arrayCategories) in
            
            self.actCategories.stopAnimating()
            
            self.arrayCategories = arrayCategories!
            
            self.lblErrorMessage.text = "Categories no availables"
            self.viewLoading.alpha = CGFloat(!Bool(self.arrayCategories.count))
            
            let height = Int(self.scrollContent.bounds.size.height) - 113
            let newHeight = Int(self.clvCategories.frame.origin.y) + self.arrayCategories.count * 36
            
            self.constraintHeightContent.constant = newHeight > height ? CGFloat(newHeight) : CGFloat(height)
            
            self.clvCategories.reloadData()
        }
    }
    
    // MARK: - Configuration
    func updateDataUser() -> Void {
        
        self.lblNameUser.text   = "\(self.objUser!.user_first_name!) \(self.objUser!.user_last_name!)"
        
        if let mail = self.objUser!.user_email {
            self.lblMail.text = mail
        }
        
        if let skype = self.objUser!.user_skype_id {
            self.lblSkype.text = "Skype: \(skype)"
        }
        
        if let location = self.objUser!.user_location_name {
            self.lblLocation.text = "Location: \(location)"
        }
        
        if let monthScore = self.objUser!.user_current_month_score {
            self.lblMothScore.text = "\(monthScore)"
        }
        
        if let score = self.objUser!.user_total_score {
            self.lblScore.text = "\(score)"
        }
        
        if let level = self.objUser!.user_level {
            self.lblLevel.text = "\(level)"
        }
        
        if let url_photo = self.objUser?.user_avatar{
            if (url_photo != "") {
                OSPImageDownloaded.descargarImagenEnURL(url_photo, paraImageView: self.imgProfile, conPlaceHolder: self.imgProfile.image)
            } else {
                self.imgProfile!.image = UIImage(named: "ic_user.png")
            }
        } else {
            self.imgProfile!.image = UIImage(named: "ic_user.png")
        }
    }
    
    func updateUserInfo() -> Void {
        self.updateDataUser()
        
        ProfileBC.getInfoToUser(self.objUser!) { (user) in
            
            self.refreshControl.endRefreshing()
            
            if user != nil {
                self.objUser = user!
                self.updateDataUser()
            }
        }
        
        self.listSubCategories()
    }
    
    func registerUserDevice() -> Void {
        let userDev = UserDevice()
        userDev.user_id = self.objUser!.user_pk!
        userDev.user_ios_id = SessionUD.sharedInstance.getUserPushToken()
        
        LogInBC.registerUserDevice(userDev) { (userDevice) in
            
            if userDevice != nil {
                print(userDevice!.user_ios_id!)
            }
        }
    }
    
    func registerUserForSpotlight() {
        
        guard let user = self.objUser
            else { return }
        
        // It's recommended that you use reverse DNS notation for the required activity type property.
        let activity = NSUserActivity(activityType: "com.belatrix.belatrixconnect")
        
        activity.userInfo = ["userId" : user.user_pk!] as [NSObject : AnyObject]
        // Set properties that describe the activity and that can be used in search.
        activity.keywords = NSSet(objects: (user.user_first_name)!, (user.user_last_name)!, (user.user_email)!) as! Set<String>
        
        let attributeSet = CSSearchableItemAttributeSet(itemContentType: kUTTypeData as String)
        
        attributeSet.title = (user.user_first_name)! + " " + (user.user_last_name)!
        attributeSet.contentDescription = "Belatrix connect contact"
        attributeSet.thumbnailData = UIImageJPEGRepresentation(self.imgProfile.image!, 0.9)
        if let email = user.user_email {
            
            attributeSet.emailAddresses = [email]
        }
        
        activity.contentAttributeSet = attributeSet;
        
        
        // Add the item to the private on-device index.
        activity.eligibleForSearch = true;
        
        self.userActivity = activity;
    }
    
    // MARK: - Navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "StarsCategoriesUserViewController" {
            let controller = segue.destinationViewController as! StarsCategoriesUserViewController
            controller.objStarSubCategory = sender as! StarSubCategoryBE
            controller.objUser = self.objUser!
            
        } else if segue.identifier == "RecommendViewController" {
            
            let controller = segue.destinationViewController as! RecommendViewController
            controller.objUser = self.objUser
        } else if segue.identifier == "EditProfileViewController" {
            
            let controller = segue.destinationViewController as! EditProfileViewController
            controller.objUser = self.objUser
            controller.isNewUser = false
        } else if segue.identifier == "UserSkillsViewController" {
            
            let controller = segue.destinationViewController as! UserSkillsViewController
            controller.objUser = self.objUser
        }
    }
    
    func showUserImageViewController() {
        
        let storyboard = self.storyboard
        let userImageVC = storyboard?.instantiateViewControllerWithIdentifier("UserProfileImageViewController") as! UserProfileImageViewController
        
        userImageVC.userImage = self.imgProfile.image
        
        userImageVC.modalPresentationStyle = .PageSheet
        
        self.presentViewController(userImageVC, animated: false, completion: nil)
    }
}