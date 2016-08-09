//
//  ThirdChartViewController.swift
//  WMCReport
//
//  Created by Luân Trịnh on 7/14/16.
//  Copyright © 2016 Luân Trịnh. All rights reserved.
//

import UIKit
import Charts
import ActionSheetPicker_3_0

class ThirdChartViewController: UIViewController, ChartViewDelegate {
    
    @IBOutlet weak var btnMenu: UIButton!
    @IBOutlet weak var bubbleChartView: BubbleChartView!
    
    @IBOutlet weak var labelCurrent: UILabel!
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
        bubbleChartView.delegate = self
        setChart(months, set1: set1, set2: set2)
    }
    
    func setChart(dataPoints: [String], set1: [Double], set2: [Double]) {
        var dataEntries1: [BubbleChartDataEntry] = []
        var dataEntries2: [BubbleChartDataEntry] = []
        
        for i in 0..<dataPoints.count {
            let dataEntry = BubbleChartDataEntry(xIndex: i, value: set1[i], size: CGFloat(set1[i]))
            dataEntries1.append(dataEntry)
        }
        
        for i in 0..<dataPoints.count {
            let dataEntry = BubbleChartDataEntry(xIndex: i, value: set2[i], size: CGFloat(set2[i]))
            dataEntries2.append(dataEntry)
        }
        
        let chartData1 = BubbleChartDataSet(yVals: dataEntries1,label: "amount" )
        let chartData2 = BubbleChartDataSet(yVals: dataEntries2,label: "revenue")
        
        chartData1.drawValuesEnabled = false
        chartData2.drawValuesEnabled = false
        
        chartData1.colors = [UIColor(red: 220/255, green: 202/255, blue: 44/255, alpha: 1)]
        chartData2.colors = [UIColor(red: 99/255, green: 207/255, blue: 228/255, alpha: 1)]
        
        let dataSets: [BubbleChartDataSet] = [chartData1,chartData2]
        
        let data = BubbleChartData(xVals: dataPoints, dataSets: dataSets)
        data.setDrawValues(false)
        
        bubbleChartView.data = data
        bubbleChartView.descriptionText = ""
        bubbleChartView.animate(xAxisDuration: 2, yAxisDuration: 2, easingOption: .EaseOutBack)
        
        bubbleChartView.xAxis.labelPosition = .Bottom
        bubbleChartView.xAxis.labelTextColor = UIColor(red: 138/255, green: 138/255, blue: 138/255, alpha: 1.0)
        bubbleChartView.leftAxis.labelTextColor = UIColor(red: 138/255, green: 138/255, blue: 138/255, alpha: 1.0)
        
        //
        bubbleChartView.xAxis.enabled = false
        bubbleChartView.legend.enabled = false
        bubbleChartView.leftAxis.enabled = false
        bubbleChartView.rightAxis.enabled = false
        
        bubbleChartView.doubleTapToZoomEnabled = false
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
            set1[i] = Double(randRange(5, upper: 40))
            set2[i] = Double(randRange(5, upper: 60))
        }
    }
    
    func randRange(lower: Int , upper: Int) -> Int {
        return lower + Int(arc4random_uniform(UInt32(upper - lower + 1)))
    }
    
    func chartValueSelected(chartView: ChartViewBase, entry: ChartDataEntry, dataSetIndex: Int, highlight: ChartHighlight) {
        labelCurrent.text = String(format: "%.0f", highlight.value)
        
        if dataSetIndex == 0 {
            labelMonth.text = String(format: "%.0f", set1[getMonth() - 1])
            labelAll.text = String(format: "%.0f", getHighest(set1))
        } else {
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
