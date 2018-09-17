//
//  ShowMyDiaryViewController.swift
//  SpeakToMe
//
//  Created by User on 2018/06/05.
//  Copyright © 2018年 Marina Harada. All rights reserved.
//


import UIKit
import RealmSwift
import Firebase
import FirebaseDatabase

class ShowMyDiaryViewController: UIViewController {
    
    var dateString: String = ""
    @IBOutlet weak var textview: UITextView!
    @IBOutlet weak var realmimageview: UIImageView!
    @IBAction func toCalendar(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Realmオブジェクトの取得
        let realm = try! Realm()
        //もし、dateの情報が、Cellに表示する日付と一致するものを検索
        if let realmModel :RealmModel = realm.objects(RealmModel.self).filter("hizuke == %@", dateString).last{
            textview.text = realmModel.honbunn
            let realmimage: UIImage? = UIImage(data: realmModel.image as Data)
            realmimageview.image = realmimage
            //テキストを編集できないように設定
            textview.isEditable = false
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
