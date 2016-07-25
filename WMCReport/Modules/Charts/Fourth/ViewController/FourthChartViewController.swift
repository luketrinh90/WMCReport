//
//  FourthChartViewController.swift
//  WMCReport
//
//  Created by Luân Trịnh on 7/14/16.
//  Copyright © 2016 Luân Trịnh. All rights reserved.
//

import UIKit
import Charts
import RealmSwift
import ActionSheetPicker_3_0

class FourthChartViewController: UIViewController {
    
    @IBOutlet weak var btnMenu: UIButton!
    @IBOutlet weak var lineChartView: LineChartView!
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
        let fakeSet2 = [50.0, 30.0, 10.0, 15.0, 25.0, 20.0, 17.0, 39.0, 32.0, 46.0, 57.0, 1.0]
        
        if realm.objects(Fourth).count == 0 {
            for i in 0...11 {
                let obj = Fourth()
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
        
        for i in 0..<realm.objects(Fourth).count {
            months.append(realm.objects(Fourth)[i].monthString)
            set1.append(realm.objects(Fourth)[i].valueSet1)
            set2.append(realm.objects(Fourth)[i].valueSet2)
        }
        
        setChart(months, set1: set1, set2: set2)
    }
    
    func setChart(months : [String], set1: [Double], set2: [Double]) {
        // 1 - creating an array of data entries
        var yVals1 : [ChartDataEntry] = [ChartDataEntry]()
        for i in 0 ..< months.count {
            yVals1.append(ChartDataEntry(value: set1[i], xIndex: i))
        }
        
        // 2 - create a data set with our array
        let set1: LineChartDataSet = LineChartDataSet(yVals: yVals1, label: "First Set")
        set1.axisDependency = .Left // Line will correlate with left axis values
        set1.setColor(UIColor.redColor().colorWithAlphaComponent(0.5)) // our line's opacity is 50%
        set1.setCircleColor(UIColor.redColor()) // our circle will be dark red
        set1.lineWidth = 2.0
        set1.circleRadius = 6.0 // the radius of the node circle
        set1.fillAlpha = 65 / 255.0
        set1.fillColor = UIColor.redColor()
        set1.highlightColor = UIColor.whiteColor()
        set1.drawCircleHoleEnabled = true
        set1.mode = .CubicBezier
        set1.drawFilledEnabled = true
        
        //////////////////////////////////////////////////////////////////////////////////
        
        var yVals2 : [ChartDataEntry] = [ChartDataEntry]()
        for i in 0 ..< months.count {
            yVals2.append(ChartDataEntry(value: set2[i], xIndex: i))
        }
        
        let set2: LineChartDataSet = LineChartDataSet(yVals: yVals2, label: "Second Set")
        set2.axisDependency = .Left // Line will correlate with left axis values
        set2.setColor(UIColor.blueColor().colorWithAlphaComponent(0.5))
        set2.setCircleColor(UIColor.blueColor())
        set2.lineWidth = 2.0
        set2.circleRadius = 6.0
        set2.fillAlpha = 65 / 255.0
        set2.fillColor = UIColor.blueColor()
        set2.highlightColor = UIColor.whiteColor()
        set2.drawCircleHoleEnabled = true
        set2.mode = .CubicBezier
        set2.drawFilledEnabled = true
        
        //3 - create an array to store our LineChartDataSets
        var dataSets : [LineChartDataSet] = [LineChartDataSet]()
        dataSets.append(set1)
        dataSets.append(set2)
        
        //4 - pass our months in for our x-axis label value along with our dataSets
        let data: LineChartData = LineChartData(xVals: months, dataSets: dataSets)
        data.setValueTextColor(UIColor.orangeColor())
        
        //5 - finally set our data
        lineChartView.data = data
        lineChartView.animate(xAxisDuration: 2, yAxisDuration: 2, easingOption: .Linear)
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
            set1[i] = Double(randRange(0, upper: 100))
            set2[i] = Double(randRange(0, upper: 100))
        }
    }
    
    func randRange(lower: Int , upper: Int) -> Int {
        return lower + Int(arc4random_uniform(UInt32(upper - lower + 1)))
    }
}
