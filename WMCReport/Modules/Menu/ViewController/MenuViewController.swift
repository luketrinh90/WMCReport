//
//  MenuViewController.swift
//  WMCReport
//
//  Created by Luân Trịnh on 7/13/16.
//  Copyright © 2016 Luân Trịnh. All rights reserved.
//

import UIKit

class MenuViewController: UIViewController {
    
    @IBOutlet weak var btnMenu: UIButton!
    
    private var activeViewController: UIViewController? {
        didSet {
            removeInactiveViewController(oldValue)
            updateActiveViewController()
        }
    }
    
    private func removeInactiveViewController(inactiveViewController: UIViewController?) {
        if let inActiveVC = inactiveViewController {
            // call before removing child view controller's view from hierarchy
            inActiveVC.willMoveToParentViewController(nil)
            inActiveVC.view.removeFromSuperview()
            // call after removing child view controller's view from hierarchy
            inActiveVC.removeFromParentViewController()
        }
    }
    
    private func updateActiveViewController() {
        if let activeVC = activeViewController {
            // call before adding child view controller's view as subview
            addChildViewController(activeVC)
            
            //iOS 9 still uses 49 points for the Tab Bar (and 64 points for a navigation bar)
            activeVC.view.frame = CGRectMake(0, 0, self.view.frame.width, self.view.frame.height)
            
            self.view.addSubview(activeVC.view)
            
            UIView.transitionWithView(self.view, duration: 0.3, options: .TransitionCrossDissolve, animations: { _ in
                // call before adding child view controller's view as subview
                activeVC.didMoveToParentViewController(self)
                }, completion: nil)
        }
    }
    
    @objc func onRequestForNavigation(notification: NSNotification){
        let notificationInfo:String = notification.object as! String
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        switch notificationInfo {
        case NotificationConstants.ViewController.HomeViewController:
            let vc = storyboard.instantiateViewControllerWithIdentifier(NotificationConstants.ViewController.HomeViewController)
            activeViewController = vc
            break
        case NotificationConstants.ViewController.FirstChartViewController:
            let vc = storyboard.instantiateViewControllerWithIdentifier(NotificationConstants.ViewController.FirstChartViewController)
            activeViewController = vc
            break
        case NotificationConstants.ViewController.SecondChartViewController:
            let vc = storyboard.instantiateViewControllerWithIdentifier(NotificationConstants.ViewController.SecondChartViewController)
            activeViewController = vc
            break
        case NotificationConstants.ViewController.ThirdChartViewController:
            let vc = storyboard.instantiateViewControllerWithIdentifier(NotificationConstants.ViewController.ThirdChartViewController)
            activeViewController = vc
            break
        case NotificationConstants.ViewController.FourthChartViewController:
            let vc = storyboard.instantiateViewControllerWithIdentifier(NotificationConstants.ViewController.FourthChartViewController)
            activeViewController = vc
            break
        case NotificationConstants.ViewController.FifthChartViewController:
            let vc = storyboard.instantiateViewControllerWithIdentifier(NotificationConstants.ViewController.FifthChartViewController)
            activeViewController = vc
            break
        case NotificationConstants.ViewController.SixthChartViewController:
            let vc = storyboard.instantiateViewControllerWithIdentifier(NotificationConstants.ViewController.SixthChartViewController)
            activeViewController = vc
            break
        default:
            break
        }
        btnMenu.sendActionsForControlEvents(.TouchUpInside)
    }
    
    /* Core class */
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if revealViewController() != nil {
            btnMenu.addTarget(self.revealViewController(), action: (#selector(SWRevealViewController.revealToggle(_:))), forControlEvents: UIControlEvents.TouchUpInside)
            
            view.addGestureRecognizer(self.revealViewController().tapGestureRecognizer())
            view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        
        NSNotificationCenter.defaultCenter().addObserver(
            self,
            selector: #selector(MenuViewController.onRequestForNavigation(_:)),
            name: NotificationConstants.Navigation.kNotificationRequestNavigation,
            object: nil)
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewControllerWithIdentifier(NotificationConstants.ViewController.HomeViewController)
        activeViewController = vc
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.hidden = true
    }
}

