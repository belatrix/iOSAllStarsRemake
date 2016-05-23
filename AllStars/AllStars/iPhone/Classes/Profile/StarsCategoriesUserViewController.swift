//
//  StarsCategoriesUserViewController.swift
//  AllStars
//
//  Created by Kenyi Rodriguez Vergara on 9/05/16.
//  Copyright © 2016 Belatrix SF. All rights reserved.
//

import UIKit
import FoldingCell


class StarsCategoriesUserViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate {

   
    
    @IBOutlet weak var tlbUsers                 : UITableView!
    @IBOutlet weak var lblCategoryName          : UILabel!
    @IBOutlet weak var lblErrorMessage          : UILabel!
    @IBOutlet weak var acitivityLoading         : UIActivityIndicatorView!
    @IBOutlet weak var viewLoading              : UIView!
    
    
    
    
    var objUser = User()
    var objStarSubCategory = StarSubCategoryBE()
    var arrayUsers = NSMutableArray()
    var isDownload = false
    var nextPage    : String? = nil
    var dataTaskRequest : NSURLSessionDataTask?
    
    
    
    lazy var refreshControl : UIRefreshControl = {
        
        let _refreshControl = UIRefreshControl()
        _refreshControl.backgroundColor = .clearColor()
        _refreshControl.tintColor = UIColor(red: 255.0/255.0, green: 157.0/255.0, blue: 12.0/255.0, alpha: 1)
        _refreshControl.addTarget(self, action: #selector(StarsCategoriesUserViewController.listStarsSubCategoriesUser), forControlEvents: .ValueChanged)
        
        return _refreshControl
    }()
    
    
    
    
    @IBAction func clickBtnBack(sender: AnyObject) {
        
        self.navigationController?.popViewControllerAnimated(true)
    }

    
    
    
    //MARK: - WebServices
    
    
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
    
    
    func listStarsSubCategoriesUser() -> Void {
        
        self.acitivityLoading.startAnimating()
        
        if self.dataTaskRequest != nil {
            self.dataTaskRequest?.suspend()
        }
        
        self.dataTaskRequest = ProfileBC.listStarUserSubCategoriesToUser(self.objUser, toSubCategory: self.objStarSubCategory) { (arrayUsers, nextPage) in
            
            self.arrayUsers = arrayUsers
            self.nextPage = nextPage
            
            self.refreshControl.endRefreshing()
            
            self.lblErrorMessage.text = "Information no available"
            self.viewLoading.alpha = CGFloat(!Bool(self.arrayUsers.count))
            self.acitivityLoading.stopAnimating()
            
            self.tlbUsers.reloadData()
        }
    }
    
    
    //MARK: - UIScrollViewDelegate
    
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        
        if (self.nextPage != nil && self.isDownload == false && scrollView.contentOffset.y + scrollView.frame.size.height  > scrollView.contentSize.height + 40) {
            
            self.listStarsSubCategoriesUserNextPage()
        }
    }
    
    
    
    //MARK: - UITableViewDelegate and UITableViewDataSource
    
    
    
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
        
        return cell
        
    }
    
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        let objBE = self.arrayUsers[indexPath.row] as! UserQualifyBE
        return StarUserInfoTableViewCell.getHeightToCellWithTextDescription(objBE.userQualify_text!)
    }
    
    
    
    //MARK: -
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.tlbUsers.addSubview(self.refreshControl)
    }

    
    override func viewWillAppear(animated: Bool) {
        
        self.listStarsSubCategoriesUser()
        self.lblCategoryName.text = self.objStarSubCategory.starSubCategoy_name!
        super.viewWillAppear(animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        
        return .LightContent
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
