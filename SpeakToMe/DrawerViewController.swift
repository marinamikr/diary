//
//  DrawerViewController.swift
//  SpeakToMe
//
//  Created by User on 2018/07/03.
//  Copyright © 2018年 Henry Mason. All rights reserved.
//

import UIKit

class DrawerViewController: UIViewController,UITableViewDataSource, UITableViewDelegate {
    
    
    @IBOutlet weak var table: UITableView!
    
    var array:[String] = ["hoge1","hoge2","hoge3"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.table.register(UINib(nibName: "CustomDrawerTableViewCell", bundle: nil), forCellReuseIdentifier: "customDrawerTableViewCell")
        
        //テーブルビューのデータソースメソッドはViewControllerクラスに書くよ、という設定
        table.dataSource = self
        
        //テーブルビューのデリゲートメソッドはViewControllerメソッドに書くよ、という設定
        table.delegate = self
        
       
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    //セルの数を設定
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return array.count
    }
    
    //ID付きのセルを取得して、セル付属のtextLabelに『テスト』と表示させてみる
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = self.table.dequeueReusableCell(withIdentifier: "customDrawerTableViewCell") as? CustomDrawerTableViewCell
        cell?.label.text = array[indexPath.row]
       
        return cell!
    }
    //セルが押された時に呼ばれるデリゲートメソッド
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("\(array[indexPath.row])が選ばれました")
//        indexPath.rowを使う
        //ここ
        
        
        //
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 100
    
    }
    
    
    
}


