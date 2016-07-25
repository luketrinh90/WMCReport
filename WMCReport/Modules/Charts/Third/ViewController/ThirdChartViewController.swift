//
//  ThirdChartViewController.swift
//  WMCReport
//
//  Created by Luân Trịnh on 7/14/16.
//  Copyright © 2016 Luân Trịnh. All rights reserved.
//

import UIKit
import Charts
import RealmSwift
import ActionSheetPicker_3_0

class ThirdChartViewController: UIViewController {
    
    @IBOutlet weak var btnMenu: UIButton!
    @IBOutlet weak var bubbleChartView: BubbleChartView!
    let realm = try! Realm()
    
    var months: [String] = []
    var set1: [Double] = []
    var set2: [Double] = []
    var set3: [Double] = []
    
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
        let fakeSet3 = [30.0, 16.0, 29.0, 7.0, 43.0, 3.0, 9.0, 26.0, 28.0, 67.0, 2.0, 0.0]
        
        if realm.objects(Third).count == 0 {
            for i in 0...11 {
                let obj = Third()
                obj.id = obj.incrementID()
                obj.monthNumber = i + 1
                obj.monthString = fakeMonths[i]
                obj.valueSet1 = fakeSet1[i]
                obj.valueSet2 = fakeSet2[i]
                obj.valueSet3 = fakeSet3[i]
                
                try! realm.write {
                    realm.add(obj)
                }
            }
        }
        
        for i in 0..<realm.objects(Third).count {
            months.append(realm.objects(Third)[i].monthString)
            set1.append(realm.objects(Third)[i].valueSet1)
            set2.append(realm.objects(Third)[i].valueSet2)
            set3.append(realm.objects(Third)[i].valueSet3)
        }
        
        setChart(months, set1: set1, set2: set2, set3: set3)
    }
    
    func setChart(dataPoints: [String], set1: [Double], set2: [Double], set3: [Double]) {
        
        
        var dataEntries1: [BubbleChartDataEntry] = []
        var dataEntries2: [BubbleChartDataEntry] = []
        var dataEntries3: [BubbleChartDataEntry] = []
        
        
        for i in 0..<dataPoints.count {
            
            let dataEntry = BubbleChartDataEntry(xIndex: i, value: set1[i], size: CGFloat(set1[i]))
            dataEntries1.append(dataEntry)
        }
        
        
        for i in 0..<dataPoints.count {
            
            let dataEntry = BubbleChartDataEntry(xIndex: i, value: set2[i], size: CGFloat(set2[i]))
            dataEntries2.append(dataEntry)
        }
        
        
        for i in 0..<dataPoints.count {
            
            let dataEntry = BubbleChartDataEntry(xIndex: i, value: set3[i], size: CGFloat(set3[i]))
            dataEntries3.append(dataEntry)
        }
        
        let chartData1 = BubbleChartDataSet(yVals: dataEntries1,label: "amount" )
        let chartData2 = BubbleChartDataSet(yVals: dataEntries2,label: "revenue")
        let chartData3 = BubbleChartDataSet(yVals: dataEntries3,label: "something")
        
        chartData1.drawValuesEnabled = false
        chartData2.drawValuesEnabled = false
        chartData3.drawValuesEnabled = false
        
        chartData1.colors =  [UIColor(red: 255/255, green: 112/255, blue: 67/255, alpha: 1)]
        chartData2.colors =  [UIColor(red: 76/255, green: 175/255, blue: 80/255, alpha: 1)]
        chartData3.colors =  [UIColor(red: 127/255, green: 0/255, blue: 127/255, alpha: 1)]
        
        let dataSets: [BubbleChartDataSet] = [chartData1,chartData2,chartData3]
        
        let data = BubbleChartData(xVals: dataPoints, dataSets: dataSets)
        
        bubbleChartView.data = data
        
        bubbleChartView.descriptionText = ""
        
        bubbleChartView.animate(yAxisDuration: 2.0, easingOption: .EaseOutBack)
        
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
