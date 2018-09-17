//
//  ViewController.swift
//  DatabaseApp
//
//  Created by 橋詰明宗 on 2017/09/07.
//  Copyright © 2017年 橋詰明宗. All rights reserved.
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
        ref = Database.database().reference()
        getUserContents()
        
        let elDrawer = self.navigationController?.parent as! KYDrawerController
        (elDrawer.drawerViewController as! DrawerViewController).dalegate = self
        setUpNavigation()
        
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        
    }
    
    func setUpSwipeableView() {
        
        swipeableView = ZLSwipeableView()
        print("追加")
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
        //
        swipeableView.didRewinded = {view in
            
        }
        
        
        constrain(swipeableView, view) { view1, view2 in
            view1.left == view2.left+10
            view1.right == view2.right - 10
            view1.top == view2.top + 180
            view1.height == view1.width + 90
        }
    }
    
    // MARK: ()
    func nextCardView() -> UIView? {
        let cardView = CardView(frame: swipeableView.bounds)
        cardView.backgroundColor = UIColor.white
        
        
        if userNameArray.count > index{
            print(urlArray[index])
            cardView.setUserName(userName: userNameArray[index])
            cardView.setContentsText(text: contentsArray[index])
            cardView.setIconImage(url: iconURLArray[index])
            cardView.setPicture(url: urlArray[index])
            cardView.setHeartImage(image: UIImage(named: "hearts.png")!)
            cardView.setDateLabel(dateText: dateArray[index])
            cardView.setHeartLabel(heartText: String(likeArray[index]))
            cardView.setBackGroundColor(hex: "FF0000")
            
           
           


            index = index + 1
            if index == userNameArray.count {
                index = 0
            }
        }
        return cardView
        
    }
    
    
    
    func getTopView() -> CardView {
        return swipeableView.topView() as! CardView
    }
    
    
    @IBAction func back(_ sender: UIButton) {
        
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func redo(_ sender: UIButton) {
        swipeableView.rewind()
    }
    
    func getUserContents(){
        userDefaults.register(defaults: ["FriendsIDArray" : Array<String>()])
        var idArray = userDefaults.array(forKey: "FriendsIDArray") as! Array<String>
        
        for id in idArray {
            print(id)
            handler = self.ref.child("permission").child(id).observe(.value, with: {snapshot  in
                print(snapshot)
                let postDict = snapshot.value as! [String : Any]
                print(postDict)
                var permission : Bool = postDict["read"] as! Bool
                if permission {
                    self.ref.child(id).observe(.value, with: {snapshot  in
                        
                        for child in snapshot.children {
                            
                            let postDict = (child as! DataSnapshot).value as! [String : AnyObject]
                            Util.printLog(viewC: self, tag: "URL", contents: postDict)
                            Util.printLog(viewC: self, tag: "URL", contents: postDict["URL"])
                            
                            if Util.differenceOfDate(date1: Date(), date2: (postDict["date"] as! String).getDate()) > 3 {
                                self.ref.child(id).child((child as AnyObject).key).removeValue()
                                
                            }else{
                                print((postDict["date"] as! String).getDate())
                                self.userNameArray.append(postDict["userName"] as! String)
                                self.dateArray.append(postDict["date"] as! String)
                                self.contentsArray.append(postDict["contents"] as! String)
                                self.urlArray.append(postDict["URL"] as! String)
                                self.likeArray.append(postDict["like"] as! Int)
                                self.keyArray.append((child as! DataSnapshot).key)
                                self.uuIdArray.append(id)
                                self.iconURLArray.append(postDict["iconURL"] as! String)
                                
                            }
                            
                        }
                        self.ref.child(id).removeAllObservers()
                        
                        
                        self.ref.child("permission").child(id).removeObserver(withHandle: self.handler)
                       
                        
                        print(self.keyArray)
                        print(self.uuIdArray)
                        print(self.contentsArray)
                       
                        
                    })
                    
                    
                }
            })
            
            
            
            
        }
        
    }
    
    @IBAction func test(_ sender: Any) {
        setUpSwipeableView()
    }
    
    func setUpNavigation() {
        let button = UIBarButtonItem()
        var image = UIImage(named:"calender_add_blue1.png")
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
        
        
    }
    
    //右側のボタンが押されたら呼ばれる
    internal func rightBarBtnClicked(sender: UIButton){
        print("rightBarBtnClicked")
        self.performSegue(withIdentifier: "toMakeDiaryViewController", sender: nil)
    }
    
    //左側のボタンが押されたら呼ばれる
    internal func leftBarBtnClicked(sender: UIButton){
        print("leftBarBtnClicked")
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
