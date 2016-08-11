//
//  MenuCustomViewController.swift
//  WMCReport
//
//  Created by Luân Trịnh on 7/13/16.
//  Copyright © 2016 Luân Trịnh. All rights reserved.
//

import UIKit

class MenuCustomViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func onHomePressed(sender: AnyObject) {
        NSNotificationCenter.defaultCenter().postNotificationName(NotificationConstants.Navigation.kNotificationRequestNavigation, object: NotificationConstants.ViewController.HomeViewController)
    }
    
    @IBAction func onFirstChartPressed(sender: AnyObject) {
        NSNotificationCenter.defaultCenter().postNotificationName(NotificationConstants.Navigation.kNotificationRequestNavigation, object: NotificationConstants.ViewController.FirstChartViewController)
    }
    
    @IBAction func onSecondChartPressed(sender: AnyObject) {
        NSNotificationCenter.defaultCenter().postNotificationName(NotificationConstants.Navigation.kNotificationRequestNavigation, object: NotificationConstants.ViewController.SecondChartViewController)
    }
    
    @IBAction func onThirdChartPressed(sender: AnyObject) {
        NSNotificationCenter.defaultCenter().postNotificationName(NotificationConstants.Navigation.kNotificationRequestNavigation, object: NotificationConstants.ViewController.ThirdChartViewController)
    }
    
    @IBAction func onFourthChartPressed(sender: AnyObject) {
        NSNotificationCenter.defaultCenter().postNotificationName(NotificationConstants.Navigation.kNotificationRequestNavigation, object: NotificationConstants.ViewController.FourthChartViewController)
    }
    
    @IBAction func onFifthChartPressed(sender: AnyObject) {
        NSNotificationCenter.defaultCenter().postNotificationName(NotificationConstants.Navigation.kNotificationRequestNavigation, object: NotificationConstants.ViewController.FifthChartViewController)
    }
    
    @IBAction func onSixthChartPressed(sender: AnyObject) {
        NSNotificationCenter.defaultCenter().postNotificationName(NotificationConstants.Navigation.kNotificationRequestNavigation, object: NotificationConstants.ViewController.SixthChartViewController)
    }
    
    @IBAction func onSeventhChartPressed(sender: AnyObject) {
        NSNotificationCenter.defaultCenter().postNotificationName(NotificationConstants.Navigation.kNotificationRequestNavigation, object: NotificationConstants.ViewController.SeventhChartViewController)
    }
    
    @IBAction func onEighthChartPressed(sender: AnyObject) {
        NSNotificationCenter.defaultCenter().postNotificationName(NotificationConstants.Navigation.kNotificationRequestNavigation, object: NotificationConstants.ViewController.EighthChartViewController)
    }
}
