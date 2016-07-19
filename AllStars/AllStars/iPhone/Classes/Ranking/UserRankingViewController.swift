//
//  UserRankingViewController.swift
//  AllStars
//
//  Created by Kenyi Rodriguez Vergara on 16/05/16.
//  Copyright © 2016 Belatrix SF. All rights reserved.
//

import UIKit

class UserRankingViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tlbUsers                 : UITableView!
    @IBOutlet weak var viewLoading              : UIView!
    @IBOutlet weak var lblErrorMessage          : UILabel!
    @IBOutlet weak var acitivityEmployees       : UIActivityIndicatorView!
    
    var arrayUsers      = NSMutableArray()
    var kind            : String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.listTotalScore()
    }
    
    // MARK: - Style
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
    }
    
    // MARK: - UITableViewDelegate, UITableViewDataSource
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrayUsers.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cellIdentifier = "UserRankingTableViewCell"
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! UserRankingTableViewCell
        
        cell.objUser = self.arrayUsers[indexPath.row] as! UserRankingBE
        cell.indexPath = indexPath
        cell.updateData()
        
        return cell
    }
    
    //MARK: - WebService
    func listTotalScore(){
        
        self.acitivityEmployees.startAnimating()
        self.viewLoading.alpha = CGFloat(!Bool(self.arrayUsers.count))
        self.lblErrorMessage.text = "Loading employees"
        
        RankingBC.listUserRankingWithKind(self.kind) {(arrayUsersRanking) in
            
            self.acitivityEmployees.stopAnimating()
            
            self.arrayUsers = arrayUsersRanking!
            
            self.lblErrorMessage.text = "no_availables_employees".localized
            self.viewLoading.alpha = CGFloat(!Bool(self.arrayUsers.count))
            
            self.tlbUsers.reloadData()
        }
    }
}