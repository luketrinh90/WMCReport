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
    
    let months = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"]
    var set1 = [20.0, 4.0, 17.0, 3.0, 12.0, 32.0, 4.0, 18.0, 2.0, 4.0, 5.0, 4.0]
    var set2 = [50.0, 30.0, 10.0, 15.0, 25.0, 20.0, 17.0, 39.0, 32.0, 46.0, 57.0, 1.0]
    var set3 = [30.0, 16.0, 29.0, 7.0, 43.0, 3.0, 9.0, 26.0, 28.0, 67.0, 2.0, 0.0]
    
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
        setChart(months, set1: set1, set2: set2, set3: set3)
    }
    
    func setChart(dataPoints: [String], set1: [Double], set2: [Double], set3: [Double]) {
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
        
        chartData1.colors = [UIColor(red: 255/255, green: 54/255, blue: 75/255, alpha: 1)]
        chartData2.colors = [UIColor(red: 109/255, green: 74/255, blue: 250/255, alpha: 1)]
        
        let dataSets: [BubbleChartDataSet] = [chartData1,chartData2]
        
        let data = BubbleChartData(xVals: dataPoints, dataSets: dataSets)
        data.setDrawValues(false)
        
        bubbleChartView.data = data
        bubbleChartView.descriptionText = ""
        bubbleChartView.animate(yAxisDuration: 2.0, easingOption: .EaseOutBack)
        
        bubbleChartView.xAxis.labelPosition = .Bottom
        bubbleChartView.xAxis.labelTextColor = UIColor(red: 138/255, green: 138/255, blue: 138/255, alpha: 1.0)
        bubbleChartView.leftAxis.labelTextColor = UIColor(red: 138/255, green: 138/255, blue: 138/255, alpha: 1.0)
        
        //
        bubbleChartView.xAxis.enabled = false
        bubbleChartView.legend.textColor = UIColor.whiteColor()
        bubbleChartView.leftAxis.enabled = false
        bubbleChartView.rightAxis.enabled = false
        
        // grid lines
        bubbleChartView.xAxis.drawAxisLineEnabled = false
        bubbleChartView.xAxis.drawGridLinesEnabled = false
        bubbleChartView.leftAxis.drawAxisLineEnabled = false
        bubbleChartView.leftAxis.drawGridLinesEnabled = false
        bubbleChartView.rightAxis.drawAxisLineEnabled = false
        bubbleChartView.rightAxis.drawGridLinesEnabled = false
        
        bubbleChartView.doubleTapToZoomEnabled = false
    }
    
    @IBAction func onOptionPressed(sender: AnyObject) {
        ActionSheetStringPicker.showPickerWithTitle("Options", rows: ["General", "By Month", "By City", "By Gender", "By Age", "By Nationality"], initialSelection: 0, doneBlock: {
            picker, value, index in
            
            print("value = \(value)")
            print("index = \(index)")
            print("picker = \(picker)")
            
            self.random()
            self.setChart(self.months, set1: self.set1, set2: self.set2, set3: self.set3)
            
            return
            }, cancelBlock: { ActionStringCancelBlock in return }, origin: sender)
    }
    
    func random() {
        for i in 0...11 {
            set1[i] = Double(randRange(0, upper: 100))
            set2[i] = Double(randRange(0, upper: 100))
            set3[i] = Double(randRange(0, upper: 100))
        }
    }
    
    func randRange(lower: Int , upper: Int) -> Int {
        return lower + Int(arc4random_uniform(UInt32(upper - lower + 1)))
    }
}
