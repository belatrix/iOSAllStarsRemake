//
//  AddSkillsViewController.swift
//  AllStars
//
//  Created by Ricardo Hernan Herrera Valle on 8/8/16.
//  Copyright © 2016 Belatrix SF. All rights reserved.
//

import Foundation

class AddSkillsViewController: UIViewController, UISearchBarDelegate {
    
    // MARK: - IBOutlets
    @IBOutlet weak var backButton               : UIButton!
    @IBOutlet weak var tableView                : UITableView!
    @IBOutlet weak var titleLabel               : UILabel!
    @IBOutlet weak var viewHeader               : UIView!
    @IBOutlet weak var searchSkills             : UISearchBar!
    @IBOutlet weak var viewLoading              : UIView!
    @IBOutlet weak var lblErrorMessage          : UILabel!
    @IBOutlet weak var acitivitySkills          : UIActivityIndicatorView!
    
    // MARK: - Properties
    var isDownload = false
    var arraySkills = NSMutableArray()
    var allSkills = NSMutableArray()
    var searchText : String  = ""
    
    // MAKR: - Initialization
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setViewsStyle()
        setTexts()
        listAllSkills()
    }
    
    // MARK: - UI Style
    func setViewsStyle() {
        
        viewHeader.layer.shadowOffset = CGSizeMake(0, 0)
        viewHeader.layer.shadowRadius = 2
        viewHeader.layer.masksToBounds = false
        viewHeader.layer.shadowOpacity = 1
        viewHeader.layer.shadowColor = UIColor.orangeColor().CGColor
        viewHeader.backgroundColor = UIColor.colorPrimary()
        
        self.searchSkills.backgroundImage = UIImage()
        self.searchSkills.backgroundColor = .clearColor()
        self.searchSkills.barTintColor = .clearColor()
    }
    
    func setTexts() {
        
        self.titleLabel.text = "add_skill".localized
    }
    
    // MARK: - UISearchBarDelegate
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        self.searchSkills.text = ""
        self.listAllSkills()
        self.searchSkills.resignFirstResponder()
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        
        searchSkills.resignFirstResponder()
    }
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        
        self.searchText = searchText.characters.count > 0 ? searchText : ""
        
        if self.searchText.characters.count == 0 {
            self.listAllSkills()
        }else{
            self.listSkillsWithSearchText()
        }
    }
    
    func searchBarTextDidBeginEditing(searchBar: UISearchBar) {
        
        searchBar.showsCancelButton = true
    }
    
    func searchBarTextDidEndEditing(searchBar: UISearchBar) {
        
        searchBar.showsCancelButton = false
    }
    
    // MARK: - UITableViewDelegate, UITableViewDataSource
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arraySkills.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cellIdentifier = "SkillTableViewCell"
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! TagTableViewCell
        
        let skill = self.arraySkills[indexPath.row] as! KeywordBE
        
        cell.lblNameTag.text = skill.keyword_name
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let cell = tableView.cellForRowAtIndexPath(indexPath)
        cell?.setSelected(false, animated: true)
        
        let _ = self.arraySkills[indexPath.row]
        
        // TODO: Send selected skill through delegate
    }
    
    // MARK: - User Interaction
    @IBAction func btnBackTUI(sender: UIButton) {
        self.view.endEditing(true)
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    func listSkillsWithSearchText() {
        
        let resultPredicate = NSPredicate(format: "SELF.keyword_name contains[cd] %@", searchText)
        
        self.arraySkills.removeAllObjects()
        self.arraySkills.addObjectsFromArray(self.allSkills as [AnyObject])
        
        let filteredSkills = self.arraySkills.filteredArrayUsingPredicate(resultPredicate)
        
        self.arraySkills.removeAllObjects()
        self.arraySkills.addObjectsFromArray(filteredSkills)
        
        self.tableView.reloadData()
    }
    
    // MARK: - WebServices
    func listAllSkills() {
        if (!self.isDownload && allSkills.count == 0) {
            self.isDownload = true
            
            self.acitivitySkills.startAnimating()
            self.viewLoading.alpha = CGFloat(!Bool(self.arraySkills.count))
            self.lblErrorMessage.text = "Loading skills"
            
            RecommendBC.listKeyWordsWithCompletion({ (arrayKeywords) in
                
                self.arraySkills = NSMutableArray(array: arrayKeywords)
                self.allSkills = NSMutableArray(array: arrayKeywords)
                self.tableView.reloadData()
                
                self.acitivitySkills.stopAnimating()
                self.viewLoading.alpha = CGFloat(!Bool(self.arraySkills.count))
                self.lblErrorMessage.text = "skills not found"
                
                self.isDownload = false
            })
        } else {
            
            self.arraySkills.removeAllObjects()
            self.arraySkills.addObjectsFromArray(self.allSkills as [AnyObject])
            self.tableView.reloadData()
        }
    }
}