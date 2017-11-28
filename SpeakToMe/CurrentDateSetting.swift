//
//  CurrentDateSetting.swift
//  SpeakToMe
//
//  Created by User on 2017/11/28.
//  Copyright © 2017年 Henry Mason. All rights reserved.
//

import Foundation
class CurrentDateSetting {
    
static func getCurrentYearAndMonth() -> (targetYear: Int, targetMonth: Int) {
    
    //Calendarクラスのインスタンスを初期化した後に日付の情報を取得して、年と月をタプルで返す
    let currentCalendar: Calendar = Calendar(identifier: Calendar.Identifier.gregorian)
    let comps: DateComponents = currentCalendar.dateComponents([.year, .month], from: Date())
    return (Int(comps.year!), Int(comps.month!))
}
}
