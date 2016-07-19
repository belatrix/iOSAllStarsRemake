//
//  ListTagsViewController.swift
//  AllStars
//
//  Created by Flavio Franco Tunqui on 5/31/16.
//  Copyright © 2016 Belatrix SF. All rights reserved.
//

import UIKit

class ListTagsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate, UISearchBarDelegate {
    
    @IBOutlet weak var viewHeader : UIView!
    @IBOutlet weak var tableTags : UITableView!
    @IBOutlet weak var searchTags : UISearchBar!
    @IBOutlet weak var viewLoading : UIView!
    @IBOutlet weak var lblErrorMessage : UILabel!
    @IBOutlet weak var acitivityTags : UIActivityIndicatorView!
    
    var isDownload = false
    var arrayTags = NSMutableArray()
    var nextPage : String? = nil
    var searchText : String  = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setViews()
        
        self.listAllTags()
        
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        if let rootVC = self.navigationController?.viewControllers.first where
            rootVC == self.tabBarController?.moreNavigationController.viewControllers.first  {
            
            self.navigationController?.setNavigationBarHidden(false, animated: true)
        }
    }
    
    // MARK: - Style
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
    }
    
    // MARK: - UI
    func setViews() {
        self.searchTags.backgroundImage = UIImage()
        self.searchTags.backgroundColor = .clearColor()
        self.searchTags.barTintColor = .clearColor()
        
        viewHeader.layer.shadowOffset = CGSizeMake(0, 0)
        viewHeader.layer.shadowRadius = 2
        viewHeader.layer.masksToBounds = false
        viewHeader.layer.shadowOpacity = 1
        viewHeader.layer.shadowColor = UIColor.orangeColor().CGColor
        viewHeader.backgroundColor = UIColor.colorPrimary()
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
        
        let cell = tableView.cellForRowAtIndexPath(indexPath)
        cell?.setSelected(false, animated: true)
        
        let objBE = self.arrayTags[indexPath.row]
        self.performSegueWithIdentifier("UserRankingTagViewController", sender: objBE)
    }
    
    // MARK: - WebServices
    func listAllTags() {
        if (!self.isDownload) {
            self.isDownload = true
            
            self.acitivityTags.startAnimating()
            self.viewLoading.alpha = CGFloat(!Bool(self.arrayTags.count))
            self.lblErrorMessage.text = "Loading tags"
            
            SearchBC.listStarKeywordWithCompletion { (arrayKeywords, nextPage) in
                
                self.nextPage = nextPage
                self.arrayTags = arrayKeywords!
                self.tableTags.reloadData()
                
                self.acitivityTags.stopAnimating()
                self.viewLoading.alpha = CGFloat(!Bool(self.arrayTags.count))
                self.lblErrorMessage.text = "Tags not found"
                
                self.isDownload = false
            }
        }
    }
    
    func listEmployeesInNextPage() {
        if (!self.isDownload) {
            self.isDownload = true
            
            self.acitivityTags.startAnimating()
            self.viewLoading.alpha = CGFloat(!Bool(self.arrayTags.count))
            self.lblErrorMessage.text = "Loading tags"
            
            SearchBC.listStarKeywordToPage(self.nextPage!, withCompletion: { (arrayKeywords, nextPage) in
                
                self.nextPage = nextPage
                
                let userCountInitial = self.arrayTags.count
                self.arrayTags.addObjectsFromArray(arrayKeywords! as [AnyObject])
                let userCountFinal = self.arrayTags.count - 1
                
                var arrayIndexPaths = [NSIndexPath]()
                
                for row in userCountInitial...userCountFinal {
                    arrayIndexPaths.append(NSIndexPath(forRow: row, inSection: 0))
                }
                
                self.tableTags.insertRowsAtIndexPaths(arrayIndexPaths, withRowAnimation: .Fade)
                
                self.acitivityTags.stopAnimating()
                self.viewLoading.alpha = CGFloat(!Bool(self.arrayTags.count))
                self.lblErrorMessage.text = "Tags not found"
                
                self.isDownload = false
            })
        }
    }
    
    func listTagsToSearchText() {
        if (!self.isDownload) {
            self.isDownload = true
            
            self.acitivityTags.startAnimating()
            self.viewLoading.alpha = CGFloat(!Bool(self.arrayTags.count))
            self.lblErrorMessage.text = "Loading tags"
            
            SearchBC.listStarKeywordWithText(self.searchText) { (arrayKeywords, nextPage) in
                
                self.nextPage = nextPage
                self.arrayTags = arrayKeywords!
                self.tableTags.reloadData()
                
                self.acitivityTags.stopAnimating()
                self.viewLoading.alpha = CGFloat(!Bool(self.arrayTags.count))
                self.lblErrorMessage.text = "Tags not found"
                
                self.isDownload = false
            }
        }
    }
    
    // MARK: - Navigation
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "UserRankingTagViewController" {
            let controller = segue.destinationViewController as! UserRankingTagViewController
            controller.objStarKeyword = sender as? StarKeywordBE
        }
    }
}