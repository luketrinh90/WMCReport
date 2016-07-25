//
//  SixthChartViewController.swift
//  WMCReport
//
//  Created by Luân Trịnh on 7/20/16.
//  Copyright © 2016 Luân Trịnh. All rights reserved.
//

import UIKit

class SixthChartViewController: UIViewController {
    
    @IBOutlet weak var btnMenu: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if revealViewController() != nil {
            btnMenu.addTarget(self.revealViewController(), action: (#selector(SWRevealViewController.revealToggle(_:))), forControlEvents: UIControlEvents.TouchUpInside)
            view.addGestureRecognizer(self.revealViewController().tapGestureRecognizer())
            view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.hidden = true
    }
}
