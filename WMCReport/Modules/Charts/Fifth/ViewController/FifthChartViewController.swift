//
//  FifthChartViewController.swift
//  WMCReport
//
//  Created by Luân Trịnh on 7/15/16.
//  Copyright © 2016 Luân Trịnh. All rights reserved.
//

import UIKit
import Charts

class FifthChartViewController: UIViewController {
    
    @IBOutlet weak var btnMenu: UIButton!
    @IBOutlet weak var combinedChartView: CombinedChartView!
    var months: [String]?
    
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
        months = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"]
        let set1 = [20.0, 4.0, 17.0, 3.0, 12.0, 32.0, 4.0, 18.0, 2.0, 4.0, 5.0, 4.0]
        let set2 = [50.0, 30.0, 10.0, 15.0, 25.0, 20.0, 17.0, 39.0, 32.0, 46.0, 57.0, 24.0]
        
        setChart(months!, yValuesLineChart: set1, yValuesBarChart: set2)
    }
    
    func setChart(xValues: [String], yValuesLineChart: [Double], yValuesBarChart: [Double]) {
        combinedChartView.noDataText = "Please provide data for the chart."
        
        var yVals1 : [ChartDataEntry] = [ChartDataEntry]()
        var yVals2 : [BarChartDataEntry] = [BarChartDataEntry]()
        
        for i in 0..<xValues.count {
            yVals1.append(ChartDataEntry(value: yValuesLineChart[i], xIndex: i))
            yVals2.append(BarChartDataEntry(value: yValuesBarChart[i] - 1, xIndex: i))
        }
        
        //
        let lineChartSet = LineChartDataSet(yVals: yVals1, label: "Line Data")
        lineChartSet.setColor(UIColor.redColor().colorWithAlphaComponent(0.5)) // our line's opacity is 50%
        lineChartSet.setCircleColor(UIColor.redColor()) // our circle will be dark red
        lineChartSet.lineWidth = 2.0
        lineChartSet.circleRadius = 6.0 // the radius of the node circle
        lineChartSet.fillAlpha = 65 / 255.0
        lineChartSet.fillColor = UIColor.redColor()
        lineChartSet.highlightColor = UIColor.whiteColor()
        lineChartSet.drawCircleHoleEnabled = true
        
        //
        let barChartSet: BarChartDataSet = BarChartDataSet(yVals: yVals2, label: "Bar Data")
        
        
        let data: CombinedChartData = CombinedChartData(xVals: xValues)
        data.barData = BarChartData(xVals: xValues, dataSets: [barChartSet])
        data.lineData = LineChartData(xVals: xValues, dataSets: [lineChartSet])
        
        combinedChartView.data = data
    }
}
