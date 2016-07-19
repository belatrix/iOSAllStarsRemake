//
//  RankingViewController.swift
//  AllStars
//
//  Created by Kenyi Rodriguez Vergara on 13/05/16.
//  Copyright © 2016 Belatrix SF. All rights reserved.
//

import UIKit

class RankingViewController: UIViewController, UIPageViewControllerDataSource {
    
    @IBOutlet weak var viewHeader   : UIView!
    @IBOutlet weak var sgmRanking   : UISegmentedControl!
    
    var pageViewController = UIPageViewController()
    var currentIndex = 0
    
    lazy var arrayViewControllers : NSMutableArray = {
        
        let _arrayViewControllers = NSMutableArray()
        
        let controllerAllTime = self.storyboard?.instantiateViewControllerWithIdentifier("UserRankingViewController") as! UserRankingViewController
        controllerAllTime.kind = "total_score"
        _arrayViewControllers.addObject(controllerAllTime)
        
        let controllerCurrentMonth = self.storyboard?.instantiateViewControllerWithIdentifier("UserRankingViewController") as! UserRankingViewController
        controllerCurrentMonth.kind = "current_month_score"
        _arrayViewControllers.addObject(controllerCurrentMonth)
        
        
        let controllerLastMonth = self.storyboard?.instantiateViewControllerWithIdentifier("UserRankingViewController") as! UserRankingViewController
        controllerLastMonth.kind = "last_month_score"
        _arrayViewControllers.addObject(controllerLastMonth)
    
        
        return _arrayViewControllers
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        
        setViews()
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
        viewHeader.backgroundColor = UIColor.colorPrimary()
    }
    
    // MARK: - IBActions
    @IBAction func tapSegmented(sender: UISegmentedControl) {
        
        self.assignArrayTableToIndex(sender.selectedSegmentIndex)
    }
    
    func assignArrayTableToIndex(index : Int) {
        
        let initialController = self.arrayViewControllers[index] as! UIViewController
        self.pageViewController.setViewControllers([initialController], direction: self.currentIndex < index ? UIPageViewControllerNavigationDirection.Forward : UIPageViewControllerNavigationDirection.Reverse, animated: true, completion: nil)
        self.currentIndex = index
    }
    
    // MARK: - UIPageViewControllerDataSource
    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
        
        let index = self.arrayViewControllers.indexOfObject(viewController)
        self.currentIndex = index
        self.sgmRanking.selectedSegmentIndex = self.currentIndex
        return index != 0 ? self.arrayViewControllers[index - 1] as? UIViewController : nil
    }
    
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
        
        let index = self.arrayViewControllers.indexOfObject(viewController)
        self.currentIndex = index
        self.sgmRanking.selectedSegmentIndex = self.currentIndex
        return (index == self.arrayViewControllers.count - 1) ? nil : self.arrayViewControllers[index + 1] as? UIViewController
    }
    
    // MARK: - Navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
       
        if segue.identifier == "PageControllerRanking" {
            
            self.pageViewController = segue.destinationViewController as! UIPageViewController
            self.pageViewController.dataSource = self
            
            let controllerInitial = self.arrayViewControllers[0] as! UIViewController
            self.pageViewController.setViewControllers([controllerInitial], direction: UIPageViewControllerNavigationDirection.Forward, animated: false, completion: nil)
        }
    }
}