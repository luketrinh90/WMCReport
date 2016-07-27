//
//  SixthChartViewController.swift
//  WMCReport
//
//  Created by Luân Trịnh on 7/20/16.
//  Copyright © 2016 Luân Trịnh. All rights reserved.
//

import UIKit
import Charts
import RealmSwift
import ActionSheetPicker_3_0

class SixthChartViewController: UIViewController {
    
    @IBOutlet weak var btnMenu: UIButton!
    @IBOutlet weak var pieChartView: PieChartView!
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
        let fakeUnitsSold = [20.0, 4.0, 17.0, 3.0, 12.0, 32.0, 4.0, 18.0, 2.0, 4.0, 5.0, 4.0]
        
        if realm.objects(Sixth).count == 0 {
            for i in 0...11 {
                let obj = Sixth()
                obj.id = obj.incrementID()
                obj.monthNumber = i + 1
                obj.monthString = fakeMonths[i]
                obj.value = fakeUnitsSold[i]
                
                try! realm.write {
                    realm.add(obj)
                }
            }
        }
        
        for i in 0..<realm.objects(Sixth).count {
            months.append(realm.objects(Sixth)[i].monthString)
            unitsSold.append(realm.objects(Sixth)[i].value)
        }
        
        setChart(months, values: unitsSold)
    }
    
    func setChart(dataPoints: [String], values: [Double]) {
        
        var dataEntries: [ChartDataEntry] = []
        
        for i in 0..<dataPoints.count {
            let dataEntry = ChartDataEntry(value: values[i], xIndex: i)
            dataEntries.append(dataEntry)
        }
        
        let pieChartDataSet = PieChartDataSet(yVals: dataEntries, label: "Units Sold")
        let pieChartData = PieChartData(xVals: dataPoints, dataSet: pieChartDataSet)
        pieChartView.data = pieChartData
        pieChartView.animate(xAxisDuration: 2, yAxisDuration: 2, easingOption: .Linear)
        
        var colors: [UIColor] = []
        
        for i in 0..<dataPoints.count {
            let red = Double(arc4random_uniform(256))
            let green = Double(arc4random_uniform(256))
            let blue = Double(arc4random_uniform(256))
            
            let color = UIColor(red: CGFloat(red/255), green: CGFloat(green/255), blue: CGFloat(blue/255), alpha: 1)
            colors.append(color)
        }
        
        pieChartDataSet.colors = colors
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
