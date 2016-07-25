//
//  SecondChartModel.swift
//  WMCReport
//
//  Created by Luân Trịnh on 7/21/16.
//  Copyright © 2016 Luân Trịnh. All rights reserved.
//

import RealmSwift

class Second: Object {
    dynamic var id = 0
    dynamic var monthNumber = 0
    dynamic var monthString = ""
    dynamic var valueSet1 = 0.0
    dynamic var valueSet2 = 0.0
    
    func primaryKey() -> String? {
        return "id"
    }
    
    func incrementID() -> Int {
        let realm = try! Realm()
        let RetNext: NSArray = Array(realm.objects(Second).sorted("id"))
        let last = RetNext.lastObject
        if RetNext.count > 0 {
            let valor = last?.valueForKey("id") as? Int
            return valor! + 1
        } else {
            return 1
        }
    }
}
