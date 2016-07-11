//
//  StarsCategoriesUserViewController.swift
//  AllStars
//
//  Created by Kenyi Rodriguez Vergara on 9/05/16.
//  Copyright © 2016 Belatrix SF. All rights reserved.
//

import UIKit

class StarsCategoriesUserViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate {
    
    @IBOutlet weak var viewHeader               : UIView!
    @IBOutlet weak var tlbUsers                 : UITableView!
    @IBOutlet weak var lblCategoryName          : UILabel!
    @IBOutlet weak var lblErrorMessage          : UILabel!
    @IBOutlet weak var actLoading               : UIActivityIndicatorView!
    @IBOutlet weak var viewLoading              : UIView!
    
    var objUser = User()
    var objStarSubCategory = StarSubCategoryBE()
    var arrayUsers = NSMutableArray()
    var isDownload = false
    var nextPage    : String? = nil
    var dataTaskRequest : NSURLSessionDataTask?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setViews()
        
        self.tlbUsers.addSubview(self.refreshControl)
    }
    
    override func viewWillAppear(animated: Bool) {
        self.listStarsSubCategoriesUser()
        self.lblCategoryName.text = self.objStarSubCategory.starSubCategoy_name!
        
        super.viewWillAppear(animated)
    }
    
    // MARK: - Style
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
    }
    
    // MARK: - UI
    func setViews() {
        viewHeader.backgroundColor = UIColor.colorPrimary()
    }
    
    lazy var refreshControl : UIRefreshControl = {
        
        let _refreshControl = UIRefreshControl()
        _refreshControl.backgroundColor = .clearColor()
        _refreshControl.tintColor = UIColor.belatrix()
        _refreshControl.addTarget(self, action: #selector(StarsCategoriesUserViewController.listStarsSubCategoriesUser), forControlEvents: .ValueChanged)
        
        return _refreshControl
    }()
    
    // MARK: - IBActions
    @IBAction func clickBtnBack(sender: AnyObject) {
        
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    // MARK: - WebServices
    func listStarsSubCategoriesUser() -> Void {
        
        self.actLoading.startAnimating()
        
        if self.dataTaskRequest != nil {
            self.dataTaskRequest?.suspend()
        }
        
        self.dataTaskRequest = ProfileBC.listStarUserSubCategoriesToUser(self.objUser, toSubCategory: self.objStarSubCategory) { (arrayUsers, nextPage) in
            
            self.arrayUsers = arrayUsers
            self.nextPage = nextPage
            
            self.refreshControl.endRefreshing()
            
            self.lblErrorMessage.text = "Information no available"
            self.viewLoading.alpha = CGFloat(!Bool(self.arrayUsers.count))
            self.actLoading.stopAnimating()
            
            self.tlbUsers.reloadData()
        }
    }
    
    func listStarsSubCategoriesUserNextPage() -> Void {
        if self.dataTaskRequest != nil {
            self.dataTaskRequest?.suspend()
        }
        
        self.isDownload = true
        self.dataTaskRequest = ProfileBC.listStarUserSubCategoriesToPage(self.nextPage!, withCompletion: { (arrayUsers, nextPage) in
            
            self.isDownload = false
            self.nextPage = nextPage
            
            let userCountInitial = self.arrayUsers.count
            self.arrayUsers.addObjectsFromArray(arrayUsers as [AnyObject])
            let userCountFinal = self.arrayUsers.count - 1
            
            var arrayIndexPaths = [NSIndexPath]()
            
            for row in userCountInitial...userCountFinal {
                arrayIndexPaths.append(NSIndexPath(forRow: row, inSection: 0))
            }
            
            self.tlbUsers.insertRowsAtIndexPaths(arrayIndexPaths, withRowAnimation: .Fade)
        })
    }
    
    // MARK: - UIScrollViewDelegate
    func scrollViewDidScroll(scrollView: UIScrollView) {
        if (self.nextPage != nil && self.isDownload == false && scrollView.contentOffset.y + scrollView.frame.size.height  > scrollView.contentSize.height + 40) {
            
            self.listStarsSubCategoriesUserNextPage()
        }
    }
    
    // MARK: - UITableViewDelegate and UITableViewDataSource
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrayUsers.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cellIdentifier = "StarUserInfoTableViewCell"
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! StarUserInfoTableViewCell
        
        cell.selectionStyle = .None
        cell.objUserQualify = self.arrayUsers[indexPath.row] as! UserQualifyBE
        cell.updateData()
        
        cell.btnKeyword.tag = indexPath.row
        cell.btnKeyword.addTarget(self, action: #selector(StarsCategoriesUserViewController.openListTags(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        
        return cell
    }
    
    func openListTags(sender: UIButton!){
        let userQualifyBE = self.arrayUsers[sender.tag] as! UserQualifyBE
        
        let objStarKeyword = StarKeywordBE()
        objStarKeyword.keyword_pk = userQualifyBE.userQualify_keywordID
        objStarKeyword.keyword_name = userQualifyBE.userQualify_keywordName
        
        self.performSegueWithIdentifier("UserRankingTagViewController2", sender: objStarKeyword)
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        let objBE = self.arrayUsers[indexPath.row] as! UserQualifyBE
        return StarUserInfoTableViewCell.getHeightToCellWithTextDescription(objBE.userQualify_text!)
    }

    // MARK: - Navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "UserRankingTagViewController2" {
            let objStarKeyword = sender as? StarKeywordBE
            let controller = segue.destinationViewController as! UserRankingTagViewController
            controller.objStarKeyword = objStarKeyword
        }
    }
}