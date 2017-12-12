//
//  CalendarSetting.swift
//  SpeakToMe
//
//  Created by User on 2017/11/28.
//  Copyright © 2017年 Henry Mason. All rights reserved.
//

import Foundation
import UIKit
class  CalendarSetting {
    
    static let calendarCellName = "CalendarCell"
    
    //カレンダーのセクション数やアイテム数に関するセッティング
    static let sectionCount = 2
    static let firstSectionItemCount  = 7
    static let secondSectionItemCount = 42
    
    fileprivate static let saturdayColor = UIColor(red: CGFloat(0.400), green: CGFloat(0.471), blue: CGFloat(0.980), alpha: CGFloat(1.0))
    fileprivate static let holidayColor  = UIColor(red: CGFloat(0.831), green: CGFloat(0.349), blue: CGFloat(0.224), alpha: CGFloat(1.0))
    fileprivate static let weekdayColor  = UIColor.darkGray
    
    //カレンダーの日付に関するセッティング
    static let weekList: [String] = ["日", "月", "火", "水", "木", "金", "土"]
    
    //カレンダーのカラー表示に関するセッティング（①日曜日または祝祭日の場合の色・②土曜　日の場合の色・③平日の場合の色の決定）
    static func getCalendarColor(_ weekdayIndex: Int, isHoliday: Bool = false) -> UIColor {
        if isSunday(weekdayIndex) || isHoliday {
            return holidayColor
        } else if isSaturday(weekdayIndex) {
            return saturdayColor
        } else {
            return weekdayColor
        }
    }
    
    fileprivate static func isSunday(_ weekdayIndex: Int) -> Bool {
        return (weekdayIndex % 7 == Weekday.sun.rawValue)
    }
    
    fileprivate static func isSaturday(_ weekdayIndex: Int) -> Bool {
        return (weekdayIndex % 7 == Weekday.sat.rawValue)
    }
}

