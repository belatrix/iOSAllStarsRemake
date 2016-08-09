//
//  UserSkillsViewController.swift
//  AllStars
//
//  Created by Ricardo Hernan Herrera Valle on 8/8/16.
//  Copyright © 2016 Belatrix SF. All rights reserved.
//

import Foundation

class UserSkillsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UserSkillsViewControllerDelegate {
    
    // MARK: - IBOutlets
    @IBOutlet weak var backButton               : UIButton!
    @IBOutlet weak var tableView                : UITableView!
    @IBOutlet weak var titleLabel               : UILabel!
    @IBOutlet weak var viewHeader               : UIView!
    
    // MARK: - Properties
    var userSkills = [KeywordBE]() {
        
        didSet {
            if self.isViewLoaded() {
                self.tableView.reloadData()
            }
        }
    }
    
    var isDownload = false
    var objUser = User()
    
    // MAKR: - Initialization
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
    
    // MARK: - UITableViewDelegate, UITableViewDataSource
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        return Section.numberOfSections.rawValue
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        let selectedSection = Section(rawValue: section)!
        
        switch selectedSection {
        case .addSkill:
            return 1
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
            return true
            
        default:
            fatalError("Invalid section for User skills")
        }
    }
    
    func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
        
        let section = Section(rawValue: indexPath.section)!
        
        switch section {
            
        case .userSkills:
            let action = UITableViewRowAction(style: .Default, title: "Delete", handler: { (action, indexPath) in
                
                let skill = self.userSkills[indexPath.row]
                
                ProfileBC.deleteUserSkill(skill.keyword_name!, withCompletion: { (skills) in
                    
                    self.listAllSkills()
                })
            })
            
            return [action]
            
        default:
            fatalError("Invalid section for User skills action")
        }
        
        return nil
    }
    
    // MARK: - User Interaction
    @IBAction func btnBackTUI(sender: UIButton) {
        self.view.endEditing(true)
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    // MARK: - WebServices
    func listAllSkills() {
        if (!self.isDownload) {
            self.isDownload = true
            
            ProfileBC.getUserSkills(self.objUser, withCompletion: { (skills) in
                
                self.userSkills = skills ?? [KeywordBE]()
                self.tableView.reloadData()
                
                self.isDownload = false
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