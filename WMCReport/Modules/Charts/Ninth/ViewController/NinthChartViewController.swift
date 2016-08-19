//
//  NinthChartViewController.swift
//  WMCReport
//
//  Created by Luân Trịnh on 8/19/16.
//  Copyright © 2016 Luân Trịnh. All rights reserved.
//

import UIKit
import Charts
import ActionSheetPicker_3_0

class NinthChartViewController: UIViewController, ChartViewDelegate {
    
    @IBOutlet weak var btnMenu: UIButton!
    @IBOutlet weak var lineChartView: LineChartView!
    @IBOutlet weak var labelCurrent: UILabel!
    @IBOutlet weak var labelType: UILabel!
    @IBOutlet weak var labelChange: UILabel!
    @IBOutlet weak var labelAvg: UILabel!
    @IBOutlet weak var labelMonth: UILabel!
    @IBOutlet weak var labelLowest: UILabel!
    @IBOutlet weak var labelHighest: UILabel!
    @IBOutlet weak var labelTotal: UILabel!
    
    var previous = 0.0
    var change = 0.0
    
    let months = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"]
    var set1 = [23.1, 25.3, 24.4, 22.2, 21.6, 19.5, 25.7, 24.9, 23.8, 30.12, 20.88, 22.93]
    
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
        lineChartView.delegate = self
        setChart(months, set1: set1)
    }
    
    func setChart(months : [String], set1: [Double]) {
        // 1 - creating an array of data entries
        var yVals1 : [ChartDataEntry] = [ChartDataEntry]()
        for i in 0 ..< months.count {
            yVals1.append(ChartDataEntry(value: set1[i], xIndex: i))
        }
        
        // 2 - create a data set with our array
        let set1: LineChartDataSet = LineChartDataSet(yVals: yVals1, label: "First Set")
        set1.axisDependency = .Left // Line will correlate with left axis values
        set1.setColor(UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1.0).colorWithAlphaComponent(1.0)) // our line's opacity is 50%
        set1.setCircleColor(UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1.0)) // our circle will be dark red
        set1.lineWidth = 3.0
        set1.circleRadius = 0.0 // the radius of the node circle
        set1.fillAlpha = 65 / 255.0
        set1.fillColor = UIColor(red: 115/255, green: 139/255, blue: 163/255, alpha: 1.0)
        set1.highlightColor = UIColor.whiteColor()
        set1.drawCircleHoleEnabled = false
        set1.mode = .CubicBezier
        set1.drawFilledEnabled = true
        
        //3 - create an array to store our LineChartDataSets
        var dataSets : [LineChartDataSet] = [LineChartDataSet]()
        dataSets.append(set1)
        
        //4 - pass our months in for our x-axis label value along with our dataSets
        let data: LineChartData = LineChartData(xVals: months, dataSets: dataSets)
        data.setValueTextColor(UIColor(red: 138/255, green: 138/255, blue: 138/255, alpha: 1.0))
        data.setDrawValues(false)
        
        //5 - finally set our data
        lineChartView.data = data
        lineChartView.animate(xAxisDuration: 1, easingOption: .Linear)
        lineChartView.descriptionText = ""
        
        //
        lineChartView.xAxis.enabled = false
        lineChartView.legend.enabled = false
        lineChartView.leftAxis.enabled = false
        lineChartView.rightAxis.enabled = false
        
        // grid lines
        lineChartView.xAxis.drawAxisLineEnabled = false
        lineChartView.xAxis.drawGridLinesEnabled = false
        lineChartView.leftAxis.drawAxisLineEnabled = false
        lineChartView.leftAxis.drawGridLinesEnabled = false
        lineChartView.rightAxis.drawAxisLineEnabled = false
        lineChartView.rightAxis.drawGridLinesEnabled = false
        
        lineChartView.doubleTapToZoomEnabled = false
    }
    
    @IBAction func onOptionPressed(sender: AnyObject) {
        ActionSheetStringPicker.showPickerWithTitle("Options", rows: ["General", "By Month", "By City", "By Gender", "By Age", "By Nationality"], initialSelection: 0, doneBlock: {
            picker, value, index in
            
            self.labelType.text = String(index)
            
            print("value = \(value)")
            print("index = \(index)")
            print("picker = \(picker)")
            
            self.random()
            self.setChart(self.months, set1: self.set1)
            
            return
            }, cancelBlock: { ActionStringCancelBlock in return }, origin: sender)
    }
    
    func random() {
        for i in 0...11 {
            set1[i] = Double(randRange(0, upper: 99))
        }
    }
    
    func randRange(lower: Int , upper: Int) -> Int {
        return lower + Int(arc4random_uniform(UInt32(upper - lower + 1)))
    }
    
    func chartValueSelected(chartView: ChartViewBase, entry: ChartDataEntry, dataSetIndex: Int, highlight: ChartHighlight) {
        labelCurrent.text = String(format: "%.0f", highlight.value)
        labelLowest.text = String(format: "%.0f", getLowest(set1))
        labelHighest.text = String(format: "%.0f", getHighest(set1))
        labelTotal.text = String(format: "%.0f", getTotal(set1))
        labelMonth.text = String(format: "%.0f", set1[getMonth() - 1])
        labelAvg.text = String(format: "%.2f", getAvg(set1))
        
        if highlight.value > previous {
            labelChange.textColor = UIColor.greenColor()
            change = highlight.value - previous
        } else {
            labelChange.textColor = UIColor.redColor()
            change = previous - highlight.value
        }
        previous = highlight.value
        labelChange.text = String(format: "%.0f", change)
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
    
    func getTotal(set: [Double]) -> Double {
        var total = 0.0
        for i in 1...set.count - 1 {
            total += set[i]
        }
        return total
    }
    
    func getAvg(set: [Double]) -> Double {
        var total = 0.0
        for i in 1...set.count - 1 {
            total += set[i]
        }
        return total / Double(set.count)
    }
    
    func getMonth() -> Int {
        let date = NSDate()
        let calendar = NSCalendar.currentCalendar()
        let components = calendar.components([.Day , .Month , .Year], fromDate: date)
        
        let year = components.year
        let month = components.month
        let day = components.day
        
        print(year)
        print(month)
        print(day)
        
        return month
    }
}
