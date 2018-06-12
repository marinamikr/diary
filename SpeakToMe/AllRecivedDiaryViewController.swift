//
//  AllRecivedDiaryViewController.swift
//  SpeakToMe
//
//  Created by User on 2018/05/29.
//  Copyright © 2018年 Henry Mason. All rights reserved.
//

import UIKit
import Firebase

class AllRecivedDiaryViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var tableViewArray = [UITableViewCell]()
    
    //StoryBoadで扱うTableViewを宣言
    @IBOutlet var table: UITableView!
    
    //本文、ユーザー名、日付の配列
    var userNameArray = [String]()
    var dateArray = [String]()
    var contentsArray = [String]()
    
    let ref = Database.database().reference()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.table.register(UINib(nibName: "XibTableViewCell", bundle: nil), forCellReuseIdentifier: "XibTableViewCell")
        
        //テーブルビューのデータソースメソッドはViewControllerクラスに書くよ、という設定
        table.dataSource = self
        
        //テーブルビューのデリゲートメソッドはViewControllerメソッドに書くよ、という設定
        table.delegate = self
        
        
       
        // Do any additional setup after loading the view.
        
        
        
        self.ref.child(Util.getUUID()).observe(.childAdded, with: {snapshot  in
            
                let postDict = snapshot.value as! [String : AnyObject]
                Util.printLog(viewC: self, tag: "URL", contents: postDict)
                Util.printLog(viewC: self, tag: "URL", contents: postDict["URL"])
            
            self.userNameArray.append(postDict["userName"] as! String)
            self.dateArray.append(postDict["date"] as! String)
            self.contentsArray.append(postDict["contents"] as! String)
            
            self.table.reloadData()
            

            
        })
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
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
        
        
        return cell!
    }
    //セルが押された時に呼ばれるデリゲートメソッド
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("\(userNameArray[indexPath.row])が選ばれました")
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 100
        
    }
    

}
