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
    
    @IBOutlet weak var barChartView: BarChartView!
    
    @IBOutlet weak var btnMenu: UIButton!
    @IBOutlet weak var pieChartView: PieChartView!
    
    @IBOutlet weak var labelFemale: UILabel!
    @IBOutlet weak var labelMale: UILabel!
    
    //pie
    let months = ["Male", "Female"]
    var unitsSold = [9563.0, 4687.0]
    
    //bar
    var age = ["< 18", "18-25", "25-35", "35-50", "> 50"]
    var total = [23.0, 25.0, 24.0, 22.0, 21.0]
    
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
        labelFemale.text = String(format: "%.0f", unitsSold[1])
        labelMale.text = String(format: "%.0f", unitsSold[0])
        
        setPieChart(months, values: unitsSold)
        setBarChart(age, values: total)
    }
    
    func setPieChart(dataPoints: [String], values: [Double]) {
        
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
        pieChartView.data = pieChartData
        pieChartView.animate(xAxisDuration: 2, yAxisDuration: 2, easingOption: .Linear)
        pieChartView.descriptionText = ""
        pieChartView.holeColor = UIColor(red: 66/255, green: 34/255, blue: 44/255, alpha: 1.0)
        pieChartView.legend.enabled = false
    }
    
    func setBarChart(dataPoints: [String], values: [Double]) {
        barChartView.noDataText = "You need to provide data for the chart."
        
        var dataEntries: [BarChartDataEntry] = []
        
        for i in 0..<dataPoints.count {
            let dataEntry = BarChartDataEntry(value: values[i], xIndex: i)
            dataEntries.append(dataEntry)
        }
        
        let chartDataSet = BarChartDataSet(yVals: dataEntries, label: "Units Sold")
        chartDataSet.setColor(UIColor(red: 180/255, green: 120/255, blue: 122/255, alpha: 1.0).colorWithAlphaComponent(0.3)) // our line's opacity is 50%
        chartDataSet.valueTextColor = UIColor(red: 138/255, green: 138/255, blue: 138/255, alpha: 1.0)
        chartDataSet.highlightColor = UIColor(red: 236/255, green: 121/255, blue: 91/255, alpha: 1.0)
        
        let data = BarChartData(xVals: dataPoints, dataSet: chartDataSet)
        data.setValueTextColor(UIColor(red: 138/255, green: 138/255, blue: 138/255, alpha: 1.0))
        data.setDrawValues(false)
        
        barChartView.data = data
        barChartView.animate(yAxisDuration: 2, easingOption: .EaseOutBack)
        barChartView.descriptionText = ""
        
        //
        barChartView.xAxis.labelPosition = .Bottom
        barChartView.xAxis.labelTextColor = UIColor.whiteColor()
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
            self.setPieChart(self.months, values: self.unitsSold)
            self.setBarChart(self.age, values: self.total)
            
            return
            }, cancelBlock: { ActionStringCancelBlock in return }, origin: sender)
    }
    
    func random() {
        for i in 0...1 {
            unitsSold[i] = Double(randRange(999, upper: 9999))
            labelFemale.text = String(format: "%.0f", unitsSold[1])
            labelMale.text = String(format: "%.0f", unitsSold[0])
        }
        
        for i in 0...4 {
            total[i] = Double(randRange(999, upper: 9999))
        }
    }
    
    func randRange(lower: Int , upper: Int) -> Int {
        return lower + Int(arc4random_uniform(UInt32(upper - lower + 1)))
    }
}
