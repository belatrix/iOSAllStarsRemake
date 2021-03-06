//
//  UserRankingTagViewController.swift
//  AllStars
//
//  Created by Flavio Franco Tunqui on 6/1/16.
//  Copyright © 2016 Belatrix SF. All rights reserved.
//

import UIKit

class UserRankingTagViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate {
    
    @IBOutlet weak var viewHeader               : UIView!
    @IBOutlet weak var tableUsers               : UITableView!
    @IBOutlet weak var viewLoading              : UIView!
    @IBOutlet weak var lblErrorMessage          : UILabel!
    @IBOutlet weak var acitivityEmployees       : UIActivityIndicatorView!
    @IBOutlet weak var lblTitle                 : UILabel!
    @IBOutlet weak var backButton               : UIButton!
    
    var objStarKeyword : StarKeywordBE?
    
    var isDownload = false
    var arrayUsers = NSMutableArray()
    var nextPage : String? = nil
    var searchText : String  = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setViews()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        lblTitle.text = "\(objStarKeyword!.keyword_name!) Top"
        
        self.listAllUsers()
        setViews()
    }
    
    // MARK: - UI
    func setViews() {
        viewHeader.backgroundColor = UIColor.colorPrimary()
        
        if let backButton = self.backButton {
            
            if let nav = self.navigationController where nav.viewControllers.count > 1 {
                
                backButton.hidden = false
            } else {
                
                backButton.hidden = true
            }
        }
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
        
        if (!self.isDownload) {
            self.isDownload = true
            
            self.acitivityEmployees.startAnimating()
            self.viewLoading.alpha = CGFloat(!Bool(self.arrayUsers.count))
            self.lblErrorMessage.text = "Loading employees"
            
            RankingBC.listStarKeywordWithCompletion (objStarKeyword!) { (arrayUsers, nextPage) in
                
                self.nextPage = nextPage
                self.arrayUsers = arrayUsers
                self.tableUsers.reloadData()
                
                self.acitivityEmployees.stopAnimating()
                self.viewLoading.alpha = CGFloat(!Bool(self.arrayUsers.count))
                self.lblErrorMessage.text = "Employees not found"
                
                self.isDownload = false
            }
        }
    }
    
    func listEmployeesInNextPage() {
        if (!self.isDownload) {
            self.isDownload = true
            
            self.acitivityEmployees.startAnimating()
            self.viewLoading.alpha = CGFloat(!Bool(self.arrayUsers.count))
            self.lblErrorMessage.text = "Loading employees"
            
            SearchBC.listStarKeywordToPage(self.nextPage!, withCompletion: { (arrayKeywords, nextPage) in
                
                self.nextPage = nextPage
                
                let userCountInitial = self.arrayUsers.count
                self.arrayUsers.addObjectsFromArray(arrayKeywords! as [AnyObject])
                let userCountFinal = self.arrayUsers.count - 1
                
                var arrayIndexPaths = [NSIndexPath]()
                
                for row in userCountInitial...userCountFinal {
                    arrayIndexPaths.append(NSIndexPath(forRow: row, inSection: 0))
                }
                
                self.tableUsers.insertRowsAtIndexPaths(arrayIndexPaths, withRowAnimation: .Fade)
                
                self.acitivityEmployees.stopAnimating()
                self.viewLoading.alpha = CGFloat(!Bool(self.arrayUsers.count))
                self.lblErrorMessage.text = "Employees not found"
                
                self.isDownload = false
            })
        }
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
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "ProfileViewControllerFromRankingTag" {
            let controller = segue.destinationViewController as! ProfileViewController
            controller.objUser = sender as? User
            controller.backEnable = true
        }
    }
}