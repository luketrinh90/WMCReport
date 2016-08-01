//
//  FirstChartViewController.swift
//  WMCReport
//
//  Created by Luân Trịnh on 7/13/16.
//  Copyright © 2016 Luân Trịnh. All rights reserved.
//

import UIKit
import Charts
import RealmSwift
import ActionSheetPicker_3_0

class FirstChartViewController: UIViewController {
    
    @IBOutlet weak var btnMenu: UIButton!
    @IBOutlet weak var barChartView: BarChartView!
    let realm = try! Realm()
    
    var months: [String] = []
    var unitsSold: [Double] = []
    
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
        let fakeMonths = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"]
        let fakeUnitsSold = [20.0, 4.0, 6.0, 3.0, 12.0, 16.0, 4.0, 18.0, 2.0, 4.0, 5.0, 4.0]
        
        if realm.objects(First).count == 0 {
            for i in 0...11 {
                let obj = First()
                obj.id = obj.incrementID()
                obj.monthNumber = i + 1
                obj.monthString = fakeMonths[i]
                obj.value = fakeUnitsSold[i]
                
                try! realm.write {
                    realm.add(obj)
                }
            }
        }
        
        for i in 0..<realm.objects(First).count {
            months.append(realm.objects(First)[i].monthString)
            unitsSold.append(realm.objects(First)[i].value)
        }
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
        chartDataSet.colors = ChartColorTemplates.pastel()
        chartDataSet.valueTextColor = UIColor(red: 138/255, green: 138/255, blue: 138/255, alpha: 1.0)
        
        let chartData = BarChartData(xVals: dataPoints, dataSet: chartDataSet)
        chartData.setValueTextColor(UIColor(red: 138/255, green: 138/255, blue: 138/255, alpha: 1.0))
        
        barChartView.data = chartData
        barChartView.animate(yAxisDuration: 2, easingOption: .EaseOutBounce)
        barChartView.descriptionText = ""
        
        barChartView.xAxis.labelPosition = .Bottom
        barChartView.xAxis.labelTextColor = UIColor(red: 138/255, green: 138/255, blue: 138/255, alpha: 1.0)
        barChartView.leftAxis.labelTextColor = UIColor(red: 138/255, green: 138/255, blue: 138/255, alpha: 1.0)
        
        barChartView.rightAxis.enabled = false
        
        // grid lines
        barChartView.xAxis.drawAxisLineEnabled = false
        barChartView.xAxis.drawGridLinesEnabled = false
        barChartView.leftAxis.drawAxisLineEnabled = false
        barChartView.leftAxis.drawGridLinesEnabled = false
        barChartView.rightAxis.drawAxisLineEnabled = false
        barChartView.rightAxis.drawGridLinesEnabled = false
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
        for i in 0...11 {
            unitsSold[i] = Double(randRange(0, upper: 100))
        }
    }
    
    func randRange(lower: Int , upper: Int) -> Int {
        return lower + Int(arc4random_uniform(UInt32(upper - lower + 1)))
    }
}
