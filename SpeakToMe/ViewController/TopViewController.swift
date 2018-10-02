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
    var selectedImage:UIImage!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        userNameText.delegate = self
        self.navigationItem.title = "アカウント作成"
        UINavigationBar.appearance().titleTextAttributes = [NSFontAttributeName: UIFont(name: "Mamelon", size: 20)]
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        UINavigationBar.appearance().setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        UINavigationBar.appearance().shadowImage = UIImage()
        UINavigationBar.appearance().isTranslucent = true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // キーボードを閉じる
        userNameText.resignFirstResponder()
        return true
    }
    
    @IBAction func toMain(_ sender: Any){
        var name : String! = userNameText.text
        if name != "" && selectedImage != nil {
            let width : Int = Int(selectedImage.size.width)
            let height : Int = Int(selectedImage.size.height)
            let smallSize = width < height ? width : height
            let ratio = smallSize / 300
            var icon : UIImage! = selectedImage.resizeImage(maxLong: 600).cropping2square()
            userDefaults.set(name, forKey: "UserName")
            uploadIcon(pic: icon,name: name)
        } else if name == "" && selectedImage == nil {
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
        }else if selectedImage == nil {
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
    
    func uploadIcon(pic: UIImage,name: String){
        // strageの一番トップのReferenceを指定
        let storage = Storage.storage()
        // let storageRef = storage.reference(forURL: "gs://calender-4a2d3.appspot.com")
        let storageRef = storage.reference(forURL: "gs://diary-fbba6.appspot.com")
        //変数dataにpicをNSDataにしたものを指定
        if let data = UIImagePNGRepresentation(pic) {
            // トップReferenceの一つ下の固有IDの枝を指定
            let riversRef = storageRef.child(Util.getUUID()).child(String.getRandomStringWithLength(length: 60))
            // strageに画像をアップロード
            riversRef.putData(data, metadata: nil, completion: { metaData, error in
                let downloadURL: String = (metaData?.downloadURL()?.absoluteString)!
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
                
                TimeLineViewController.isTutorial = true
                //閉じる
                self.dismiss(animated: true, completion: nil)
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
        selectedImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        // ビューに表示する
        self.iconImage.image = selectedImage
        // 写真を選ぶビューを引っ込める
        self.dismiss(animated: true)
    }
}
