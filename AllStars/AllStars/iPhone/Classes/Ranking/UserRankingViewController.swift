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
    
    
    
    var arrayUsersTable = NSMutableArray()
    var kind            : String?
    
    
    
    
    
    //MARK: - UITableViewDelegate and UITableViewDataSource
    
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrayUsersTable.count
    }
    
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cellIdentifier = "UserRankingTableViewCell"
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! UserRankingTableViewCell
        
        cell.objUser = self.arrayUsersTable[indexPath.row] as! UserRankingBE
        cell.indexPath = indexPath
        cell.updateData()
        
        return cell
    }
    
    
    
    
    //MARK: - WebService
    
    
    
    func listTotalScore(){
        
        self.acitivityEmployees.startAnimating()
        self.viewLoading.alpha = CGFloat(!Bool(self.arrayUsersTable.count))
        self.lblErrorMessage.text = "Loading employees"
        
        RankingBC.listUserRankingWithKind(self.kind) { (arrayUsersRanking) in
            
            if self.arrayUsersTable.count == 0 {
                
                self.arrayUsersTable = arrayUsersRanking
                self.tlbUsers.reloadData()
            } else{
                
                self.arrayUsersTable = arrayUsersRanking
                
                var arrayIndexPath = [NSIndexPath]()
                for i in 0...self.arrayUsersTable.count - 1 {
                    arrayIndexPath.append(NSIndexPath(forRow: i, inSection: 0))
                }
                
                self.tlbUsers.beginUpdates()
                self.tlbUsers.reloadRowsAtIndexPaths(arrayIndexPath, withRowAnimation: UITableViewRowAnimation.Automatic)
                self.tlbUsers.endUpdates()
                
                self.acitivityEmployees.stopAnimating()
                self.viewLoading.alpha = CGFloat(!Bool(self.arrayUsersTable.count))
                self.lblErrorMessage.text = "Employees not found"
            }
        }
    }
    
    
  
    
    override func viewDidLoad() {
        
        self.listTotalScore()
        super.viewDidLoad()

        
    }

    
    override func viewWillAppear(animated: Bool) {
        
        self.listTotalScore()
        
        super.viewWillAppear(animated)
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        
        return .LightContent
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
