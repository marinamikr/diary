//
//  Extension.swift
//  SpeakToMe
//
//  Created by User on 2018/05/08.
//  Copyright © 2018年 Henry Mason. All rights reserved.
//

import Foundation
import UIKit

extension Date{
    
    func getyear(date:Date) -> String{
        let f :DateFormatter = DateFormatter()
        f.dateFormat = "yyyy"
        let string = f.string(from: date)
        return string
    }
    func getmonth(date:Date) -> String{
        let f :DateFormatter = DateFormatter()
        f.dateFormat = "MM"
        let string = f.string(from: date)
        return string
    }
    func getday(date:Date) -> String{
        let f :DateFormatter = DateFormatter()
        f.dateFormat = "dd"
        let string = f.string(from: date)
        return string
    }
    
}

extension String {
    
    static func getRandomStringWithLength(length: Int) -> String {
        
        let alphabet = "1234567890abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"
        let upperBound = UInt32(alphabet.characters.count)
        
        return String((0..<length).map { _ -> Character in
            //            return alphabet[alphabet.startIndex.advancedBy(Int(arc4random_uniform(upperBound)))]
            return alphabet[alphabet.index(alphabet.startIndex, offsetBy: Int(arc4random_uniform(upperBound)))]
        })
    }
}









