//
//  UserRankingTagViewController.swift
//  AllStars
//
//  Created by Flavio Franco Tunqui on 6/1/16.
//  Copyright © 2016 Belatrix SF. All rights reserved.
//

import UIKit

class UserRankingTagViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate {
    
    @IBOutlet weak var tableUsers               : UITableView!
    @IBOutlet weak var viewLoading              : UIView!
    @IBOutlet weak var lblErrorMessage          : UILabel!
    @IBOutlet weak var acitivityEmployees       : UIActivityIndicatorView!
    @IBOutlet weak var lblTitle                 : UILabel!
    
    var objStarKeyword : StarKeywordBE?
    
    var isDownload = false
    var arrayUsers = NSMutableArray()
    var nextPage : String? = nil
    var searchText : String  = ""
    var dataTaskRequest : NSURLSessionDataTask?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        lblTitle.text = "\(objStarKeyword!.keyword_name!) Top"
        
        self.listAllUsers()
    }
    
    // MARK: - UIScrollViewDelegate
    func scrollViewDidScroll(scrollView: UIScrollView) {
        if (self.nextPage != nil && self.isDownload == false && scrollView.contentOffset.y + scrollView.frame.size.height  > scrollView.contentSize.height + 40) {
            self.listEmployeesInNextPage()
        }
    }
    
    // MARK: - UITableViewDelegate, UITableViewDataSource
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrayUsers.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cellIdentifier = "UserRankingTagTableViewCell"
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! UserRankingTagTableViewCell
        
        cell.objUserEmployee = self.arrayUsers[indexPath.row] as! UserTagBE
        cell.updateData()
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let cell = tableView.cellForRowAtIndexPath(indexPath)
        cell?.setSelected(false, animated: true)
        
        let objBE = self.arrayUsers[indexPath.row] as! UserTagBE
        
        let objUser : User = User()
        objUser.user_pk = objBE.user_pk
        objUser.user_username = objBE.user_username
        objUser.user_first_name = objBE.user_first_name
        objUser.user_last_name = objBE.user_last_name
        objUser.user_level = objBE.user_level
        objUser.user_avatar = objBE.user_avatar
        
        self.performSegueWithIdentifier("ProfileViewControllerFromRankingTag", sender: objUser)
    }
    
    // MARK: - WebServices
    func listAllUsers() {
        
        if self.dataTaskRequest != nil {
            self.dataTaskRequest?.suspend()
        }
        
        self.acitivityEmployees.startAnimating()
        self.viewLoading.alpha = CGFloat(!Bool(self.arrayUsers.count))
        self.lblErrorMessage.text = "Loading employees"
        
        self.dataTaskRequest = RankingBC.listStarKeywordWithCompletion (objStarKeyword!) { (arrayUsers, nextPage) in
            
            self.nextPage = nextPage
            self.arrayUsers = arrayUsers
            self.tableUsers.reloadData()
            
            self.acitivityEmployees.stopAnimating()
            self.viewLoading.alpha = CGFloat(!Bool(self.arrayUsers.count))
            self.lblErrorMessage.text = "Employees not found"
        }
    }
    
    func listEmployeesInNextPage() {
        
        if self.dataTaskRequest != nil {
            self.dataTaskRequest?.suspend()
        }
        
        self.isDownload = true
        
        self.acitivityEmployees.startAnimating()
        self.viewLoading.alpha = CGFloat(!Bool(self.arrayUsers.count))
        self.lblErrorMessage.text = "Loading employees"
        
        self.dataTaskRequest = RankingBC.listStarKeywordToPage(self.nextPage!, withCompletion: { (arrayUsers, nextPage) in
            
            self.isDownload = false
            self.nextPage = nextPage
            
            let userCountInitial = self.arrayUsers.count
            self.arrayUsers.addObjectsFromArray(arrayUsers as [AnyObject])
            let userCountFinal = self.arrayUsers.count - 1
            
            var arrayIndexPaths = [NSIndexPath]()
            
            for row in userCountInitial...userCountFinal {
                arrayIndexPaths.append(NSIndexPath(forRow: row, inSection: 0))
            }
            
            self.tableUsers.insertRowsAtIndexPaths(arrayIndexPaths, withRowAnimation: .Fade)
            
            self.acitivityEmployees.stopAnimating()
            self.viewLoading.alpha = CGFloat(!Bool(self.arrayUsers.count))
            self.lblErrorMessage.text = "Employees not found"
        })
    }
    
    // MARK: - IBActions
    @IBAction func btnBackTUI(sender: UIButton) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    // MARK: -
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
    }
    
    // MARK: - Navigation
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "ProfileViewControllerFromRankingTag" {
            let controller = segue.destinationViewController as! ProfileViewController
            controller.objUser = sender as? User
            controller.backEnable = true
        }
    }
}