//
//  TopViewController.swift
//  SpeakToMe
//
//  Created by User on 2018/06/05.
//  Copyright © 2018年 Marina Harada. All rights reserved.
//


import UIKit
import Firebase

class TopViewController: UIViewController {

    @IBOutlet weak var userNameText: UITextField!
    
    let userDefaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        userNameText.delegate = self

        // Do any additional setup after loading the view.
    }

    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if (self.userDefaults.string(forKey: "UserName") != nil) {
            self.performSegue(withIdentifier: "toMainViewController", sender: nil)
        }else{
            let ref = Database.database().reference()
            let data = ["read":true]
            ref.child("permission").child(Util.getUUID()).setValue(data)
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // キーボードを閉じる
        
        userNameText.resignFirstResponder()
        return true
    }
    
    
    @IBAction func toMain(_ sender: Any){
        var name : String = userNameText.text!
        userDefaults.set(name, forKey: "UserName")
        self.performSegue(withIdentifier: "toMainViewController", sender: nil)
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

extension TopViewController :UITextFieldDelegate {
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
}
