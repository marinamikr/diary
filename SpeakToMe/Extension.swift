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
    
    func getDate() -> Date{
        let formatter: DateFormatter = DateFormatter()
        formatter.calendar = Calendar(identifier: .gregorian)
        formatter.dateFormat = DateFormatter.dateFormat(fromTemplate: "yyyy/MM/dd", options: 0, locale: Locale(identifier: "ja_JP"))
        return formatter.date(from: self)!
        
    }
    
    static func getRandomStringWithLength(length: Int) -> String {
        
        let alphabet = "1234567890abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"
        let upperBound = UInt32(alphabet.characters.count)
        
        return String((0..<length).map { _ -> Character in
            //            return alphabet[alphabet.startIndex.advancedBy(Int(arc4random_uniform(upperBound)))]
            return alphabet[alphabet.index(alphabet.startIndex, offsetBy: Int(arc4random_uniform(upperBound)))]
        })
    }
}

extension UIImageView{

//画像を非同期で読み込む
func loadImage(urlString: String){
    let CACHE_SEC : TimeInterval = 5 * 60; //5分キャッシュ
    let req = URLRequest(url: NSURL(string:urlString)! as URL,
                         cachePolicy: .returnCacheDataElseLoad,
                         timeoutInterval: CACHE_SEC);
    let conf =  URLSessionConfiguration.default;
    let session = URLSession(configuration: conf, delegate: nil, delegateQueue: OperationQueue.main);
    
    session.dataTask(with: req, completionHandler:
        { (data, resp, err) in
            if((err) == nil){ //Success
                let image = UIImage(data:data!)
                self.image = image;
                
            }else{ //Error
                print("SimpleAsyncImageView:Error \(err?.localizedDescription)");
            }
    }).resume();
}
}










