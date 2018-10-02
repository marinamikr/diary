//
//  TimeLineViewController.swift
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

class TimeLineViewController: UIViewController {
    
    var swipeableView : ZLSwipeableView! = nil
    let realm = try! Realm()
    var userDefaults:UserDefaults = UserDefaults.standard
    //本文、ユーザー名、日付の配列
    var userNameArray = [String]()
    var dateArray = [String]()
    var contentsArray = [String]()
    var urlArray = [String]()
    var iconURLArray = [String]()
    var likeArray = [Int]()
    var likeImage = [String]()
    var keyArray = [String]()
    var uuIdArray = [String]()
    var handler: UInt = 0
    var ref:DatabaseReference!
    var index = 0
    var isSetUpZLSwipeableView = false
    static var isRenew = false
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if userNameArray.count > index{
            swipeableView.nextView = {
                return self.nextCardView()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if (self.userDefaults.string(forKey: "UserName") == nil) {
            self.performSegue(withIdentifier: "toTopViewController", sender: nil)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        Util.observeMyPost()
        if (self.userDefaults.string(forKey: "UserName") != nil) {
            let elDrawer = self.navigationController?.parent as! KYDrawerController
            (elDrawer.drawerViewController as! DrawerViewController).dalegate = self
            ref = Database.database().reference()
            setUpNavigation()
            if TimeLineViewController.isRenew{
                index = 0
                var delview = self.view.viewWithTag(1)
                delview?.removeFromSuperview()
                setUpSwipeableView()
                getUserContents()
                TimeLineViewController.isRenew = false
            }else{
                getUserContents()
            }
            if !isSetUpZLSwipeableView{
                setUpSwipeableView()
                isSetUpZLSwipeableView = true
            }
        }
        if TimeLineViewController.isRenew{
            var delview = self.view.viewWithTag(1)
            delview?.removeFromSuperview()
            setUpSwipeableView()
            getUserContents()
            TimeLineViewController.isRenew = false
        }
    }
    
    func setUpSwipeableView() {
        swipeableView = ZLSwipeableView()
        swipeableView.tag = 1
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
            let card = self.swipeableView.history.last as! CardView
            if direction == Direction.Left{
                card.addLike()
            }
            if let nextCard = self.swipeableView.topView(){
                if (nextCard as! CardView).userName == nil {
                    print("karate")
                    self.swipeableView.swipeTopView(inDirection: Direction.Right)
                }
            }
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
            view1.top == view2.top + 100
            view1.height == view1.width + 130
        }
    }
    
    func nextCardView() -> UIView? {
        let cardView = CardView(frame: swipeableView.bounds)
        cardView.backgroundColor = UIColor.white
        if userNameArray.count > index{
            cardView.setUserName(userName: userNameArray[index])
            cardView.setContentsText(text: contentsArray[index])
            cardView.setIconImage(url: iconURLArray[index])
            cardView.setPicture(url: urlArray[index])
            cardView.setHeartImage(image: UIImage(named: "hearts.png")!)
            cardView.setDateLabel(dateText: dateArray[index])
            cardView.setHeartLabel(heartText: String(likeArray[index]))
            cardView.setUUID(UUID: uuIdArray[index])
            cardView.setkey(key: keyArray[index])
            cardView.setIndex(index: index)
            cardView.setShadow()
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
            if index == userNameArray.count {
                //                index = 0
            }
        }else{
            cardView.setClear()
        }
        return cardView
    }
    
    func getTopView() -> CardView {
        return swipeableView.topView() as! CardView
    }
    
    func getUserContents(){
        //本文、ユーザー名、日付の配列
        userNameArray = [String]()
        dateArray = [String]()
        contentsArray = [String]()
        urlArray = [String]()
        iconURLArray = [String]()
        likeArray = [Int]()
        likeImage = [String]()
        keyArray = [String]()
        uuIdArray = [String]()
        userDefaults.register(defaults: ["FriendsIDArray" : Array<String>()])
        var idArray = userDefaults.array(forKey: "FriendsIDArray") as! Array<String>
        for id in idArray {
            handler = self.ref.child("permission").child(id).observe(.value, with: {snapshot  in
                let postDict = snapshot.value as! [String : Any]
                var permission : Bool = postDict["read"] as! Bool
                if permission {
                    self.ref.child(id).observe(.value, with: {snapshot  in
                        for i in 0 ..< snapshot.children.allObjects.count {
                            let child = snapshot.children.allObjects[i]
                            let postDict = (child as! DataSnapshot).value as! [String : AnyObject]
                            if Util.differenceOfDate(date1: Date(), date2: (postDict["date"] as! String).getDate()) > 3 {
                                self.ref.child(id).child((child as AnyObject).key).removeValue()
                            }else{
                                self.userNameArray.append(postDict["userName"] as! String)
                                self.dateArray.append(postDict["date"] as! String)
                                self.contentsArray.append(postDict["contents"] as! String)
                                self.urlArray.append(postDict["URL"] as! String)
                                self.likeArray.append(postDict["like"] as! Int)
                                self.keyArray.append((child as! DataSnapshot).key)
                                self.uuIdArray.append(id)
                                self.iconURLArray.append(postDict["iconURL"] as! String)
                            }
                            if id == idArray.last && i == snapshot.children.allObjects.count - 1 {
                                if self.userNameArray.count > self.index{
                                    self.swipeableView.nextView = {
                                        return self.nextCardView()
                                    }
                                }
                            }
                        }
                        self.ref.child(id).removeAllObservers()
                        self.ref.child("permission").child(id).removeObserver(withHandle: self.handler)
                    })
                }
            })
        }
    }
    
    func setUpNavigation() {
        let button = UIBarButtonItem()
        var image = UIImage(named:"add_diary.png")
        var resizeImage = Util.resizeImage(src:image!,max: 40)
        button.image = resizeImage?.withRenderingMode(UIImageRenderingMode.alwaysOriginal)
        button.style = UIBarButtonItemStyle.plain
        button.action = #selector(rightBarBtnClicked(sender:))
        button.target = self
        self.navigationItem.rightBarButtonItem = button
        let result = realm.objects(UserModel.self).last
        var iconImage = UIImage(data: result?.icon  as! Data)
        var resizeIcon = Util.resizeImage(src: iconImage, max: 40).maskCorner(radius: 20)
        let button2 = UIBarButtonItem()
        button2.image = resizeIcon?.withRenderingMode(UIImageRenderingMode.alwaysOriginal)
        button2.style = UIBarButtonItemStyle.plain
        button2.action = #selector(leftBarBtnClicked(sender:))
        button2.target = self
        self.navigationItem.leftBarButtonItem = button2
        self.navigationController?.navigationBar.titleTextAttributes = [NSFontAttributeName: UIFont(name: "Mamelon", size: 20)!]
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

extension TimeLineViewController: CustomDelegate {
    
    func toMyDiary() {
        let elDrawer = self.navigationController?.parent as! KYDrawerController
        elDrawer.setDrawerState(KYDrawerController.DrawerState.closed, animated: true)
        performSegue(withIdentifier: "toAllMyDiaryViewController", sender: nil)
        
    }
    
    func toMyFriendDiary() {
        let elDrawer = self.navigationController?.parent as! KYDrawerController
        elDrawer.setDrawerState(KYDrawerController.DrawerState.closed, animated: true)
        performSegue(withIdentifier: "toAllRecivedDiaryViewController", sender: nil)
    }
    
    func tocamera() {
        let elDrawer = self.navigationController?.parent as! KYDrawerController
        elDrawer.setDrawerState(KYDrawerController.DrawerState.closed, animated: true)
        performSegue(withIdentifier: "toAddFriendViewController", sender: nil)
    }
    
    func toqrcode() {
        let elDrawer = self.navigationController?.parent as! KYDrawerController
        elDrawer.setDrawerState(KYDrawerController.DrawerState.closed, animated: true)
        performSegue(withIdentifier: "toQRViewController", sender: nil)
    }
    
    func tosetting() {
        let elDrawer = self.navigationController?.parent as! KYDrawerController
        elDrawer.setDrawerState(KYDrawerController.DrawerState.closed, animated: true)
        performSegue(withIdentifier: "toSettingViewController", sender: nil)
    }
    
    func toTimeLine(){
        let elDrawer = self.navigationController?.parent as! KYDrawerController
        elDrawer.setDrawerState(KYDrawerController.DrawerState.closed, animated: true)
        performSegue(withIdentifier: "toTimeLineViewController", sender: nil)
    }
}
