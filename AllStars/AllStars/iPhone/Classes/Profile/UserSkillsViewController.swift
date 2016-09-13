//
//  UserSkillsViewController.swift
//  AllStars
//
//  Created by Ricardo Hernan Herrera Valle on 8/8/16.
//  Copyright © 2016 Belatrix SF. All rights reserved.
//

import Foundation

class UserSkillsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UserSkillsViewControllerDelegate, UIScrollViewDelegate {
    
    // MARK: - IBOutlets
    @IBOutlet weak var backButton               : UIButton!
    @IBOutlet weak var tableView                : UITableView!
    @IBOutlet weak var titleLabel               : UILabel!
    @IBOutlet weak var viewHeader               : UIView!
    @IBOutlet weak var actUpdating              : UIActivityIndicatorView!
    @IBOutlet weak var viewLoading              : UIView!
    @IBOutlet weak var lblErrorMessage          : UILabel!
    @IBOutlet weak var acitivitySkills          : UIActivityIndicatorView!
    
    // MARK: - Properties
    var userSkills = [KeywordBE]()
    
    var isDownload      = false
    var nextPage        : String? = nil
    var objUser         : User?
    var isLoggedUser    = false
    
    lazy var refreshControl : UIRefreshControl = {
        
        let refreshControl = UIRefreshControl()
        refreshControl.backgroundColor = .clearColor()
        refreshControl.tintColor = UIColor.belatrix()
        refreshControl.addTarget(self, action: #selector(UserSkillsViewController.listAllSkills), forControlEvents: .ValueChanged)
        
        return refreshControl
    }()
    
    // MAKR: - Initialization
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if self.objUser?.user_pk == SessionUD.sharedInstance.getUserPk() {
            
            isLoggedUser = true
        }
        self.tableView.addSubview(self.refreshControl)
        
        setViewsStyle()
        listAllSkills()
        setTexts()
    }
    
    // MARK: - UI Style
    func setViewsStyle() {
        
        viewHeader.layer.shadowOffset = CGSizeMake(0, 0)
        viewHeader.layer.shadowRadius = 2
        viewHeader.layer.masksToBounds = false
        viewHeader.layer.shadowOpacity = 1
        viewHeader.layer.shadowColor = UIColor.orangeColor().CGColor
        viewHeader.backgroundColor = UIColor.colorPrimary()
    }
    
    func setTexts() {
        
        self.titleLabel.text = "skills".localized
    }
    
    // MARK: - UserSkillsViewControllerDelegate
    func newSkillAdded() {
        listAllSkills()
    }
    
    // MARK: - UIScrollViewDelegate
    func scrollViewDidScroll(scrollView: UIScrollView) {
        
        if (self.nextPage != nil && self.isDownload == false && scrollView.contentOffset.y + scrollView.frame.size.height  > scrollView.contentSize.height + 40) {
            
            self.listSkillsInNextPage()
        }
    }
    
    // MARK: - UITableViewDelegate, UITableViewDataSource
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        return Section.numberOfSections.rawValue
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        let selectedSection = Section(rawValue: section)!
        
        switch selectedSection {
        case .addSkill:
            return (isLoggedUser) ? 1 : 0
        case .userSkills:
            return userSkills.count
        default:
            fatalError("Invalid section for User skills")
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let section = Section(rawValue: indexPath.section)!
        
        switch section {
        case .addSkill:
            guard let cell = tableView.dequeueReusableCellWithIdentifier("newSkillCell")
                else { fatalError("Add Skill Cell doesn't exists") }
            
            cell.textLabel?.textColor = UIColor.colorAccent()
            
            return cell
        case .userSkills:
            
            let skill = userSkills[indexPath.row]
            let cell = UITableViewCell(style: .Default, reuseIdentifier: "skillCell")
            
            cell.textLabel?.text = skill.keyword_name
            cell.selectionStyle = .None
            cell.textLabel?.textColor = UIColor.darkGrayColor()
            cell.textLabel?.font = UIFont(name: "Helvetica Neue", size: 14.0)
            
            return cell
            
        default:
            fatalError("Invalid section for User skills")
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        self.tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        
        let section = Section(rawValue: indexPath.section)!
        
        switch section {
        case .addSkill:
            return false
            
        case .userSkills:
            return isLoggedUser
            
        default:
            fatalError("Invalid section for User skills")
        }
    }
    
    func tableView(tableView: UITableView, editingStyleForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCellEditingStyle {
        let section = Section(rawValue: indexPath.section)!
        
        switch section {
        case .addSkill:
            return .None
            
        case .userSkills:
            return .Delete
            
        default:
            fatalError("Invalid section for User skills")
        }
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
        if editingStyle == .Delete {
            
            let skill = self.userSkills[indexPath.row]
            
            self.actUpdating.startAnimating()
            self.view.userInteractionEnabled = false
            ProfileBC.deleteUserSkill(skill.keyword_name!, withCompletion: { (skills, successful) in
                
                self.view.userInteractionEnabled = true
                self.actUpdating.stopAnimating()
                
                if successful {
                    self.userSkills.removeAtIndex(indexPath.row)
                    tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Fade)
                    
                }
            })
        }
    }
    
    // MARK: - User Interaction
    @IBAction func btnBackTUI(sender: UIButton) {
        self.view.endEditing(true)
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    // MARK: - WebServices
    func listAllSkills() {
        if (!self.isDownload) {
            
            guard let user = self.objUser
                else { return }
            
            self.isDownload = true
            
            self.viewLoading.alpha = CGFloat(!Bool(self.userSkills.count))
            self.tableView.alpha = CGFloat(Bool(self.userSkills.count))
            self.lblErrorMessage.text = "Loading skills"
            ProfileBC.getUserSkills(user, withCompletion: { (skills, nextPage) in
                
                self.userSkills = skills ?? [KeywordBE]()
                self.nextPage = nextPage
                
                self.isDownload = false
                self.refreshControl.endRefreshing()
                
                self.tableView.reloadData()
                
                self.acitivitySkills.stopAnimating()
                self.viewLoading.alpha = (self.userSkills.count <= 0 && !self.isLoggedUser) ? 1 : 0
                self.tableView.alpha = (self.userSkills.count <= 0 && !self.isLoggedUser) ? 0 : 1
                self.lblErrorMessage.text = "skills not found"
            })
        }
    }
    
    func listSkillsInNextPage() {
        
        if (!self.isDownload && self.nextPage != nil) {
            self.isDownload = true
            
            ProfileBC.getUserSkillsToPage(self.nextPage!, withCompletion: { (skills, nextPage) in
                
                self.nextPage = nextPage
                
                self.isDownload = false
                
                guard let skillsList = skills
                    else { return }
                
                self.userSkills.appendContentsOf(skillsList)
                
                self.tableView.reloadData()
            })
        }
    }
    
    // MARK: - Navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "AddSkillsViewController" {
            
            let addSkillVC = segue.destinationViewController as? AddSkillsViewController
            
            addSkillVC?.delegate = self
        }
    }
}

extension UserSkillsViewController {
    
    enum Section: Int {
        case addSkill = 0
        case userSkills
        case numberOfSections
    }
    
}

protocol UserSkillsViewControllerDelegate {
    
    func newSkillAdded()
}