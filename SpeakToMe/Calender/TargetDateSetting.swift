//
//  TargetDateSetting.swift
//  SpeakToMe
//
//  Created by User on 2018/06/05.
//  Copyright © 2018年 Marina Harada. All rights reserved.
//

import Foundation

class TargetDateSetting {
    static func getTargetYearAndMonthCalendar(_ year: Int, month: Int) -> (Int, Int) {
        
        /*************
         * (重要ポイント)
         * 現在月の1日のdayOfWeek(曜日の値)を使ってカレンダーの始まる位置を決めるので'yyyy年mm月1日'のデータを作成する。
         *************/
        
        //Calendarクラスのインスタンスを初期化した後に日付の情報を取得して、「①指定の年月の1日時点の日付・②日数を年と月」をタプルで返す
        let targetCalendar: Calendar = Calendar(identifier: Calendar.Identifier.gregorian)
        var targetComps: DateComponents = DateComponents()
        
        targetComps.year  = year
        targetComps.month = month
        targetComps.day   = 1
        
        let targetDate: Date = targetCalendar.date(from: targetComps)!
        
        //引数で渡されたCalendarクラスのインスタンスとDateクラスのインスタンスをもとに日付の情報を取得して、指定の年月の1日時点の日付と日数を取得してタプルで返す
        let range: Range = targetCalendar.range(of: .day, in: .month, for: targetDate)!
        let comps: DateComponents = targetCalendar.dateComponents([.year, .month, .day, .weekday], from: targetDate)
        return (Int(comps.weekday!), Int(range.count))
    }
}

