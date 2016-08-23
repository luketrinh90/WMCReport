//
//  TenthChartViewController.swift
//  WMCReport
//
//  Created by Luân Trịnh on 8/22/16.
//  Copyright © 2016 Luân Trịnh. All rights reserved.
//

import UIKit
import Charts
import ActionSheetPicker_3_0

class TenthChartViewController: UIViewController, ChartViewDelegate {
    
    @IBOutlet weak var btnMenu: UIButton!
    @IBOutlet weak var barChartView: BarChartView!
    @IBOutlet weak var pieChartView1: PieChartView!
    @IBOutlet weak var pieChartView2: PieChartView!
    
    var previous = 0.0
    var change = 0.0
    
    //bar
    var months = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"]
    var unitsSold = [23.0, 25.0, 24.0, 22.0, 21.0, 19.0, 25.0, 24.0, 23.0, 30.0, 20.0, 22.0]
    
    //pie
    let gender = ["Male", "Female"]
    var number = [9563.0, 4687.0]
    
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
        setPieChart1(gender, values: number)
        setPieChart2(gender, values: number)
        setBarChart(months, values: unitsSold)
    }
    
    func setBarChart(dataPoints: [String], values: [Double]) {
        barChartView.noDataText = "You need to provide data for the chart."
        
        var dataEntries: [BarChartDataEntry] = []
        
        for i in 0..<dataPoints.count {
            let dataEntry = BarChartDataEntry(value: values[i], xIndex: i)
            dataEntries.append(dataEntry)
        }
        
        let chartDataSet = BarChartDataSet(yVals: dataEntries, label: "Units Sold")
        chartDataSet.setColor(UIColor(red: 216/255, green: 207/255, blue: 211/255, alpha: 1.0).colorWithAlphaComponent(0.3)) // our line's opacity is 50%
        chartDataSet.valueTextColor = UIColor(red: 138/255, green: 138/255, blue: 138/255, alpha: 1.0)
        chartDataSet.highlightColor = UIColor(red: 216/255, green: 207/255, blue: 211/255, alpha: 1.0)
        
        let data = BarChartData(xVals: dataPoints, dataSet: chartDataSet)
        data.setValueTextColor(UIColor(red: 138/255, green: 138/255, blue: 138/255, alpha: 1.0))
        data.setDrawValues(false)
        
        barChartView.data = data
        barChartView.animate(yAxisDuration: 2, easingOption: .EaseOutBack)
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
    
    func setPieChart1(dataPoints: [String], values: [Double]) {
        
        var dataEntries: [ChartDataEntry] = []
        
        for i in 0..<dataPoints.count {
            let dataEntry = ChartDataEntry(value: values[i], xIndex: i)
            dataEntries.append(dataEntry)
        }
        
        let pieChartDataSet = PieChartDataSet(yVals: dataEntries, label: "Test")
        
        pieChartDataSet.colors = [UIColor(red: 244/255, green: 140/255, blue: 96/255, alpha: 1.0).colorWithAlphaComponent(1.0), UIColor(red: 206/255, green: 74/255, blue: 99/255, alpha: 1.0).colorWithAlphaComponent(1.0)]
        pieChartDataSet.valueTextColor = UIColor(red: 235/255, green: 216/255, blue: 217/255, alpha: 1.0)
        pieChartDataSet.drawValuesEnabled = false
        
        let pieChartData = PieChartData(xVals: dataPoints, dataSet: pieChartDataSet)
        pieChartView1.data = pieChartData
        pieChartView1.animate(xAxisDuration: 2, yAxisDuration: 2, easingOption: .Linear)
        pieChartView1.descriptionText = ""
        pieChartView1.holeColor = UIColor(red: 59/255, green: 70/255, blue: 168/255, alpha: 1.0)
        pieChartView1.legend.enabled = false
    }
    
    func setPieChart2(dataPoints: [String], values: [Double]) {
        
        var dataEntries: [ChartDataEntry] = []
        
        for i in 0..<dataPoints.count {
            let dataEntry = ChartDataEntry(value: values[i], xIndex: i)
            dataEntries.append(dataEntry)
        }
        
        let pieChartDataSet = PieChartDataSet(yVals: dataEntries, label: "Test")
        
        pieChartDataSet.colors = [UIColor(red: 19/255, green: 208/255, blue: 160/255, alpha: 1.0).colorWithAlphaComponent(1.0), UIColor(red: 147/255, green: 146/255, blue: 226/255, alpha: 1.0).colorWithAlphaComponent(1.0)]
        pieChartDataSet.valueTextColor = UIColor(red: 235/255, green: 216/255, blue: 217/255, alpha: 1.0)
        pieChartDataSet.drawValuesEnabled = false
        
        let pieChartData = PieChartData(xVals: dataPoints, dataSet: pieChartDataSet)
        pieChartView2.data = pieChartData
        pieChartView2.animate(xAxisDuration: 2, yAxisDuration: 2, easingOption: .Linear)
        pieChartView2.descriptionText = ""
        pieChartView2.holeColor = UIColor(red: 59/255, green: 70/255, blue: 168/255, alpha: 1.0)
        pieChartView2.legend.enabled = false
    }
    
    @IBAction func onOptionPressed(sender: AnyObject) {
        ActionSheetStringPicker.showPickerWithTitle("Options", rows: ["General", "By Month", "By City", "By Gender", "By Age", "By Nationality"], initialSelection: 0, doneBlock: {
            picker, value, index in
            
            print("value = \(value)")
            print("index = \(index)")
            print("picker = \(picker)")
            
            self.random()
            self.setBarChart(self.months, values: self.unitsSold)
            
            return
            }, cancelBlock: { ActionStringCancelBlock in return }, origin: sender)
    }
    
    func random() {
        for i in 0...months.count - 1 {
            unitsSold[i] = Double(randRange(5, upper: 99))
        }
    }
    
    func randRange(lower: Int , upper: Int) -> Int {
        return lower + Int(arc4random_uniform(UInt32(upper - lower + 1)))
    }
    
    //    func chartValueSelected(chartView: ChartViewBase, entry: ChartDataEntry, dataSetIndex: Int, highlight: ChartHighlight) {
    //
    //        labelCurrent.text = String(format: "%.0f", highlight.value)
    //        labelMonth.text = String(format: "%.0f", unitsSold[getMonth() - 1])
    //
    //        labelLowest.text = String(format: "%.0f", getLowest(unitsSold))
    //        labelHighest.text = String(format: "%.0f", getHighest(unitsSold))
    //
    //        if highlight.value > previous {
    //            labelChange.textColor = UIColor.greenColor()
    //            change = highlight.value - previous
    //            labelChange.text = String(format: "+%.0f", change)
    //        } else {
    //            labelChange.textColor = UIColor.redColor()
    //            change = previous - highlight.value
    //            labelChange.text = String(format: "-%.0f", change)
    //        }
    //        previous = highlight.value
    //    }
    
    func getMonth() -> Int {
        let date = NSDate()
        let calendar = NSCalendar.currentCalendar()
        let components = calendar.components([.Day , .Month , .Year], fromDate: date)
        
        let year =  components.year
        let month = components.month
        let day = components.day
        
        print(year)
        print(month)
        print(day)
        
        return month
    }
    
    func getHighest(set: [Double]) -> Double {
        var highest = set[0]
        for i in 1...set.count - 1 {
            if highest < set[i] {
                highest = set[i]
            }
        }
        return highest
    }
    
    func getLowest(set: [Double]) -> Double {
        var lowest = set[0]
        for i in 1...set.count - 1 {
            if lowest > set[i] {
                lowest = set[i]
            }
        }
        return lowest
    }
    
}
