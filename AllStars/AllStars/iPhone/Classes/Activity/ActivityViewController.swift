//
//  Activity.swift
//  AllStars
//
//  Created by Ricardo Hernan Herrera Valle on 7/25/16.
//  Copyright © 2016 Belatrix SF. All rights reserved.
//

import Foundation

class ActivityViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate {
    
    // MARK: - IBOutlet
    @IBOutlet weak var viewHeader               : UIView!
    @IBOutlet weak var backButton               : UIButton!
    @IBOutlet weak var tableView                : UITableView!
    
    // MARK: - Properties
    lazy var refreshControl : UIRefreshControl = {
        
        let refreshControl = UIRefreshControl()
        refreshControl.backgroundColor = .clearColor()
        refreshControl.tintColor = UIColor.belatrix()
        refreshControl.addTarget(self, action: #selector(ActivityViewController.listActivities), forControlEvents: .ValueChanged)
        
        return refreshControl
    }()
    
    var activities = [Activity]() {
        didSet{
            
            if self.isViewLoaded() {                
                tableView.reloadData()
            }
        }
    }
    
    var isDownload      = false
    var nextPage        : String? = nil
    
    // MARK: - Initialization
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.addSubview(self.refreshControl)
        setViews()
        listActivities()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        
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
        
        self.refreshControl.endRefreshing()
    }
    
    // MARK: - UI
    func setViews() {
        
        viewHeader.layer.shadowOffset = CGSizeMake(0, 0)
        viewHeader.layer.shadowRadius = 2
        viewHeader.layer.masksToBounds = false
        viewHeader.layer.shadowOpacity = 1
        viewHeader.layer.shadowColor = UIColor.orangeColor().CGColor
        viewHeader.backgroundColor = UIColor.colorPrimary()
        
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 71
    }
    
    func updateActivityCell (cell: ActivityCell, activity: Activity) {
        
        if let datetime = activity.activity_dateTime {
            cell.activityDate.text = OSPDateManager.convertirFecha(datetime, alFormato: "dd MMM yyyy hh:mm a", locale: "en_US")
        } else {
            cell.activityDate.text = "No date"
        }
        
        cell.activityText.text = activity.activity_text
        
        if let avatarURL = activity.activity_avatarURL {
            
            if (activity.activity_avatarURL != "") {
                OSPImageDownloaded.descargarImagenEnURL(avatarURL, paraImageView: cell.senderImage, conPlaceHolder: UIImage(named: "placeholder_general.png"))
                { (correct : Bool, nameImage : String!, image : UIImage!) in
                    
                    if nameImage == avatarURL {
                        cell.senderImage.image = image
                    }
                }
            } else {
                cell.senderImage.image = UIImage(named: "server_icon")
            }
        } else {
            cell.senderImage.image = UIImage(named: "server_icon")
        }
        
        
    }
    
    // MARK: - UIScrollViewDelegate
    func scrollViewDidScroll(scrollView: UIScrollView) {
        
        if (self.nextPage != nil && self.isDownload == false && scrollView.contentOffset.y + scrollView.frame.size.height  > scrollView.contentSize.height + 40) {
            
            self.listActivitiesInNextPage()
        }
    }
    
    // MARK: - UITableViewDelegate, UITableViewDataSource
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return activities.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCellWithIdentifier("activityCell") as? ActivityCell
            else { fatalError("activityCell does not exists")}
        
        let activity = activities[indexPath.row]
        
        self.updateActivityCell(cell, activity: activity)
        
        return cell
    }
    
    // MARK: - User Interaction
    @IBAction func goBack(sender: UIButton) {
        self.view.endEditing(true)
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    // MARK: - Services
    func listActivities() {
        
        if (!self.isDownload) {
            self.isDownload = true
            
            let activityBC = ActivityBC()
            
            activityBC.listActivities { (arrayActivities, nextPage) in
                
                self.refreshControl.endRefreshing()
                self.nextPage = nextPage
                
                guard let activities = arrayActivities where activities.count > 0
                    else { return }
                
                self.activities = activities
                
                self.isDownload = false
            }
        }
    }
    
    func listActivitiesInNextPage() {
        
        if (!self.isDownload && self.nextPage != nil) {
            self.isDownload = true
            
            let activityBC = ActivityBC()
            
            activityBC.listActivitiesToPage (self.nextPage!) { (arrayActivities, nextPage) in
                
                self.refreshControl.endRefreshing()
                self.nextPage = nextPage
                
                guard let activities = arrayActivities where activities.count > 0
                    else { return }
                
                self.activities.appendContentsOf(activities)
                
                self.isDownload = false
            }
        }
    }
}

class ActivityCell: UITableViewCell {
    
    @IBOutlet weak var senderImage: UIImageView!
    @IBOutlet weak var activityDate: UILabel!
    @IBOutlet weak var activityText: UILabel!
}
