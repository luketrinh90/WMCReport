//
//  FifthChartViewController.swift
//  WMCReport
//
//  Created by Luân Trịnh on 7/15/16.
//  Copyright © 2016 Luân Trịnh. All rights reserved.
//

import UIKit
import Charts
import RealmSwift
import ActionSheetPicker_3_0

class FifthChartViewController: UIViewController {
    
    @IBOutlet weak var btnMenu: UIButton!
    @IBOutlet weak var combinedChartView: CombinedChartView!
    let realm = try! Realm()
    
    var months: [String] = []
    var set1: [Double] = []
    var set2: [Double] = []
    
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
        let fakeSet1 = [20.0, 4.0, 17.0, 3.0, 12.0, 32.0, 4.0, 18.0, 2.0, 4.0, 5.0, 4.0]
        let fakeSet2 = [50.0, 30.0, 10.0, 15.0, 25.0, 20.0, 17.0, 39.0, 32.0, 46.0, 57.0, 24.0]
        
        if realm.objects(Fifth).count == 0 {
            for i in 0...11 {
                let obj = Fifth()
                obj.id = obj.incrementID()
                obj.monthNumber = i + 1
                obj.monthString = fakeMonths[i]
                obj.valueSet1 = fakeSet1[i]
                obj.valueSet2 = fakeSet2[i]
                
                try! realm.write {
                    realm.add(obj)
                }
            }
        }
        
        for i in 0..<realm.objects(Fifth).count {
            months.append(realm.objects(Fifth)[i].monthString)
            set1.append(realm.objects(Fifth)[i].valueSet1)
            set2.append(realm.objects(Fifth)[i].valueSet2)
        }
        
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
