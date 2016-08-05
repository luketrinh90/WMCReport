//
//  SecondChartViewController.swift
//  WMCReport
//
//  Created by Luân Trịnh on 7/14/16.
//  Copyright © 2016 Luân Trịnh. All rights reserved.
//

import UIKit
import Charts
import ActionSheetPicker_3_0

class SecondChartViewController: UIViewController, ChartViewDelegate {
    
    @IBOutlet weak var btnMenu: UIButton!
    @IBOutlet weak var lineChartView: LineChartView!
    
    @IBOutlet weak var labelCurrent: UILabel!
    @IBOutlet weak var labelChart: UILabel!
    @IBOutlet weak var labelMonth: UILabel!
    @IBOutlet weak var labelAll: UILabel!
    
    let months = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"]
    var set1 = [20.0, 4.0, 17.0, 3.0, 12.0, 32.0, 4.0, 18.0, 2.0, 4.0, 5.0, 4.0]
    var set2 = [50.0, 30.0, 10.0, 15.0, 25.0, 20.0, 17.0, 39.0, 32.0, 46.0, 57.0, 1.0]
    
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
        setChart(months, set1: set1, set2: set2)
    }
    
    func setChart(months : [String], set1: [Double], set2: [Double]) {
        // 1 - creating an array of data entries
        var yVals1 : [ChartDataEntry] = [ChartDataEntry]()
        for i in 0 ..< months.count {
            yVals1.append(ChartDataEntry(value: set1[i], xIndex: i))
        }
        
        // 2 - create a data set with our array
        let set1: LineChartDataSet = LineChartDataSet(yVals: yVals1, label: "Revenue")
        set1.axisDependency = .Left // Line will correlate with left axis values
        set1.setColor(UIColor(red: 255/255, green: 54/255, blue: 75/255, alpha: 1.0).colorWithAlphaComponent(0.5)) // our line's opacity is 50%
        set1.setCircleColor(UIColor(red: 255/255, green: 54/255, blue: 75/255, alpha: 1.0)) // our circle will be dark red
        set1.lineWidth = 2.0
        set1.circleRadius = 6.0 // the radius of the node circle
        set1.fillAlpha = 65 / 255.0
        set1.fillColor = UIColor(red: 255/255, green: 54/255, blue: 75/255, alpha: 1.0)
        set1.highlightColor = UIColor.whiteColor()
        set1.drawCircleHoleEnabled = true
        
        //////////////////////////////////////////////////////////////////////////////////
        
        var yVals2 : [ChartDataEntry] = [ChartDataEntry]()
        for i in 0 ..< months.count {
            yVals2.append(ChartDataEntry(value: set2[i], xIndex: i))
        }
        
        let set2: LineChartDataSet = LineChartDataSet(yVals: yVals2, label: "Amount")
        set2.axisDependency = .Left // Line will correlate with left axis values
        set2.setColor(UIColor(red: 109/255, green: 74/255, blue: 250/255, alpha: 1.0).colorWithAlphaComponent(0.5))
        set2.setCircleColor(UIColor(red: 109/255, green: 74/255, blue: 250/255, alpha: 1.0))
        set2.lineWidth = 2.0
        set2.circleRadius = 6.0
        set2.fillAlpha = 65 / 255.0
        
        set2.fillColor = UIColor(red: 109/255, green: 74/255, blue: 250/255, alpha: 1.0)
        set2.highlightColor = UIColor.whiteColor()
        set2.drawCircleHoleEnabled = true
        
        //3 - create an array to store our LineChartDataSets
        var dataSets : [LineChartDataSet] = [LineChartDataSet]()
        dataSets.append(set1)
        dataSets.append(set2)
        
        //4 - pass our months in for our x-axis label value along with our dataSets
        let data: LineChartData = LineChartData(xVals: months, dataSets: dataSets)
        data.setValueTextColor(UIColor(red: 138/255, green: 138/255, blue: 138/255, alpha: 1.0))
        data.setDrawValues(false)
        
        //5 - finally set our data
        lineChartView.data = data
        lineChartView.animate(xAxisDuration: 2, yAxisDuration: 2, easingOption: .Linear)
        lineChartView.descriptionText = ""
        
        //
        lineChartView.xAxis.enabled = false
        lineChartView.legend.textColor = UIColor.whiteColor()
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
            
            print("value = \(value)")
            print("index = \(index)")
            print("picker = \(picker)")
            
            self.random()
            self.setChart(self.months, set1: self.set1, set2: self.set2)
            
            return
            }, cancelBlock: { ActionStringCancelBlock in return }, origin: sender)
    }
    
    func random() {
        for i in 0...11 {
            set1[i] = Double(randRange(1, upper: 69))
            set2[i] = Double(randRange(29, upper: 99))
        }
    }
    
    func randRange(lower: Int , upper: Int) -> Int {
        return lower + Int(arc4random_uniform(UInt32(upper - lower + 1)))
    }
    
    func chartValueSelected(chartView: ChartViewBase, entry: ChartDataEntry, dataSetIndex: Int, highlight: ChartHighlight) {
        labelCurrent.text = String(format: "%.0f", highlight.value)
        labelChart.text = String(dataSetIndex)
        
        if dataSetIndex == 0 {
            labelChart.textColor = UIColor(red: 255/255, green: 54/255, blue: 75/255, alpha: 1.0).colorWithAlphaComponent(0.5)
            labelMonth.text = String(format: "%.0f", set1[getMonth() - 1])
            labelAll.text = String(format: "%.0f", getHighest(set1))
        } else {
            labelChart.textColor = UIColor(red: 109/255, green: 74/255, blue: 250/255, alpha: 1.0).colorWithAlphaComponent(0.5)
            labelMonth.text = String(format: "%.0f", set2[getMonth() - 1])
            labelAll.text = String(format: "%.0f", getHighest(set2))
        }
    }
    
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
}
