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
    @IBOutlet weak var actUpdating              : UIActivityIndicatorView!
    
    // MARK: - Properties
    var userSkills = [KeywordBE]()
    
    var isDownload = false
    var objUser = User()
    var delegate: EditProfileViewControllerDelegate?
    
    
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
            return true
            
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
                    
                    self.delegate?.skillsListUpdated(self.userSkills.count > 0)
                }
            })
        }
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
                
                self.isDownload = false
                
                self.delegate?.skillsListUpdated(self.userSkills.count > 0)
                
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