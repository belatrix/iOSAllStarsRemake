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
    var shouldAddNew = false
    var delegate: UserSkillsViewControllerDelegate?
    
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
        self.searchSkills.tintColor = .whiteColor()
    }
    
    func setTexts() {
        
        self.titleLabel.text = "add_skill".localized
    }
    
    // MARK: - UISearchBarDelegate
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        self.searchSkills.text = ""
        shouldAddNew = false
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
        return (shouldAddNew == true) ? 1 : self.arraySkills.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if shouldAddNew {
            
            let cell = UITableViewCell(style: .Default, reuseIdentifier: "AddSkillCell")
            
            cell.textLabel?.textAlignment = .Center
            cell.textLabel?.text = "Add " + searchText + " as a new Skill"
            cell.textLabel?.textColor = UIColor.colorAccent()
            
            return cell
        }
        
        let cellIdentifier = "SkillTableViewCell"
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! TagTableViewCell
        
        let skill = self.arraySkills[indexPath.row] as! KeywordBE
        
        cell.lblNameTag.text = skill.keyword_name
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let cell = tableView.cellForRowAtIndexPath(indexPath)
        cell?.setSelected(false, animated: true)
        
        // The searched skill wasn't found
        if shouldAddNew {
            
            self.addSkillToUser(searchText)
            return
        }
        
        let skill = self.arraySkills[indexPath.row] as! KeywordBE
        
        let alert = UIAlertController(title: "app_name".localized , message: "Do you want to add " + skill.keyword_name! + "as a new Skill?", preferredStyle: .Alert)
        
        let addAction = UIAlertAction(title: "yes".localized, style: .Default) { (action) in
            
            self.addSkillToUser(skill.keyword_name!)
        }
        
        let cancelAction = UIAlertAction(title: "no".localized, style: .Cancel, handler: nil)
        
        alert.addAction(addAction)
        alert.addAction(cancelAction)
        
        self.presentViewController(alert, animated: true, completion: nil)
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
        
        self.shouldAddNew = (self.arraySkills.count == 0)
        
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
    
    func addSkillToUser(skillName: String) {
        
        self.view.userInteractionEnabled = false
        ProfileBC.addUserSkill(skillName) { (skills) in
            
            self.view.userInteractionEnabled = true
            let alert = UIAlertController(title: "app_name".localized , message: "Skill added", preferredStyle: .Alert)
            
            let cancelAction = UIAlertAction(title: "ok".localized, style: .Cancel) { (action) in
                
                self.delegate?.newSkillAdded()
                self.navigationController?.popViewControllerAnimated(true)
            }
            alert.addAction(cancelAction)
            
            self.presentViewController(alert, animated: true, completion: nil)
        }
    }
}