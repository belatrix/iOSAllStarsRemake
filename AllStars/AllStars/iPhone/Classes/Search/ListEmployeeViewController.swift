//
//  ListEmployeeViewController.swift
//  AllStars
//
//  Created by Kenyi Rodriguez Vergara on 10/05/16.
//  Copyright © 2016 Belatrix SF. All rights reserved.
//

import UIKit

class ListEmployeeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate, UISearchBarDelegate {

    @IBOutlet weak var viewHeader               : UIView!
    @IBOutlet weak var tlbUsers                 : UITableView!
    @IBOutlet weak var searchUsers              : UISearchBar!
    @IBOutlet weak var viewLoading              : UIView!
    @IBOutlet weak var lblErrorMessage          : UILabel!
    @IBOutlet weak var acitivityEmployees       : UIActivityIndicatorView!
    
    var isDownload      = false
    var arrayUsers      = NSMutableArray()
    var nextPage        : String? = nil
    var searchText      : String  = ""
//    var dataTaskRequest : NSURLSessionDataTask?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setViews()
        
        self.listAllEmployees()
    }
    
    // MARK: - Style
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
    }
    
    // MARK: - UI
    func setViews() {
        self.searchUsers.backgroundImage = UIImage()
        self.searchUsers.backgroundColor = .clearColor()
        self.searchUsers.barTintColor = .clearColor()
        
        viewHeader.layer.shadowOffset = CGSizeMake(0, 0)
        viewHeader.layer.shadowRadius = 2
        viewHeader.layer.masksToBounds = false
        viewHeader.layer.shadowOpacity = 1
        viewHeader.layer.shadowColor = UIColor.orangeColor().CGColor
        viewHeader.backgroundColor = UIColor.colorPrimary()
    }
    
    // MARK: - UISearchBarDelegate
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        
        self.searchUsers.text = ""
        self.listAllEmployees()
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        
        searchUsers.resignFirstResponder()
    }
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        
        self.searchText = searchText.characters.count > 0 ? searchText : ""
        
        if self.searchText.characters.count == 0 {
            self.listAllEmployees()
        }else{
            self.listEmployessToSearchText()
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
        
        let cellIdentifier = "EmployeeTableViewCell"
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! EmployeeTableViewCell
        
        cell.objUserEmployee = self.arrayUsers[indexPath.row] as! User
        cell.updateData()
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let cell = tableView.cellForRowAtIndexPath(indexPath)
        cell?.setSelected(false, animated: true)
        
        let objBE = self.arrayUsers[indexPath.row]
        self.performSegueWithIdentifier("ProfileViewController", sender: objBE)
    }
    
    // MARK: - WebServices
    func listAllEmployees() {
        
//        if self.dataTaskRequest != nil {
//            self.dataTaskRequest?.suspend()
//        }
        if (!self.isDownload) {
            self.isDownload = true
            
            self.acitivityEmployees.startAnimating()
            self.viewLoading.alpha = CGFloat(!Bool(self.arrayUsers.count))
            self.lblErrorMessage.text = "Loading employees"
            
            //        self.dataTaskRequest =
            SearchBC.listEmployeeWithCompletion { (arrayEmployees, nextPage) in
                
                self.nextPage = nextPage
                self.arrayUsers = arrayEmployees!
                self.tlbUsers.reloadData()
                
                self.acitivityEmployees.stopAnimating()
                self.viewLoading.alpha = CGFloat(!Bool(self.arrayUsers.count))
                self.lblErrorMessage.text = "Employees not found"
                
                self.isDownload = false
            }
        }

    }
    
    func listEmployeesInNextPage() {
        
//        if self.dataTaskRequest != nil {
//            self.dataTaskRequest?.suspend()
//        }
        
        if (!self.isDownload) {
            self.isDownload = true
            
            self.acitivityEmployees.startAnimating()
            self.viewLoading.alpha = CGFloat(!Bool(self.arrayUsers.count))
            self.lblErrorMessage.text = "Loading employees"
            
            
            SearchBC.listEmployeeToPage(self.nextPage!, withCompletion: { (arrayEmployees, nextPage) in
                
                self.nextPage = nextPage
                
                let userCountInitial = self.arrayUsers.count
                self.arrayUsers.addObjectsFromArray(arrayEmployees! as [AnyObject])
                let userCountFinal = self.arrayUsers.count - 1
                
                var arrayIndexPaths = [NSIndexPath]()
                
                for row in userCountInitial...userCountFinal {
                    arrayIndexPaths.append(NSIndexPath(forRow: row, inSection: 0))
                }
                
                self.tlbUsers.insertRowsAtIndexPaths(arrayIndexPaths, withRowAnimation: .Fade)
                
                self.acitivityEmployees.stopAnimating()
                self.viewLoading.alpha = CGFloat(!Bool(self.arrayUsers.count))
                self.lblErrorMessage.text = "Employees not found"
                
                self.isDownload = false
            })
        }
    }
    
    func listEmployessToSearchText() {
        
        self.isDownload = true
        
//        if self.dataTaskRequest != nil {
//            self.dataTaskRequest?.suspend()
//        }
        
        if (!self.isDownload) {
            self.acitivityEmployees.startAnimating()
            self.viewLoading.alpha = CGFloat(!Bool(self.arrayUsers.count))
            self.lblErrorMessage.text = "Loading employees"
            
            
            //        self.dataTaskRequest =
            SearchBC.listEmployeeWithText(self.searchText) { (arrayEmployees, nextPage) in
                
                self.nextPage = nextPage
                self.arrayUsers = arrayEmployees!
                self.tlbUsers.reloadData()
                
                self.acitivityEmployees.stopAnimating()
                self.viewLoading.alpha = CGFloat(!Bool(self.arrayUsers.count))
                self.lblErrorMessage.text = "Employees not found"
                
                self.isDownload = false
            }
        }

    }
    
    // MARK: - Navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "ProfileViewController" {
            let controller = segue.destinationViewController as! ProfileViewController
            controller.objUser = sender as? User
            controller.backEnable = true
        }
    }
}