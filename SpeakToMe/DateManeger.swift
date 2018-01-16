//
//  DateManeger.swift
//  SpeakToMe
//
//  Created by User on 2018/01/16.
//  Copyright © 2018年 Henry Mason. All rights reserved.
//

import Foundation
import UIKit
class DateManeger{
    func toDateString(year: Int, month: Int, day: Int) -> String{
        if month <= 9 {
            if day <= 9{
                return String(year) + "/0" + String(month) + "/0" + String(day)
            }else{
                return String(year) + "/0" + String(month) + "/" + String(day)
            }
        }else{
            if day <= 9{
                return String(year) + "/" + String(month) + "/0" + String(day)
            }else{
                return String(year) + "/" + String(month) + "/" + String(day)
            }
        }
    }
}
