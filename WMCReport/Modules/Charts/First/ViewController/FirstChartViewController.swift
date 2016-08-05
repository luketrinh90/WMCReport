//
//  FirstChartViewController.swift
//  WMCReport
//
//  Created by Luân Trịnh on 7/13/16.
//  Copyright © 2016 Luân Trịnh. All rights reserved.
//

import UIKit
import Charts
import ActionSheetPicker_3_0

class FirstChartViewController: UIViewController, ChartViewDelegate {
    
    @IBOutlet weak var btnMenu: UIButton!
    @IBOutlet weak var barChartView: BarChartView!
    
    var months = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul"]
    var unitsSold = [20.0, 4.0, 6.0, 3.0, 12.0, 16.0, 4.0]
    
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
        barChartView.delegate = self
        setChart(months, values: unitsSold)
    }
    
    func setChart(dataPoints: [String], values: [Double]) {
        barChartView.noDataText = "You need to provide data for the chart."
        
        var dataEntries: [BarChartDataEntry] = []
        
        for i in 0..<dataPoints.count {
            let dataEntry = BarChartDataEntry(value: values[i], xIndex: i)
            dataEntries.append(dataEntry)
        }
        
        let chartDataSet = BarChartDataSet(yVals: dataEntries, label: "Units Sold")
        chartDataSet.setColor(UIColor(red: 180/255, green: 120/255, blue: 122/255, alpha: 1.0).colorWithAlphaComponent(0.3)) // our line's opacity is 50%
        chartDataSet.valueTextColor = UIColor(red: 138/255, green: 138/255, blue: 138/255, alpha: 1.0)
        
        let data = BarChartData(xVals: dataPoints, dataSet: chartDataSet)
        data.setValueTextColor(UIColor(red: 138/255, green: 138/255, blue: 138/255, alpha: 1.0))
        data.setDrawValues(false)
        
        barChartView.data = data
        barChartView.animate(yAxisDuration: 2, easingOption: .EaseOutBounce)
        barChartView.descriptionText = ""
        
        //
        barChartView.xAxis.enabled = false
        barChartView.legend.enabled = false
        barChartView.leftAxis.enabled = false
        barChartView.rightAxis.enabled = false
        
        // grid lines
        barChartView.xAxis.drawAxisLineEnabled = false
        barChartView.xAxis.drawGridLinesEnabled = false
        barChartView.leftAxis.drawAxisLineEnabled = false
        barChartView.leftAxis.drawGridLinesEnabled = false
        barChartView.rightAxis.drawAxisLineEnabled = false
        barChartView.rightAxis.drawGridLinesEnabled = false
        
        barChartView.doubleTapToZoomEnabled = false
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
        for i in 0...months.count - 1 {
            unitsSold[i] = Double(randRange(0, upper: 99))
        }
    }
    
    func randRange(lower: Int , upper: Int) -> Int {
        return lower + Int(arc4random_uniform(UInt32(upper - lower + 1)))
    }
    
    func chartValueSelected(chartView: ChartViewBase, entry: ChartDataEntry, dataSetIndex: Int, highlight: ChartHighlight) {
        print("HAHHA \(entry)")
    }
}
