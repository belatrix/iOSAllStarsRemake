//
//  AboutViewController.swift
//  AllStars
//
//  Created by Ricardo Hernan Herrera Valle on 7/14/16.
//  Copyright © 2016 Belatrix SF. All rights reserved.
//

import Foundation
import MessageUI

class AboutViewController: UIViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate, MFMailComposeViewControllerDelegate {
    
    // MARK: - Main view variables
    var pageViewController = UIPageViewController()
    
    @IBOutlet weak var pageControl: UIPageControl!
    
    // MARK: - Info Texts variables
    
    @IBOutlet weak var whatLabel: UILabel!
    @IBOutlet weak var whatLabelText: UILabel!
    @IBOutlet weak var whyLabel: UILabel!
    @IBOutlet weak var whyLabelText: UILabel!
    @IBOutlet weak var whoLabel: UILabel!
    @IBOutlet weak var whoLabelText: UILabel!
    
    // MARK: - Lincense variables
    @IBOutlet weak var licenseTextView: UITextView!
    
    lazy var arrayViewControllers : [UIViewController] = {
        
        let controllerTextInfo: UIViewController! = self.storyboard?.instantiateViewControllerWithIdentifier("InfoAboutViewController")
        
        let collaboratorsAbout = self.storyboard?.instantiateViewControllerWithIdentifier("CollaboratorsViewController")
        
        let licenseAbout = self.storyboard?.instantiateViewControllerWithIdentifier("LicenseViewController")
        
        return [controllerTextInfo!, collaboratorsAbout!, licenseAbout!]
    }()
    
    // MARK: - Initialization
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let pageControl = self.pageControl
            else {                
                settexts()
                return
        }
        
        pageControl.numberOfPages = arrayViewControllers.count
        
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        print(self.navigationController?.viewControllers.first)
        print(self.tabBarController?.moreNavigationController.viewControllers.first)
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
    
    func settexts() {
        
        setInfoTexts()
        setLicenseText()
    }
    
    func setInfoTexts() {
        
        guard let _ = self.whatLabel
            else { return }
        
        whatLabel.text = "what".localized
        whatLabelText.text = "about_what".localized
        whyLabel.text = "why".localized
        whyLabelText.text = "about_why".localized
        whoLabel.text = "who".localized
        whoLabelText.text = "about_who".localized
    }
    
    func setLicenseText(){
        
        guard let license = self.licenseTextView
            else { return }
        
        license.text = "about_license".localized
        license.textColor = UIColor.whiteColor()
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
    
    @IBAction func goBack(sender: AnyObject) {
        
        self.navigationController?.popViewControllerAnimated(true)
    }
    @IBAction func sendMessage(sender: AnyObject) {
        
        self.sendEmail()
    }
    
    func sendEmail() {
        if MFMailComposeViewController.canSendMail() {
            let mail = MFMailComposeViewController()
            mail.mailComposeDelegate = self
            mail.setToRecipients(["email_support".localized])
            mail.setSubject("email_subject".localized)
            
            presentViewController(mail, animated: true, completion: nil)
        } else {
            // show failure alert
            
            let alert: UIAlertController = UIAlertController(title: "email_error_message".localized, message: nil, preferredStyle: .ActionSheet)
            
            
            let cancelAction = UIAlertAction(title: "ok".localized, style: .Cancel,
                                             handler: nil)

            alert.addAction(cancelAction)
            
            self.presentViewController(alert, animated: true, completion: {})
        }
    }
    
    // MARK: - MFMailComposeViewControllerDelegate
    func mailComposeController(controller: MFMailComposeViewController, didFinishWithResult result: MFMailComposeResult, error: NSError?) {
        controller.dismissViewControllerAnimated(true, completion: nil)
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