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
            view1.top == view2.top + 90
            view1.height == view1.width
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
            index = index + 1
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
    
    
}
