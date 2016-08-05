//
//  FifthChartViewController.swift
//  WMCReport
//
//  Created by Luân Trịnh on 7/15/16.
//  Copyright © 2016 Luân Trịnh. All rights reserved.
//

import UIKit
import Charts
import ActionSheetPicker_3_0

class FifthChartViewController: UIViewController {
    
    @IBOutlet weak var btnMenu: UIButton!
    @IBOutlet weak var combinedChartView: CombinedChartView!
    
    let months = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"]
    var set1 = [20.0, 4.0, 17.0, 3.0, 12.0, 32.0, 4.0, 18.0, 2.0, 4.0, 5.0, 4.0]
    var set2 = [50.0, 30.0, 10.0, 15.0, 25.0, 20.0, 17.0, 39.0, 32.0, 46.0, 57.0, 24.0]
    
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

        
        setChart(months, yValuesLineChart: set1, yValuesBarChart: set2)
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
        lineChartSet.setColor(UIColor(red: 255/255, green: 54/255, blue: 75/255, alpha: 1.0).colorWithAlphaComponent(0.5)) // our line's opacity is 50%
        lineChartSet.setCircleColor(UIColor(red: 255/255, green: 54/255, blue: 75/255, alpha: 1.0)) // our circle will be dark red
        lineChartSet.lineWidth = 2.0
        lineChartSet.circleRadius = 6.0 // the radius of the node circle
        lineChartSet.fillAlpha = 65 / 255.0
        lineChartSet.fillColor = UIColor(red: 255/255, green: 54/255, blue: 75/255, alpha: 1.0)
        lineChartSet.highlightColor = UIColor.blueColor()
        lineChartSet.drawCircleHoleEnabled = true
        
        //
        let barChartSet: BarChartDataSet = BarChartDataSet(yVals: yVals2, label: "Bar Data")
        barChartSet.colors = [UIColor(red: 109/255, green: 74/255, blue: 250/255, alpha: 1)]
        
        let data: CombinedChartData = CombinedChartData(xVals: xValues)
        data.barData = BarChartData(xVals: xValues, dataSets: [barChartSet])
        data.lineData = LineChartData(xVals: xValues, dataSets: [lineChartSet])
        data.setValueTextColor(UIColor(red: 138/255, green: 138/255, blue: 138/255, alpha: 1.0))
        
        combinedChartView.data = data
        combinedChartView.animate(xAxisDuration: 2, yAxisDuration: 2, easingOption: .Linear)
        
        combinedChartView.descriptionText = ""
        
        combinedChartView.xAxis.labelPosition = .Bottom
        combinedChartView.xAxis.labelTextColor = UIColor(red: 138/255, green: 138/255, blue: 138/255, alpha: 1.0)
        combinedChartView.leftAxis.labelTextColor = UIColor(red: 138/255, green: 138/255, blue: 138/255, alpha: 1.0)
        
        combinedChartView.rightAxis.enabled = false
        
        // grid lines
        combinedChartView.xAxis.drawAxisLineEnabled = false
        combinedChartView.xAxis.drawGridLinesEnabled = false
        combinedChartView.leftAxis.drawAxisLineEnabled = false
        combinedChartView.leftAxis.drawGridLinesEnabled = false
        combinedChartView.rightAxis.drawAxisLineEnabled = false
        combinedChartView.rightAxis.drawGridLinesEnabled = false
        
        combinedChartView.xAxis.gridColor = UIColor.redColor()
    }
    
    @IBAction func onOptionPressed(sender: AnyObject) {
        ActionSheetStringPicker.showPickerWithTitle("Options", rows: ["General", "By Month", "By City", "By Gender", "By Age", "By Nationality"], initialSelection: 0, doneBlock: {
            picker, value, index in
            
            print("value = \(value)")
            print("index = \(index)")
            print("picker = \(picker)")
            
            self.random()
            self.setChart(self.months, yValuesLineChart: self.set1, yValuesBarChart: self.set2)
            
            return
            }, cancelBlock: { ActionStringCancelBlock in return }, origin: sender)
    }
    
    func random() {
        for i in 0...11 {
            set1[i] = Double(randRange(0, upper: 100))
            set2[i] = Double(randRange(0, upper: 100))
        }
    }
    
    func randRange(lower: Int , upper: Int) -> Int {
        return lower + Int(arc4random_uniform(UInt32(upper - lower + 1)))
    }
}
