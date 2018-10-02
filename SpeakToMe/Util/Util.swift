//
//  Util.swift
//  SpeakToMe
//
//  Created by User on 2018/06/05.
//  Copyright © 2018年 Marina Harada. All rights reserved.
//

import UIKit
import RealmSwift
import UserNotifications
import FirebaseDatabase
import FirebaseStorage
import Firebase

class Util: NSObject {
    
    static func  printLog(viewC : Any ,tag : String, contents:Any){
        print(String(describing: viewC.self) + "【" + tag + "】", terminator: "")
        print(contents)
    }
    static func printErrorLog(viewC : Any ){
        printLog(viewC: viewC.self, tag: "error", contents: "Error")
    }
    
    /// イメージのサイズを変更
    static func resizeImage(src: UIImage!,max:Int) -> UIImage! {
        
        var resizedSize : CGSize!
        let maxLongSide : CGFloat = CGFloat(max)
        
        // リサイズが必要か？
        let ss = src.size
        if maxLongSide == 0 || ( ss.width <= maxLongSide && ss.height <= maxLongSide ) {
            resizedSize = ss
            return src
        }
        
        // TODO: リサイズ回りの処理を切りだし
        
        // リサイズ後のサイズを計算
        let ax = ss.width / maxLongSide
        let ay = ss.height / maxLongSide
        let ar = ax > ay ? ax : ay
        let re = CGRect(x: 0, y: 0, width: ss.width / ar, height: ss.height / ar)
        
        // リサイズ
        UIGraphicsBeginImageContext(re.size)
        src.draw(in: re)
        let dst = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        resizedSize = dst?.size
        
        return dst!
    }
    static func getUUID() -> String {
        return UIDevice.current.identifierForVendor!.uuidString
    }
    
    static func differenceOfDate(date1: Date,date2: Date) -> Double {
        let span = date1.timeIntervalSince(date2) // 1209600秒差
        let daySpan = span/60/60/24 // 14 (日)
        return daySpan
    }
    
    static func clearImage(size: CGSize) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(size, false, UIScreen.main.scale)
        guard let context = UIGraphicsGetCurrentContext() else {
            return nil
        }
        
        // 背景を透明で塗りつぶす
        context.setFillColor(UIColor.clear.cgColor)
        let rect = CGRect(origin: .zero, size: size)
        context.fill(rect)
        
        // 画像に変換する
        let toumeiImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        guard let image = toumeiImage else {
            return nil
        }
        
        return image
    }
    static func showNotification(title:String,subtitle:String,body:String){
        let contents = UNMutableNotificationContent()
        contents.title = title
        contents.subtitle = subtitle
        contents.body = body
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
        let identifier = NSUUID().uuidString
        let request = UNNotificationRequest(identifier: identifier, content: contents, trigger: trigger)
        UNUserNotificationCenter.current().add(request){
            error in
            print(error?.localizedDescription)
        }
    }
    
    
    static func observeMyPost(){
        let realm = try! Realm()
        let resultArray = realm.objects(RealmModel.self)
        var ref:DatabaseReference! = Database.database().reference()
        for result in resultArray {
            ref.child(Util.getUUID()).child(result.key).observe(.childChanged, with: {snapshot in
                let likes = snapshot.value as! Int
                Util.showNotification(title: "いいねされました", subtitle: String(likes) + "likes", body: result.honbunn as!
                    String)
            })
        }
        
    }
    static var isObserving = false
    
    static func printLog(viewC : Any, tag : String, contents:Any){
        print(String(describing: viewC.self) + "[" + tag + "]", terminator: "")
        print(contents)
    }
    static func printErrorLog(ViewC : Any){
        printLog(ViewC: ViewC.self, tag: "error", contents: "Error")
    }
    static func resizeImage(src: UIImage!,max:Int) -> UIImage!{
        var resizeImage : CGSize!
        let maxLongSize : CGFloat = CGFloat(max)
        
        let ss = src.size
        if maxLongSize == 0 || ( ss.width <= maxLongSize && ss.height <= maxLongSize ){
            resizeImage = ss
            return src
        }
    }
    
    
    
    
}
