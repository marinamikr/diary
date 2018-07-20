//
//  AllMyDiaryViewController.swift
//  SpeakToMe
//
//  Created by User on 2018/06/05.
//  Copyright © 2018年 Marina Harada. All rights reserved.
//


import UIKit
import Firebase
import RealmSwift

class SettingViewController: UIViewController{
    
    @IBOutlet weak var table: UITableView!
    
    let userDefaults = UserDefaults.standard
    
    var array: [String] = ["公開設定"]
    
    var permission : Bool! = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.table.register(UINib(nibName: "SettingTableViewCell", bundle: nil), forCellReuseIdentifier: "settingTableViewCell")
        //テーブルビューのデータソースメソッドはViewControllerクラスに書くよ、という設定
        table.dataSource = self
        //テーブルビューのデリゲートメソッドはViewControllerメソッドに書くよ、という設定
        table.delegate = self
        
        userDefaults.register(defaults: ["permission" : true])
        
        permission = userDefaults.bool(forKey: "permission")
        print(permission)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

extension SettingViewController :UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 60
        
    }
    
    //セルの数を設定
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return array.count
    }
    
    //ID付きのセルを取得して、セル付属のtextLabelに『テスト』と表示させてみる
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = self.table.dequeueReusableCell(withIdentifier: "settingTableViewCell") as? SettingTableViewCell
        cell?.settingLabel.text = array[indexPath.row]
        
        if cell?.accessoryView == nil{
            let switchView = UISwitch(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
            switchView.isOn = permission
            switchView.tag = indexPath.row
            switchView.addTarget(self, action: #selector(switchTriggered), for: .valueChanged)
            cell?.accessoryView = switchView
        }
        
        return cell!
    }
    
    @IBAction func switchTriggered(_ sender: UISwitch) {
        let ref = Database.database().reference()
        let data = ["read":sender.isOn]
        ref.child("permission").child(Util.getUUID()).updateChildValues(data)
        userDefaults.set(sender.isOn, forKey: "permission")
        print(userDefaults.string(forKey: "permission"))
    }
    
    //    //セルが押された時に呼ばれるデリゲートメソッド
    //    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    //        print("\(array[indexPath.row])が選ばれました")
    //
    //    }
    
}

