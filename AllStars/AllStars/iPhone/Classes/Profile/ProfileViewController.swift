//
//  ProfileViewController.swift
//  AllStars
//
//  Created by Kenyi Rodriguez Vergara on 5/05/16.
//  Copyright © 2016 Belatrix SF. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    @IBOutlet weak var imgProfile               : UIImageView!
    @IBOutlet weak var lblNameUser              : UILabel!
    @IBOutlet weak var lblSkype                 : UILabel!
    @IBOutlet weak var scrollContent            : UIScrollView!
    @IBOutlet var scoreViews                    : [UIView]!
    @IBOutlet weak var lblMothScore             : UILabel!
    @IBOutlet weak var lblScore                 : UILabel!
    @IBOutlet weak var lblLevel                 : UILabel!
    @IBOutlet weak var clvCategories            : UICollectionView!
    @IBOutlet weak var viewLoading              : UIView!
    @IBOutlet weak var lblErrorMessage          : UILabel!
    @IBOutlet weak var acitivityCategories      : UIActivityIndicatorView!
    @IBOutlet weak var constraintHeightContent  : NSLayoutConstraint!
    @IBOutlet weak var btnRecommend             : UIButton?
    
    
    
    
    
    
    var objUser : User?
    var arrayCategories = NSMutableArray()
    
    
    
    
    
    lazy var refreshControl : UIRefreshControl = {
    
        let _refreshControl = UIRefreshControl()
        _refreshControl.backgroundColor = .clearColor()
        _refreshControl.tintColor = .whiteColor()
        _refreshControl.addTarget(self, action: #selector(ProfileViewController.updateUserInfo), forControlEvents: .ValueChanged)
        
        return _refreshControl
    }()
    
    

    @IBAction func clickBtnBack(sender: AnyObject) {
        
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    
    //MARK: - UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout
    
    
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
    
    
    //MARK: - WebServices
    
    
    
    func listSubCategories() -> Void {
        
        self.acitivityCategories.startAnimating()
        
        ProfileBC.listStarSubCategoriesToUser(self.objUser!) { (arrayCategories) in
            
            self.acitivityCategories.stopAnimating()
            
            self.arrayCategories = arrayCategories
            
            
            self.lblErrorMessage.text = "Categories no availables"
            self.viewLoading.alpha = CGFloat(!Bool(self.arrayCategories.count))
            
            let height = Int(self.scrollContent.bounds.size.height) - 113
            let newHeight = Int(self.clvCategories.frame.origin.y) + self.arrayCategories.count * 36
            
            self.constraintHeightContent.constant = newHeight > height ? CGFloat(newHeight) : CGFloat(height)
            
            self.clvCategories.reloadData()
            
        }
    }
    
    
    
    
    //MARK: - Configuration
    
    
    func updateDataUser() -> Void {
        
        self.lblNameUser.text   = "\(self.objUser!.user_first_name!) \(self.objUser!.user_last_name!)"
        self.lblSkype.text      = "Skype: \(self.objUser!.user_skype_id!)"
        self.lblMothScore.text  = "\(self.objUser!.user_last_month_score!)"
        self.lblScore.text      = "\(self.objUser!.user_total_score!)"
        self.lblLevel.text      = "\(self.objUser!.user_level!)"
    
        OSPImageDownloaded.descargarImagenEnURL(self.objUser?.user_avatar, paraImageView: self.imgProfile, conPlaceHolder: self.imgProfile.image)
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
    
    
    
    //MARK: -
    
    override func viewWillAppear(animated: Bool) {
        
        if self.objUser == nil {
            self.objUser = LoginBC.getCurrenteUserSession()
            
        }
        
        
        if self.objUser != nil {
            self.updateUserInfo()
        }
        
        
        self.btnRecommend?.alpha = CGFloat(!LoginBC.user(self.objUser, isEqualToUser: LoginBC.getCurrenteUserSession()))
        
        super.viewWillAppear(animated)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.scrollContent.addSubview(self.refreshControl)
        OSPCrop.makeRoundView(self.imgProfile)

        
        for view in self.scoreViews{
            view.layer.borderWidth = 1
            view.layer.borderColor = UIColor(colorLiteralRed: 230.0/255.0, green: 230.0/255.0, blue: 230.0/255.0, alpha: 1).CGColor
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
    }

    
    
    
    
    // MARK: - Navigation

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "StarsCategoriesUserViewController" {
            let controller = segue.destinationViewController as! StarsCategoriesUserViewController
            controller.objStarSubCategory = sender as! StarSubCategoryBE
            controller.objUser = self.objUser!
        
        }else if segue.identifier == "RecommendViewController" {
            
            let controller = segue.destinationViewController as! RecommendViewController
            controller.objUser = self.objUser
        }
    }
    

}
