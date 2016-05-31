//
//  ListTagsViewController.swift
//  AllStars
//
//  Created by Flavio Franco Tunqui on 5/31/16.
//  Copyright © 2016 Belatrix SF. All rights reserved.
//

import UIKit

class ListTagsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate, UISearchBarDelegate {
    
    @IBOutlet weak var tableTags : UITableView!
    @IBOutlet weak var searchTags : UISearchBar!
    @IBOutlet weak var viewLoading : UIView!
    @IBOutlet weak var lblErrorMessage : UILabel!
    @IBOutlet weak var acitivityTags : UIActivityIndicatorView!
    @IBOutlet weak var viewHeader : UIView!
    
    var isDownload = false
    var arrayTags = NSMutableArray()
    var nextPage : String? = nil
    var searchText : String  = ""
    var dataTaskRequest : NSURLSessionDataTask?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.searchTags.backgroundImage = UIImage()
        self.searchTags.backgroundColor = .clearColor()
        self.searchTags.barTintColor = .clearColor()
        
        self.viewHeader.layer.shadowOffset = CGSizeMake(0, 0)
        self.viewHeader.layer.shadowRadius = 2
        self.viewHeader.layer.masksToBounds = false
        self.viewHeader.layer.shadowOpacity = 1
        self.viewHeader.layer.shadowColor = UIColor.orangeColor().CGColor
        
        self.listAllTags()
    }
    
    // MARK: - UISearchBarDelegate
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        self.searchTags.text = ""
        self.listAllTags()
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        
        searchTags.resignFirstResponder()
    }
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        
        self.searchText = searchText.characters.count > 0 ? searchText : ""
        
        if self.searchText.characters.count == 0 {
            self.listAllTags()
        }else{
            self.listTagsToSearchText()
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
        return self.arrayTags.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cellIdentifier = "TagTableViewCell"
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! TagTableViewCell
        
        cell.objStarKeywordBE = self.arrayTags[indexPath.row] as! StarKeywordBE
        cell.updateData()
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
//        let cell = tableView.cellForRowAtIndexPath(indexPath)
//        cell?.setSelected(false, animated: true)
//        
//        let objBE = self.arrayTags[indexPath.row]
//        self.performSegueWithIdentifier("ProfileViewController", sender: objBE)
    }
    
    // MARK: - WebServices
    func listAllTags() {
        
        if self.dataTaskRequest != nil {
            self.dataTaskRequest?.suspend()
        }
        
        self.acitivityTags.startAnimating()
        self.viewLoading.alpha = CGFloat(!Bool(self.arrayTags.count))
        self.lblErrorMessage.text = "Loading tags"
        
        self.dataTaskRequest = SearchBC.listStarKeywordWithCompletion { (arrayKeywords, nextPage) in
            
            self.nextPage = nextPage
            self.arrayTags = arrayKeywords
            self.tableTags.reloadData()
            
            self.acitivityTags.stopAnimating()
            self.viewLoading.alpha = CGFloat(!Bool(self.arrayTags.count))
            self.lblErrorMessage.text = "Tags not found"
        }
    }
    
    func listEmployeesInNextPage() {
        
        if self.dataTaskRequest != nil {
            self.dataTaskRequest?.suspend()
        }
        
        self.isDownload = true
        
        self.acitivityTags.startAnimating()
        self.viewLoading.alpha = CGFloat(!Bool(self.arrayTags.count))
        self.lblErrorMessage.text = "Loading tags"
        
        self.dataTaskRequest = SearchBC.listStarKeywordToPage(self.nextPage!, withCompletion: { (arrayKeywords, nextPage) in
            
            self.isDownload = false
            self.nextPage = nextPage
            
            let userCountInitial = self.arrayTags.count
            self.arrayTags.addObjectsFromArray(arrayKeywords as [AnyObject])
            let userCountFinal = self.arrayTags.count - 1
            
            var arrayIndexPaths = [NSIndexPath]()
            
            for row in userCountInitial...userCountFinal {
                arrayIndexPaths.append(NSIndexPath(forRow: row, inSection: 0))
            }
            
            self.tableTags.insertRowsAtIndexPaths(arrayIndexPaths, withRowAnimation: .Fade)
            
            self.acitivityTags.stopAnimating()
            self.viewLoading.alpha = CGFloat(!Bool(self.arrayTags.count))
            self.lblErrorMessage.text = "Tags not found"
        })
    }
    
    func listTagsToSearchText() {
        
        if self.dataTaskRequest != nil {
            self.dataTaskRequest?.suspend()
        }
        
        self.acitivityTags.startAnimating()
        self.viewLoading.alpha = CGFloat(!Bool(self.arrayTags.count))
        self.lblErrorMessage.text = "Loading tags"
        
        
        self.dataTaskRequest = SearchBC.listStarKeywordWithText(self.searchText) { (arrayKeywords, nextPage) in
            
            self.nextPage = nextPage
            self.arrayTags = arrayKeywords
            self.tableTags.reloadData()
            
            self.acitivityTags.stopAnimating()
            self.viewLoading.alpha = CGFloat(!Bool(self.arrayTags.count))
            self.lblErrorMessage.text = "Tags not found"
        }
    }
    
    // MARK: -
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
    }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
//    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
//        
//        if segue.identifier == "ProfileViewController" {
//            let controller = segue.destinationViewController as! ProfileViewController
//            controller.objUser = sender as? User
//        }
//    }
}