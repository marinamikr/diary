//
//  DrawerViewController.swift
//  SpeakToMe
//
//  Created by User on 2018/06/05.
//  Copyright © 2018年 Marina Harada. All rights reserved.
//


import UIKit
import RealmSwift

class DrawerViewController: UIViewController {
    
    @IBOutlet weak var table: UITableView!
    @IBOutlet weak var userIcon: UIImageView!
    @IBOutlet weak var userName: UILabel!
    var userDefaults:UserDefaults = UserDefaults.standard
    var array:[String] = ["自分の愚痴一覧","MyQRコード","QRコード読み取り","設定","使い方"]
    var imageArray:[String] = ["MyDiary.png","QRcode.png","Camera.png","Setting.png","Setting.png"]
    var dalegate : CustomDelegate!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.table.register(UINib(nibName: "CustomDrawerTableViewCell", bundle: nil), forCellReuseIdentifier: "customDrawerTableViewCell")
        table.dataSource = self
        table.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if (self.userDefaults.string(forKey: "UserName") != nil) {
            let realm = try! Realm()
            let result = realm.objects(UserModel.self).first
            var iconImage = UIImage(data: result?.icon  as! Data)
            userIcon.image = iconImage
            userName.text = result?.nickName
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

extension DrawerViewController :UITableViewDataSource, UITableViewDelegate {
    
    //セルの数を設定
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return array.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = self.table.dequeueReusableCell(withIdentifier: "customDrawerTableViewCell") as? CustomDrawerTableViewCell
        cell?.label.text = array[indexPath.row]
        cell?.icon.image =  UIImage(named: imageArray[indexPath.row])
        return cell!
    }
    //セルが押された時に呼ばれるデリゲートメソッド
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // indexPath.rowを使う
        switch indexPath.row {
        case 0:
            //performSegue(withIdentifier: "toAllMyDiaryViewController", sender: nil)
            dalegate.toMyDiary()
        case 1:
            //performSegue(withIdentifier: "toQRViewController", sender: nil)
            dalegate.toqrcode()
        case 2:
            //performSegue(withIdentifier: "toAddFriendViewController", sender: nil)
            dalegate.tocamera()
        case 3:
            //performSegue(withIdentifier: "toSettingViewController", sender: nil)
            dalegate.tosetting()
        case 4:
            //performSegue(withIdentifier: "toSettingViewController", sender: nil)
            dalegate.toTutorial()
        default: break
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 50
    }
}


