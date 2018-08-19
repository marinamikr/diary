//
//  Extension.swift
//  SpeakToMe
//
//  Created by User on 2018/06/05.
//  Copyright © 2018年 Marina Harada. All rights reserved.
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

extension UIImage {
    func maskCorner(radius r: CGFloat) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(self.size, false, UIScreen.main.scale)
        
        let rect = CGRect(origin:  CGPoint.zero, size: self.size)
        UIBezierPath(roundedRect: rect, cornerRadius: r).addClip()
        draw(in: rect)
        let clippedImage = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
        return clippedImage
    }
    
    func cropImage(w:Int, h:Int)  -> UIImage?{
        // リサイズ処理
        let origRef    = self.cgImage
        let origWidth  = Int(origRef!.width)
        let origHeight = Int(origRef!.height)
        var resizeWidth:Int = 0, resizeHeight:Int = 0
        
        if (origWidth < origHeight) {
            resizeWidth = w
            resizeHeight = origHeight * resizeWidth / origWidth
        } else {
            resizeHeight = h
            resizeWidth = origWidth * resizeHeight / origHeight
        }
        
        
        let resizeImage = self
        // 切り抜き処理
        let cropRect  = CGRect.init(x: CGFloat((resizeWidth - w) / 2), y: CGFloat((resizeHeight - h) / 2), width: CGFloat(w), height: CGFloat(h))
        let cropRef   = resizeImage.cgImage!.cropping(to: cropRect)
        let cropImage = UIImage(cgImage: cropRef!)
        
        return cropImage
    }
    
    func cropping2square()-> UIImage!{
        let cgImage    = self.cgImage
        let width = (cgImage?.width)!
        let height = (cgImage?.height)!
        let resizeSize = min(height,width)
        
        let cropCGImage = self.cgImage?.cropping(to: CGRect(x: (width - resizeSize) / 2, y: (height - resizeSize) / 2, width: resizeSize, height: resizeSize))
        
        let cropImage = UIImage(cgImage: cropCGImage!)
        
        return cropImage
    }
    
    func rotate(angle: CGFloat) -> UIImage{
        UIGraphicsBeginImageContextWithOptions(CGSize(width: self.size.width, height: self.size.height), false, 0.0)
        let context: CGContext = UIGraphicsGetCurrentContext()!
        context.translateBy(x: self.size.width/2, y: self.size.height/2)
        context.scaleBy(x: 1.0, y: -1.0)
        
        let radian: CGFloat = (-angle) * CGFloat.pi / 180.0
        context.rotate(by: radian)
        context.draw(self.cgImage!, in: CGRect(x: -self.size.width/2, y: -self.size.height/2, width: self.size.width, height: self.size.height))
        
        let rotatedImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        return rotatedImage
    }
    
    private func min(_ a : Int, _ b : Int ) -> Int {
        if a < b { return a}
        else { return b}
    }
    
    /// イメージのサイズを変更
    func resizeImage() -> UIImage {
        
        var resizedSize : CGSize!
        let maxLongSide : CGFloat = 300
        
        // リサイズが必要か？
        let ss = self.size
        if maxLongSide == 0 || ( ss.width <= maxLongSide && ss.height <= maxLongSide ) {
            resizedSize = ss
            return self
        }
        
        // TODO: リサイズ回りの処理を切りだし
        
        // リサイズ後のサイズを計算
        let ax = ss.width / maxLongSide
        let ay = ss.height / maxLongSide
        let ar = ax > ay ? ax : ay
        let re = CGRect(x: 0, y: 0, width: ss.width / ar, height: ss.height / ar)
        
        // リサイズ
        UIGraphicsBeginImageContext(re.size)
        self.draw(in: re)
        let dst = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        resizedSize = dst?.size
        
        return dst!
    }
    

}










