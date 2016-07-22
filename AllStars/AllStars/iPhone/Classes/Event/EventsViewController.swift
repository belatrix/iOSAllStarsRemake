//
//  EventsViewController.swift
//  AllStars
//
//  Created by Flavio Franco Tunqui on 7/1/16.
//  Copyright © 2016 Belatrix SF. All rights reserved.
//

import UIKit

class EventsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate, UISearchBarDelegate {

    @IBOutlet weak var viewHeader               : UIView!
    @IBOutlet weak var tlbEvents                : UITableView!
    @IBOutlet weak var lblErrorMessage          : UILabel!
    @IBOutlet weak var actLoading               : UIActivityIndicatorView!
    @IBOutlet weak var viewLoading              : UIView!
    @IBOutlet weak var backButton               : UIButton!
    @IBOutlet weak var searchEvents             : UISearchBar!
    
    var isDownload      = false
    var arrayEvents      = NSMutableArray()
    var nextPage        : String? = nil
    var selectedEvent   : Event!
    var searchText : String  = ""
    
    lazy var refreshControl : UIRefreshControl = {
        let _refreshControl = UIRefreshControl()
        _refreshControl.backgroundColor = .clearColor()
        _refreshControl.tintColor = UIColor.belatrix()
        _refreshControl.addTarget(self, action: #selector(EventsViewController.listAllEvents), forControlEvents: .ValueChanged)
        
        return _refreshControl
    }()
    
    // MARK: - Initialization
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setViews()
        
        self.listAllEvents()
        
        tlbEvents.rowHeight = UITableViewAutomaticDimension
        tlbEvents.estimatedRowHeight = 60
        
        tlbEvents.addSubview(self.refreshControl)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        UIApplication.sharedApplication().statusBarStyle = UIStatusBarStyle.LightContent
        
        if let backButton = self.backButton {
            
            if let nav = self.navigationController where nav.viewControllers.count > 1 {
                
                backButton.hidden = false
            } else {
                
                backButton.hidden = true
            }
        }
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
        viewHeader.layer.shadowOffset = CGSizeMake(0, 0)
        viewHeader.layer.shadowRadius = 2
        viewHeader.layer.masksToBounds = false
        viewHeader.layer.shadowOpacity = 1
        viewHeader.layer.shadowColor = UIColor.orangeColor().CGColor
        viewHeader.backgroundColor = UIColor.colorPrimary()
        
        searchEvents.backgroundImage = UIImage()
        searchEvents.backgroundColor = .clearColor()
        searchEvents.barTintColor = .clearColor()
    }
    
    // MARK: - IBActions    
    @IBAction func btnBackTUI(sender: UIButton) {
        self.view.endEditing(true)
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    // MARK: - UIScrollViewDelegate
    func scrollViewDidScroll(scrollView: UIScrollView) {
        
        if (self.nextPage != nil && self.isDownload == false && scrollView.contentOffset.y + scrollView.frame.size.height  > scrollView.contentSize.height + 40) {
            
            self.listEventsInNextPage()
        }
    }
    
    // MARK: - UISearchBarDelegate
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        self.searchEvents.text = ""
        self.listAllEvents()
        self.searchEvents.resignFirstResponder()
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        
        searchEvents.resignFirstResponder()
    }
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        
        self.searchText = searchText.characters.count > 0 ? searchText : ""
        
        if self.searchText.characters.count == 0 {
            self.listAllEvents()
        }else{
            self.listEventsToSearchText()
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
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        guard let selectedEvent = arrayEvents[indexPath.row] as? Event
            else { return }
        
        self.selectedEvent = selectedEvent
        
        self.performSegueWithIdentifier("ToEventDetail", sender: nil)
    }
    
    // MARK: - WebServices
    func listAllEvents() {
        if (!self.isDownload) {
            self.isDownload = true
            
            self.actLoading.startAnimating()
            self.viewLoading.alpha = CGFloat(!Bool(self.arrayEvents.count))
            self.lblErrorMessage.text = "Loading events"
            
            EventBC.listAllEventsWithCompletion { (arrayEvents, nextPage) in
                
                self.updateUIAfterSearch(arrayEvents, nextPage: nextPage ?? "")
            }
        }
    }
    
    func listEventsToSearchText() {
//        if (!self.isDownload) {
//            self.isDownload = true
//            
            self.actLoading.startAnimating()
            self.viewLoading.alpha = CGFloat(!Bool(self.arrayEvents.count))
            self.lblErrorMessage.text = "Loading events"
            
            EventBC.listEventsWithKeyword(self.searchText) { (arrayEvents, nextPage) in
                
                self.updateUIAfterSearch(arrayEvents, nextPage: nextPage ?? "")
            }
//        }
    }
    
    func updateUIAfterSearch(arrayEvents: NSMutableArray?, nextPage: String) {
        
        self.refreshControl.endRefreshing()
        
        self.nextPage = nextPage
        self.arrayEvents = arrayEvents!
        self.tlbEvents.reloadData()
        
        self.actLoading.stopAnimating()
        self.viewLoading.alpha = CGFloat(!Bool(self.arrayEvents.count))
        self.lblErrorMessage.text = "Events not found"
        
        self.isDownload = false
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
        
        if segue.identifier == "ToEventDetail" {
            let eventDetailController = segue.destinationViewController as! EventDetailViewController
            eventDetailController.event = selectedEvent
        }
    }
}