//
//  AllRecivedDiaryViewController.swift
//  SpeakToMe
//
//  Created by User on 2018/06/05.
//  Copyright © 2018年 Marina Harada. All rights reserved.
//



import UIKit
import Firebase

class AllRecivedDiaryViewController: UIViewController {
    
    var tableViewArray = [UITableViewCell]()
    var userDefaults:UserDefaults = UserDefaults.standard
    var position = 0
    //StoryBoadで扱うTableViewを宣言
    @IBOutlet var table: UITableView!
    
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
    
    let ref = Database.database().reference()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.table.register(UINib(nibName: "XibTableViewCell", bundle: nil), forCellReuseIdentifier: "XibTableViewCell")
        
        //テーブルビューのデータソースメソッドはViewControllerクラスに書くよ、という設定
        table.dataSource = self
        
        //テーブルビューのデリゲートメソッドはViewControllerメソッドに書くよ、という設定
        table.delegate = self
        
        //
        //
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
                        self.table.reloadData()
                        
                        self.ref.child("permission").child(id).removeObserver(withHandle: self.handler)
                        
                        print(self.keyArray)
                        print(self.uuIdArray)
                        print(self.contentsArray)
    
                    })
                }
            })
            
            
        
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toDiaryViewController" {
            let allDiaryViewController = segue.destination as! AllDiaryViewController
            allDiaryViewController.userName = userNameArray[position]
            allDiaryViewController.date = dateArray[position]
            allDiaryViewController.contents = contentsArray[position]
            allDiaryViewController.url = urlArray[position]
            allDiaryViewController.like = likeArray[position]
            
        }
    }
    
    
   
    
    
}
extension AllRecivedDiaryViewController :UITableViewDataSource, UITableViewDelegate {
    
    //セルの数を設定
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userNameArray.count
    }
    
    //ID付きのセルを取得して、セル付属のtextLabelに『テスト』と表示させてみる
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = self.table.dequeueReusableCell(withIdentifier: "XibTableViewCell") as? XibTableViewCell
        cell?.userNameLabel.text = userNameArray[indexPath.row]
        cell?.dateLabel.text = dateArray[indexPath.row]
        cell?.honbunLabel.text = contentsArray[indexPath.row]
        cell?.urlImage.loadImage(urlString: iconURLArray[indexPath.row])
        cell?.likeLabel.text = String(likeArray[indexPath.row])
        
        cell?.uuId = uuIdArray[indexPath.row]
        cell?.key = keyArray[indexPath.row]
        cell?.userName = userNameArray[indexPath.row]
        cell?.contents = contentsArray[indexPath.row]
        cell?.date = dateArray[indexPath.row]
        cell?.URL = urlArray[indexPath.row]
        cell?.like = likeArray[indexPath.row]
        
        
        return cell!
    }
    //セルが押された時に呼ばれるデリゲートメソッド
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("\(userNameArray[indexPath.row])が選ばれました")
        position = indexPath.row
        self.performSegue(withIdentifier: "toDiaryViewController", sender: nil)
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 100
        
    }
}