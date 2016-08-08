//
//  SixthChartViewController.swift
//  WMCReport
//
//  Created by Luân Trịnh on 7/20/16.
//  Copyright © 2016 Luân Trịnh. All rights reserved.
//

import UIKit
import Charts
import ActionSheetPicker_3_0

class SixthChartViewController: UIViewController {
    
    @IBOutlet weak var btnMenu: UIButton!
    @IBOutlet weak var pieChartView: PieChartView!
    
    let months = ["Male", "Female"]
    var unitsSold = [9563.0, 4687.0]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initFirst()
        
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
    
    func initFirst() {
        setChart(months, values: unitsSold)
    }
    
    func setChart(dataPoints: [String], values: [Double]) {
        
        var dataEntries: [ChartDataEntry] = []
        
        for i in 0..<dataPoints.count {
            let dataEntry = ChartDataEntry(value: values[i], xIndex: i)
            dataEntries.append(dataEntry)
        }
        
        let pieChartDataSet = PieChartDataSet(yVals: dataEntries, label: "Population")
        
        pieChartDataSet.colors = [UIColor(red: 244/255, green: 140/255, blue: 96/255, alpha: 1.0).colorWithAlphaComponent(1.0), UIColor(red: 206/255, green: 74/255, blue: 99/255, alpha: 1.0).colorWithAlphaComponent(1.0)]
        pieChartDataSet.valueTextColor = UIColor(red: 235/255, green: 216/255, blue: 217/255, alpha: 1.0)
        
        let pieChartData = PieChartData(xVals: dataPoints, dataSet: pieChartDataSet)
        //pieChartData.setValueTextColor(UIColor(red: 138/255, green: 138/255, blue: 138/255, alpha: 1.0))
        
        pieChartView.data = pieChartData
        pieChartView.animate(xAxisDuration: 2, yAxisDuration: 2, easingOption: .Linear)
        pieChartView.descriptionText = ""
        pieChartView.legend.enabled = false
    }
    
    @IBAction func onOptionPressed(sender: AnyObject) {
        ActionSheetStringPicker.showPickerWithTitle("Options", rows: ["General", "By Month", "By City", "By Gender", "By Age", "By Nationality"], initialSelection: 0, doneBlock: {
            picker, value, index in
            
            print("value = \(value)")
            print("index = \(index)")
            print("picker = \(picker)")
            
            self.random()
            self.setChart(self.months, values: self.unitsSold)
            
            return
            }, cancelBlock: { ActionStringCancelBlock in return }, origin: sender)
    }
    
    func random() {
        for i in 0...1 {
            unitsSold[i] = Double(randRange(999, upper: 9999))
        }
    }
    
    func randRange(lower: Int , upper: Int) -> Int {
        return lower + Int(arc4random_uniform(UInt32(upper - lower + 1)))
    }
}
