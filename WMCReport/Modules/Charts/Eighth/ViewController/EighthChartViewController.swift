//
//  EighthChartViewController.swift
//  WMCReport
//
//  Created by Luân Trịnh on 8/11/16.
//  Copyright © 2016 Luân Trịnh. All rights reserved.
//

import UIKit

class EighthChartViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
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
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 8
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSizeMake(self.view.frame.width/2, self.view.frame.width/2)
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("eighthChartCollectionViewCell", forIndexPath: indexPath) as! EighthChartCollectionViewCell
        
        if indexPath.row == 0 {
            cell.labelDescription.text = "TODAY'S REVENUE"
            cell.labelNumber.text = "17,325,000"
            cell.backgroundColor = UIColor(red: 0/255, green: 172/255, blue: 172/255, alpha: 1.0).colorWithAlphaComponent(0.9)
        } else if indexPath.row == 1 {
            cell.labelDescription.text = "TODAY'S TRANSACTION"
            cell.labelNumber.text = "15"
            cell.backgroundColor = UIColor(red: 0/255, green: 172/255, blue: 172/255, alpha: 1.0).colorWithAlphaComponent(0.85)
        } else if indexPath.row == 2 {
            cell.labelDescription.text = "YESTERDAY'S REVENUE"
            cell.labelNumber.text = "15,294,963"
            cell.backgroundColor = UIColor(red: 52/255, green: 143/255, blue: 226/255, alpha: 1.0).colorWithAlphaComponent(0.9)
        } else if indexPath.row == 3 {
            cell.labelDescription.text = "YESTERDAY'S TRANSACTION"
            cell.labelNumber.text = "23"
            cell.backgroundColor = UIColor(red: 52/255, green: 143/255, blue: 226/255, alpha: 1.0).colorWithAlphaComponent(0.85)
        } else if indexPath.row == 4 {
            cell.labelDescription.text = "CURRENT MONTH'S REVENUE"
            cell.labelNumber.text = "658,242,356"
            cell.backgroundColor = UIColor(red: 114/255, green: 124/255, blue: 182/255, alpha: 1.0).colorWithAlphaComponent(0.9)
        } else if indexPath.row == 5 {
            cell.labelDescription.text = "CURRENT MONTH'S TRANSACTION"
            cell.labelNumber.text = "126"
            cell.backgroundColor = UIColor(red: 114/255, green: 124/255, blue: 182/255, alpha: 1.0).colorWithAlphaComponent(0.85)
        } else if indexPath.row == 6 {
            cell.labelDescription.text = "LAST MONTH'S REVENUE"
            cell.labelNumber.text = "48,654,141,000"
            cell.backgroundColor = UIColor(red: 255/255, green: 91/255, blue: 87/255, alpha: 1.0).colorWithAlphaComponent(0.9)
        } else if indexPath.row == 7 {
            cell.labelDescription.text = "LAST MONTH'S TRANSACTION"
            cell.labelNumber.text = "50,145"
            cell.backgroundColor = UIColor(red: 255/255, green: 91/255, blue: 87/255, alpha: 1.0).colorWithAlphaComponent(0.85)
        }
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, willDisplayCell cell: UICollectionViewCell, forItemAtIndexPath indexPath: NSIndexPath) {
        cell.layer.transform = CATransform3DMakeScale(0.95,0.95,1)
        UIView.animateWithDuration(0.5, animations: {
            cell.layer.transform = CATransform3DMakeScale(1,1,1)
        })
    }
}
