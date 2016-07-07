//
//  EventsViewController.swift
//  AllStars
//
//  Created by Flavio Franco Tunqui on 7/1/16.
//  Copyright © 2016 Belatrix SF. All rights reserved.
//

import UIKit

class EventsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate {

    @IBOutlet weak var viewHeader               : UIView!
    @IBOutlet weak var tlbEvents                : UITableView!
    @IBOutlet weak var lblErrorMessage          : UILabel!
    @IBOutlet weak var actLoading               : UIActivityIndicatorView!
    @IBOutlet weak var viewLoading              : UIView!
    
    var isDownload      = false
    var arrayEvents      = NSMutableArray()
    var nextPage        : String? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setViews()
        
        self.listAllEvents()
    }
    
    // MARK: - Style
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
    }
    
    // MARK: - UI
    func setViews() {
        viewHeader.layer.shadowOffset = CGSizeMake(0, 0)
        viewHeader.layer.shadowRadius = 2
        viewHeader.layer.masksToBounds = false
        viewHeader.layer.shadowOpacity = 1
        viewHeader.layer.shadowColor = UIColor.orangeColor().CGColor
        viewHeader.backgroundColor = UIColor.colorPrimary()
    }
    
    // MARK: - IBActions    
    @IBAction func btnBackTUI(sender: UIButton) {
        self.view.endEditing(true)
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    // MARK: - UIScrollViewDelegate
    func scrollViewDidScroll(scrollView: UIScrollView) {
        
        if (self.nextPage != nil && self.isDownload == false && scrollView.contentOffset.y + scrollView.frame.size.height  > scrollView.contentSize.height + 40) {
            
            self.listEventsInNextPage()
        }
    }
    
    // MARK: - UITableViewDelegate, UITableViewDataSource
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrayEvents.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cellIdentifier = "EventTableViewCell"
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! EventTableViewCell
        
        cell.objEvent = self.arrayEvents[indexPath.row] as! Event
        cell.updateData()
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
//        let cell = tableView.cellForRowAtIndexPath(indexPath)
//        cell?.setSelected(false, animated: true)
//        
//        let objBE = self.arrayEvents[indexPath.row]
//        self.performSegueWithIdentifier("ProfileViewController", sender: objBE)
    }
    
//    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
//        
//        let objBE = self.arrayEvents[indexPath.row] as! UserQualifyBE
//        return StarUserInfoTableViewCell.getHeightToCellWithTextDescription(objBE.userQualify_text!)
//    }
    
    // MARK: - WebServices
    func listAllEvents() {
        if (!self.isDownload) {
            self.isDownload = true
            
            self.actLoading.startAnimating()
            self.viewLoading.alpha = CGFloat(!Bool(self.arrayEvents.count))
            self.lblErrorMessage.text = "Loading events"
            
            EventBC.listEventsWithCompletion { (arrayEvents, nextPage) in
                
                self.nextPage = nextPage
                self.arrayEvents = arrayEvents!
                self.tlbEvents.reloadData()
                
                self.actLoading.stopAnimating()
                self.viewLoading.alpha = CGFloat(!Bool(self.arrayEvents.count))
                self.lblErrorMessage.text = "Events not found"
                
                self.isDownload = false
            }
        }
    }
    
    func listEventsInNextPage() {
        if (!self.isDownload) {
//            self.isDownload = true
//            
//            self.acitivityEmployees.startAnimating()
//            self.viewLoading.alpha = CGFloat(!Bool(self.arrayEvents.count))
//            self.lblErrorMessage.text = "Loading employees"
//            
//            
//            SearchBC.listEmployeeToPage(self.nextPage!, withCompletion: { (arrayEmployees, nextPage) in
//                
//                self.nextPage = nextPage
//                
//                let userCountInitial = self.arrayEvents.count
//                self.arrayEvents.addObjectsFromArray(arrayEmployees! as [AnyObject])
//                let userCountFinal = self.arrayEvents.count - 1
//                
//                var arrayIndexPaths = [NSIndexPath]()
//                
//                for row in userCountInitial...userCountFinal {
//                    arrayIndexPaths.append(NSIndexPath(forRow: row, inSection: 0))
//                }
//                
//                self.tlbUsers.insertRowsAtIndexPaths(arrayIndexPaths, withRowAnimation: .Fade)
//                
//                self.acitivityEmployees.stopAnimating()
//                self.viewLoading.alpha = CGFloat(!Bool(self.arrayEvents.count))
//                self.lblErrorMessage.text = "Employees not found"
//                
//                self.isDownload = false
//            })
        }
    }
    
    // MARK: - Navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
//        if segue.identifier == "ProfileViewController" {
//            let controller = segue.destinationViewController as! ProfileViewController
//            controller.objUser = sender as? User
//            controller.backEnable = true
//        }
    }
}