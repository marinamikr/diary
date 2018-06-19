//
//  TopViewController.swift
//  SpeakToMe
//
//  Created by User on 2018/06/19.
//  Copyright © 2018年 Henry Mason. All rights reserved.
//

import UIKit

class TopViewController: UIViewController, UITextFieldDelegate {

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
            print("bb")
        }else{
            print("aa")
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
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
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