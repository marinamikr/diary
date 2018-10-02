//
//  MyDiaryListViewController.swift
//  SpeakToMe
//
//  Created by User on 2018/06/05.
//  Copyright © 2018年 Marina Harada. All rights reserved.
//

import UIKit
import Cartography
import RealmSwift
import AVFoundation
import Firebase
import KYDrawerController

class MyDiaryListViewController: UIViewController {
    
    var swipeableView : ZLSwipeableView! = nil
    let realm = try! Realm()
    var ref:DatabaseReference!
    var userDefaults:UserDefaults = UserDefaults.standard
    //本文、ユーザー名、日付の配列
    var dateArray = [String]()
    var contentsArray = [String]()
    var imageArray = [UIImage]()
    var keyArray = [String]()
    var myID :String!
    var myName :String!
    var iconImage :UIImage!
    var index = 0
    var isFinish = false
    var handler: UInt = 0
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if contentsArray.count > index{
            swipeableView.nextView = {
                return self.nextCardView()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference()
        getUserData()
        getUserContents()
        setUpSwipeableView()
        self.navigationItem.title = "愚痴一覧"
        UINavigationBar.appearance().titleTextAttributes = [NSFontAttributeName: UIFont(name: "Mamelon", size: 20)]
    }
    
    func getUserData()  {
        let realm = try! Realm()
        let result = realm.objects(UserModel.self).first
        var icon = UIImage(data: result?.icon  as! Data)
        iconImage = icon
        myName = result?.nickName
        myID = Util.getUUID()
    }
    
    func setUpSwipeableView() {
        swipeableView = ZLSwipeableView()
        swipeableView.numberOfActiveView = 2
        view.addSubview(swipeableView)
        swipeableView.didStart = {view, location in
            print("Did start swiping view at location: \(location)")
        }
        swipeableView.swiping = {view, location, translation in
            print("Swiping at view location: \(location) translation: \(translation)")
        }
        swipeableView.didEnd = {view, location in
            print("Did end swiping view at location: \(location)")
        }
        swipeableView.didSwipe = {view, direction, vector in
            print("Did swipe view in direction: \(direction), vector: \(vector)")
        }
        swipeableView.didCancel = {view in
            print("Did cancel swiping view")
        }
        swipeableView.didTap = {view, location in
            print("Did tap at location \(location)")
        }
        swipeableView.didDisappear = { view in
            print("Did disappear swiping view")
        }
        constrain(swipeableView, view) { view1, view2 in
            view1.left == view2.left + 30
            view1.right == view2.right - 30
            view1.top == view2.top + 120
            view1.height == view1.width + 130
        }
    }
    
    func nextCardView() -> UIView? {
        let cardView = MyCardView(frame: swipeableView.bounds)
        cardView.backgroundColor = UIColor.white
        if contentsArray.count > index{
            cardView.setUserName(userName: myName)
            cardView.setContentsText(text: contentsArray[index])
            cardView.setIconImage(image: iconImage.maskCorner(radius: iconImage.size.width / 2)!)
            cardView.setDateLabel(dateText: dateArray[index])
            cardView.setIndex(index: index)
            cardView.setPicture(image: imageArray[index])
            cardView.setShadow()
            if keyArray[index] != ""{
                getLikeData(UUID: myID, key: keyArray[index], card: cardView)
            }
            //ランダムにbackgroundのcolorを指定する
            var number = Int(arc4random_uniform(5))
            if number == 0 {
                cardView.setBackGroundColor(hex: "dbffb7")
            } else if number == 1 {
                cardView.setBackGroundColor(hex: "b7dbff")
            } else if number == 2 {
                cardView.setBackGroundColor(hex: "ffb7db")
            } else if number == 3 {
                cardView.setBackGroundColor(hex: "ffdbb7")
            } else if number == 4 {
                cardView.setBackGroundColor(hex: "d6adff")
            } else {
                cardView.setBackGroundColor(hex: "ffb7b7")
            }
            index = index + 1
            if index == contentsArray.count {
                index = 0
            }
        }else{
            cardView.setClear()
        }
        return cardView
    }
    
    func getTopView() -> MyCardView {
        return swipeableView.topView() as! MyCardView
    }
    
    func getUserContents(){
        //本文、ユーザー名、日付の配列
        dateArray = [String]()
        contentsArray = [String]()
        imageArray = [UIImage]()
        let realm = try! Realm()
        let resultArray = realm.objects(RealmModel.self)
        for result in resultArray {
            if Util.differenceOfDate(date1: Date(), date2: (result.hizuke.getDate())) > 3 {
                //書き込みは必ずrealm.write内
                try! realm.write {
                    realm.delete(result)
                }
            }else{
                dateArray.append(result.hizuke)
                contentsArray.append(result.honbunn)
                imageArray.append(UIImage(data:result.image as Data)!)
                keyArray.append(result.key)
            }
        }
    }
    
    func getLikeData(UUID:String,key:String,card:MyCardView) -> Void {
        handler = self.ref.child(UUID).child(key).observe(.value, with: {snapshot  in
            let postDict = snapshot.value as! [String : AnyObject]
            card.setHeartLabel(heartText:String(postDict["like"] as! Int))
            card.setHeartImage(image: UIImage(named: "hearts.png")!)
            self.ref.child(UUID).child(key).removeObserver(withHandle: self.handler)
        })
    }
    
    //右側のボタンが押されたら呼ばれる
    internal func rightBarBtnClicked(sender: UIButton){
        self.performSegue(withIdentifier: "toMakeDiaryViewController", sender: nil)
    }
    
    //左側のボタンが押されたら呼ばれる
    internal func leftBarBtnClicked(sender: UIButton){
        let elDrawer = self.navigationController?.parent as! KYDrawerController
        elDrawer.setDrawerState(KYDrawerController.DrawerState.opened, animated: true)
    }
}

