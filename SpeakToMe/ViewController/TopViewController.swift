//
//  TopViewController.swift
//  SpeakToMe
//
//  Created by User on 2018/06/05.
//  Copyright © 2018年 Marina Harada. All rights reserved.
//


import UIKit
import Firebase
import RealmSwift
import FirebaseDatabase
import FirebaseStorage


class TopViewController: UIViewController {
    
    @IBOutlet weak var userNameText: UITextField!
    
    @IBOutlet weak var iconImage: UIImageView!
    
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
        var name : String! = userNameText.text
        var icon : UIImage! = iconImage.image?.cropImage(w: 300, h: 300)
        
        
        if name != "" && icon != nil {
            
            userDefaults.set(name, forKey: "UserName")
            uploadIcon(pic: icon,name: name)
            
            
            
            
        } else if name == "" && icon == nil {
            let alert: UIAlertController = UIAlertController(title:"ニックネームとアイコンを入力してください",message:"",preferredStyle: .alert)
            let closeAction = UIAlertAction(title: "close", style: .default) {
                action in
            }
            alert.addAction(closeAction)
            present(alert, animated: true, completion: nil)
        } else if name == ""{
            
            let alert: UIAlertController = UIAlertController(title:"ニックネームを入力してください",message:"",preferredStyle: .alert)
            let closeAction = UIAlertAction(title: "close", style: .default) {
                action in
            }
            alert.addAction(closeAction)
            present(alert, animated: true, completion: nil)
            
            
        }else if icon == nil {
            let alert: UIAlertController = UIAlertController(title:"アイコンを選択してください",message:"",preferredStyle: .alert)
            let closeAction = UIAlertAction(title: "close", style: .default) {
                action in
            }
            alert.addAction(closeAction)
            present(alert, animated: true, completion: nil)
        }
    }
    
    @IBAction func chooseIcon(_ sender: Any) {
        // カメラロールが利用可能か？
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            // 写真を選ぶビュー
            let pickerView = UIImagePickerController()
            // 写真の選択元をカメラロールにする
            // 「.camera」にすればカメラを起動できる
            pickerView.sourceType = .photoLibrary
            // デリゲート
            pickerView.delegate = self
            // ビューに表示
            self.present(pickerView, animated: true)
        }
        
    }
    
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
    func uploadIcon(pic: UIImage,name: String){
        // strageの一番トップのReferenceを指定
        let storage = Storage.storage()
        // let storageRef = storage.reference(forURL: "gs://calender-4a2d3.appspot.com")
        let storageRef = storage.reference(forURL: "gs://diary-fbba6.appspot.com")
        
        //変数dataにpicをNSDataにしたものを指定
        if let data = UIImagePNGRepresentation(pic) {
            
            //ロード中のダイアログを表示する
            //SVProgressHUD.show()
            
            // トップReferenceの一つ下の固有IDの枝を指定
            let riversRef = storageRef.child(Util.getUUID()).child(String.getRandomStringWithLength(length: 60))
            
            // strageに画像をアップロード
            riversRef.putData(data, metadata: nil, completion: { metaData, error in
                let downloadURL: String = (metaData?.downloadURL()?.absoluteString)!
                Util.printLog(viewC: self, tag: "download", contents: downloadURL)
                
                let data = ["iconURL": downloadURL,"read": true] as [String : Any]
                
                let ref = Database.database().reference()
                ref.child("permission").child(Util.getUUID()).setValue(data)
                
                
                
                let userModel : UserModel = UserModel()
                userModel.nickName = name
                userModel.iconURL = downloadURL
                
                if pic != nil{
                    userModel.icon = UIImageJPEGRepresentation(pic, 1.0) as! NSData
                }
                // デフォルトのRealmを取得
                let realm = try! Realm()
                
                
                
                
                //書き込みは必ずrealm.write内
                try! realm.write {
                    
                    realm.add(userModel)
                }
                
                self.performSegue(withIdentifier: "toMainViewController", sender: nil)
                
                
                
            })
            
        }
        
        
    }
}

extension TopViewController :UITextFieldDelegate {
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
}

extension TopViewController :UIImagePickerControllerDelegate ,UINavigationControllerDelegate {
    // 写真を選んだ後に呼ばれる処理
    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        // 選択した写真を取得する
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        // ビューに表示する
        self.iconImage.image = image
        // 写真を選ぶビューを引っ込める
        self.dismiss(animated: true)
    }
    
}
