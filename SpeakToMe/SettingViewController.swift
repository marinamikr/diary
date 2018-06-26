//
//  SettingViewController.swift
//  SpeakToMe
//
//  Created by User on 2018/06/19.
//  Copyright © 2018年 Henry Mason. All rights reserved.
//

import UIKit
import Firebase

class SettingViewController: UIViewController {

    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func showSetting(_ sender: UISwitch) {
        let ref = Database.database().reference()
        
        let data = ["read":sender.isOn]
        ref.child("permission").child(Util.getUUID()).setValue(data)
        
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
