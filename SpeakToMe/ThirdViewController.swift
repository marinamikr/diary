//
//  ThirdViewController.swift
//  SpeakToMe
//
//  Created by User on 2018/01/09.
//  Copyright © 2018年 Henry Mason. All rights reserved.
//

import UIKit
import RealmSwift

class ThirdViewController: UIViewController {
    
    var year: Int = 0
    var month: Int  = 0
    var day: Int = 0
  

    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(year)
        print(month)
        print(day)
        
        //Realmオブジェクトの取得
        let realm = try! Realm()
       //もし、dateの情報が、Cellに表示する日付と一致するものを検索
        if let realmModel = realm.objects(RealmModel.self).filter("hizuke == %@", String(year)+"/"+String(month)+"/"+String(day)).last{
            
        }
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
   
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
