//
//  CurrentDateSetting.swift
//  SpeakToMe
//
//  Created by User on 2018/06/05.
//  Copyright © 2018年 Marina Harada. All rights reserved.
//

import Foundation
class CurrentDateSetting {
    
    var date : Date = Date()
    
    func getCurrentYearAndMonth(number: Int) -> (targetYear: Int, targetMonth: Int) {
        
        let changeDate  : Date = changeMonth(date: self.date,number: number)
        
        //Calendarクラスのインスタンスを初期化した後に日付の情報を取得して、年と月をタプルで返す
        let currentCalendar: Calendar = Calendar(identifier: Calendar.Identifier.gregorian)
        let comps: DateComponents = currentCalendar.dateComponents([.year, .month], from: changeDate)
        return (Int(comps.year!), Int(comps.month!))
    }
    
    func changeMonth(date : Date,number: Int) -> Date {
        
        let calendar = Calendar.current
        var dateComponents = DateComponents()
        dateComponents.month = number
        return (calendar as NSCalendar).date(byAdding: dateComponents, to: date, options: NSCalendar.Options(rawValue: 0))!
    }
    
}
