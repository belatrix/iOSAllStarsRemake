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
    @IBOutlet weak var backButton               : UIButton!
    
    var isDownload      = false
    var arrayUsers      = NSMutableArray()
    var nextPage        : String? = nil
    var searchText      : String  = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.listAllEmployees()
        
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        if let rootVC = self.navigationController?.viewControllers.first where
            rootVC == self.tabBarController?.moreNavigationController.viewControllers.first  {
            
            self.navigationController?.setNavigationBarHidden(false, animated: false)
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        
        setViews()
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
        
        if let backButton = self.backButton {
            
            if let nav = self.navigationController where nav.viewControllers.count > 1 {
                
                backButton.hidden = false
            } else {
                
                backButton.hidden = true
            }
        }
    }
    
    // MARK: - UISearchBarDelegate
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        self.searchUsers.text = ""
        self.listAllEmployees()
        self.searchUsers.resignFirstResponder()
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
    
    func searchBarTextDidBeginEditing(searchBar: UISearchBar) {
        
        searchBar.showsCancelButton = true
    }
    
    func searchBarTextDidEndEditing(searchBar: UISearchBar) {
        
        searchBar.showsCancelButton = false
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
        self.performSegueWithIdentifier("segueProfileViewController", sender: objBE)
    }
    
    // MARK: - User Interaction
    @IBAction func goBack(sender: UIButton) {
        self.view.endEditing(true)
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    // MARK: - WebServices
    func listAllEmployees() {
        if (!self.isDownload) {
            self.isDownload = true
            
            self.acitivityEmployees.startAnimating()
            self.viewLoading.alpha = CGFloat(!Bool(self.arrayUsers.count))
            self.lblErrorMessage.text = "Loading employees"
            
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
//        if (!self.isDownload) {
//            self.isDownload = true
        
            self.acitivityEmployees.startAnimating()
            self.viewLoading.alpha = CGFloat(!Bool(self.arrayUsers.count))
            self.lblErrorMessage.text = "Loading employees"
            
            SearchBC.listEmployeeWithText(self.searchText) { (arrayEmployees, nextPage) in
                
                self.nextPage = nextPage
                self.arrayUsers = arrayEmployees!
                self.tlbUsers.reloadData()
                
                self.acitivityEmployees.stopAnimating()
                self.viewLoading.alpha = CGFloat(!Bool(self.arrayUsers.count))
                self.lblErrorMessage.text = "Employees not found"
                
                self.isDownload = false
            }
//        }
    }
    
    // MARK: - Navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "segueProfileViewController" {
            let controller = segue.destinationViewController as! ProfileViewController
            controller.objUser = sender as? User
            controller.backEnable = true
        }
    }
}