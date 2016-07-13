//
//  ContainerViewController.swift
//  WMCLoyaltySwift
//
//  Created by Duy Nguyen on 6/10/15.
//  Copyright © 2015 dinosys. All rights reserved.
//

import UIKit

class ContainerViewController: UIViewController {
    
    /* Container view helper classes */
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
            
            activeVC.view.frame = self.view.bounds
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
        case NotificationConstants.ViewController.SWRevealViewController:
            let vc = storyboard.instantiateViewControllerWithIdentifier(NotificationConstants.ViewController.SWRevealViewController)
            activeViewController = vc
            break
        case NotificationConstants.ViewController.LoginViewController:
            let vc = storyboard.instantiateViewControllerWithIdentifier(NotificationConstants.ViewController.LoginViewController)
            activeViewController = vc
            break
        default:
            break
        }
    }
    
    /* Core class */
    override func viewDidLoad() {
        super.viewDidLoad()
        NSNotificationCenter.defaultCenter().addObserver(
            self,
            selector: #selector(ContainerViewController.onRequestForNavigation(_:)),
            name: NotificationConstants.Navigation.kNotificationRequestNavigation,
            object: nil)
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewControllerWithIdentifier(NotificationConstants.ViewController.SWRevealViewController)
        
        activeViewController = vc
    }
}
