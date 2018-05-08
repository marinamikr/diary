//
//  Extension.swift
//  SpeakToMe
//
//  Created by User on 2018/05/08.
//  Copyright © 2018年 Henry Mason. All rights reserved.
//

import Foundation

extension Date{
    
    func getyear(date:Date) -> String{
        let f :DateFormatter = DateFormatter()
        f.dateFormat = "yyyy"
        let string = f.string(from: date)
        return string
    }
    
    
    
    
}
