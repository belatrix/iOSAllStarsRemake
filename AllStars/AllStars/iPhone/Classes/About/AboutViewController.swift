//
//  AboutViewController.swift
//  AllStars
//
//  Created by Ricardo Hernan Herrera Valle on 7/14/16.
//  Copyright © 2016 Belatrix SF. All rights reserved.
//

import Foundation


class AboutViewController: UIViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    
    var pageViewController = UIPageViewController()
    
    @IBOutlet weak var pageControl: UIPageControl!
    
    
    lazy var arrayViewControllers : [UIViewController] = {
        
        let controllerTextInfo: UIViewController! = self.storyboard?.instantiateViewControllerWithIdentifier("InfoAboutViewController")
        
        let collaboratorsAbout = self.storyboard?.instantiateViewControllerWithIdentifier("CollaboratorsViewController")
        
        return [controllerTextInfo!, collaboratorsAbout!]
    }()
    
    // MARK: - Initialization
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        pageControl.numberOfPages = arrayViewControllers.count
//        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "ic_nav_header.jpg")!)
    }
    
    // MARK: - Style
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
    }
    
    // MARK: - UIPageViewControllerDataSource
    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
        
        guard let viewControllerIndex = arrayViewControllers.indexOf(viewController) else {
            return nil
        }
        
        let previousIndex = viewControllerIndex - 1
        
        guard previousIndex >= 0 else {
            return arrayViewControllers.last
        }
        
        guard arrayViewControllers.count > previousIndex else {
            return nil
        }
        
        return arrayViewControllers[previousIndex]
    }
    
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
        
        guard let viewControllerIndex = arrayViewControllers.indexOf(viewController) else {
            return nil
        }
        
        let nextIndex = viewControllerIndex + 1
        let orderedViewControllersCount = arrayViewControllers.count
        
        // User is on the last view controller and swiped right to loop to
        // the first view controller.
        guard orderedViewControllersCount != nextIndex else {
            return arrayViewControllers.first
        }
        
        guard orderedViewControllersCount > nextIndex else {
            return nil
        }
        
        return arrayViewControllers[nextIndex]
    }
    
    func pageViewController(pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        
        let currentIndex = arrayViewControllers.indexOf((self.pageViewController.viewControllers?.first)!)
        
        self.pageControl.currentPage = currentIndex!
    }   
    
    
    // MARK: - User interaction
    
    @IBAction func onChangePageControlValue(sender: AnyObject) {
        
        let pageControl = sender as! UIPageControl
        
        let newIndex = pageControl.currentPage
        
        let initialController = arrayViewControllers[newIndex]
        
        let currentIndex = arrayViewControllers.indexOf((self.pageViewController.viewControllers?.first)!)
        
        self.pageViewController.setViewControllers([initialController], direction: currentIndex < newIndex ? UIPageViewControllerNavigationDirection.Forward : UIPageViewControllerNavigationDirection.Reverse, animated: true, completion: nil)
    }
    
    // MARK: - Navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "PageControllerAbout" {
            
            self.pageViewController = segue.destinationViewController as! UIPageViewController
            self.pageViewController.dataSource = self
            self.pageViewController.delegate = self
            
            let controllerInitial = arrayViewControllers.first!
            self.pageViewController.setViewControllers([controllerInitial], direction: UIPageViewControllerNavigationDirection.Forward, animated: false, completion: nil)
        }
    }
}