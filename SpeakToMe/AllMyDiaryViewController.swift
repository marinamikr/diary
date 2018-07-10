//
//  AllRecivedDiaryViewController.swift
//  SpeakToMe
//
//  Created by User on 2018/05/29.
//  Copyright © 2018年 Henry Mason. All rights reserved.
//

import UIKit
import Firebase
import RealmSwift

class AllMyDiaryViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var tableViewArray = [UITableViewCell]()
    var userDefaults:UserDefaults = UserDefaults.standard
    var position = 0
    //StoryBoadで扱うTableViewを宣言
    @IBOutlet var table: UITableView!
    @IBOutlet weak var myImage: UIImageView!
    
    //本文、ユーザー名、日付の配列
    var dateArray = [String]()
    var contentsArray = [String]()
    var imageArray = [NSData]()
    
    var mImage = UIImage()
    
    let ref = Database.database().reference()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.table.register(UINib(nibName: "MyCustomDiaryTableViewCell", bundle: nil), forCellReuseIdentifier: "myCustomDiaryTableViewCell")
        
        //テーブルビューのデータソースメソッドはViewControllerクラスに書くよ、という設定
        table.dataSource = self
        
        //テーブルビューのデリゲートメソッドはViewControllerメソッドに書くよ、という設定
        table.delegate = self
        
        let realm = try! Realm()

        let resultArray = realm.objects(RealmModel.self)
        
        for result in resultArray {
            dateArray.append(result.hizuke)
            contentsArray.append(result.honbunn)
            imageArray.append(result.image)
        }
        
        table.reloadData()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
        //セルの数を設定
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dateArray.count
    }
    
    //ID付きのセルを取得して、セル付属のtextLabelに『テスト』と表示させてみる
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = self.table.dequeueReusableCell(withIdentifier: "myCustomDiaryTableViewCell") as? MyCustomDiaryTableViewCell
        cell?.myDateLabel.text = dateArray[indexPath.row]
        cell?.myHonbunLabel.text = contentsArray[indexPath.row]
        cell?.myUImageView.image = UIImage(data: imageArray[indexPath.row] as Data)
        return cell!
    }
    //セルが押された時に呼ばれるデリゲートメソッド
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("\(dateArray[indexPath.row])が選ばれました")
        
        position = indexPath.row
        self.performSegue(withIdentifier: "toMyDiaryViewController", sender: nil)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toMyDiaryViewController" {
            let myDiaryViewController = segue.destination as! MyDiaryViewController
            myDiaryViewController.date = dateArray[position]
            myDiaryViewController.contents = contentsArray[position]
            myDiaryViewController.myimages = imageArray[position]
    
        }
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 100
        
    }
    
  
    
}

