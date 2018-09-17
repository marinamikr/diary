//
//  MakeDiaryViewController.swift
//  SpeakToMe
//
//  Created by User on 2018/06/05.
//  Copyright © 2018年 Marina Harada. All rights reserved.
//

import UIKit
import Speech
import RealmSwift
import FirebaseDatabase
import FirebaseStorage
import Firebase

public class MakeDiaryViewController: UIViewController, SFSpeechRecognizerDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate  {
    
    var dateManager: DateManager = DateManager()
    let userDefaults = UserDefaults.standard
    private let speechRecognizer = SFSpeechRecognizer(locale: Locale(identifier: "ja-JP"))!
    private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    private var recognitionTask: SFSpeechRecognitionTask?
    private let audioEngine = AVAudioEngine()
    @IBOutlet var textView : UITextView!
    @IBOutlet var recordButton : UIButton!
    @IBOutlet weak var saveButton: UIButton!
    // インスタンス変数
    var DBRef:DatabaseReference!
    var myUUID: String!
    var picFlag : Bool = false
    let realm = try! Realm()
    //    var hizukeTest = "2018/08/25"
    @IBOutlet weak var picture: UIImageView!
    
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        textView.font = UIFont(name: "Mamelon", size: (textView.font?.pointSize)!)
        textView.layer.borderWidth = 1
        textView.layer.borderColor = UIColor.gray.cgColor
        let now = Date()
        let yearString = now.getyear(date: now)
        recordButton.isEnabled = false
        //インスタンスを作成
        DBRef = Database.database().reference()
        myUUID = Util.getUUID()
        
        saveButton.titleLabel?.adjustsFontSizeToFitWidth = true
        saveButton.titleLabel?.minimumScaleFactor = 0.3
    }
    // 写真を選んだ後に呼ばれる処理
    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        // 選択した写真を取得する
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        // ビューに表示する
        self.picture.image = image
        picFlag = true
        // 写真を選ぶビューを引っ込める
        self.dismiss(animated: true)
    }
    
    @IBAction func picturetap(_ sender: UIButton) {
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
    
    override public func viewDidAppear(_ animated: Bool) {
        speechRecognizer.delegate = self
        SFSpeechRecognizer.requestAuthorization { authStatus in
            OperationQueue.main.addOperation {
                switch authStatus {
                case .authorized:
                    self.recordButton.isEnabled = true
                case .denied:
                    self.recordButton.isEnabled = false
                    self.recordButton.setTitle("User denied access to speech recognition", for: .disabled)
                case .restricted:
                    self.recordButton.isEnabled = false
                    self.recordButton.setTitle("Speech recognition restricted on this device", for: .disabled)
                case .notDetermined:
                    self.recordButton.isEnabled = false
                    self.recordButton.setTitle("Speech recognition not yet authorized", for: .disabled)
                }
            }
        }
    }
    
    private func startRecording() throws {
        if let recognitionTask = recognitionTask {
            recognitionTask.cancel()
            self.recognitionTask = nil
        }
        let audioSession = AVAudioSession.sharedInstance()
        try audioSession.setCategory(AVAudioSessionCategoryRecord)
        try audioSession.setMode(AVAudioSessionModeMeasurement)
        try audioSession.setActive(true, with: .notifyOthersOnDeactivation)
        recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
        guard let inputNode = audioEngine.inputNode else { fatalError("Audio engine has no input node") }
        guard let recognitionRequest = recognitionRequest else { fatalError("Unable to created a SFSpeechAudioBufferRecognitionRequest object") }
        recognitionRequest.shouldReportPartialResults = true
        recognitionTask = speechRecognizer.recognitionTask(with: recognitionRequest) { result, error in
            var isFinal = false
            if let result = result {
                self.textView.text = result.bestTranscription.formattedString //変換結果
                isFinal = result.isFinal
            }
            if error != nil || isFinal {
                self.audioEngine.stop()
                inputNode.removeTap(onBus: 0)
                self.recognitionRequest = nil
                self.recognitionTask = nil
                self.recordButton.isEnabled = true
                self.recordButton.setTitle("Start", for: [])
            }
        }
        let recordingFormat = inputNode.outputFormat(forBus: 0)
        inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { (buffer: AVAudioPCMBuffer, when: AVAudioTime) in
            self.recognitionRequest?.append(buffer)
        }
        audioEngine.prepare()
        try audioEngine.start()
        textView.text = ""
    }
    
    public func speechRecognizer(_ speechRecognizer: SFSpeechRecognizer, availabilityDidChange available: Bool) {
        if available {
            recordButton.isEnabled = true
            recordButton.setTitle("Start", for: [])
        } else {
            recordButton.isEnabled = false
            recordButton.setTitle("Recognition", for: .disabled)
        }
    }
    
    @IBAction func recordButtonTapped() {
        if audioEngine.isRunning {
            audioEngine.stop()
            recognitionRequest?.endAudio()
            recordButton.isEnabled = false
            recordButton.setTitle("Start", for: .disabled)
        } else {
            try! startRecording()
            recordButton.setTitle("Stop", for: [])
            let alert: UIAlertController = UIAlertController(title:"音声認識を開始します。終了するにはstopを押してください",message:"",preferredStyle: .alert)
            let startAction = UIAlertAction(title: "OK", style: .default) {
                action in
            }
            alert.addAction(startAction)
            present(alert, animated: true, completion: nil)
        }
    }
    
    @IBAction func savebutton (){
        if textView.text != "" {
            let alert: UIAlertController = UIAlertController(title:"保存が完了しました。共有しますか？",message:"",preferredStyle: .alert)
            let shareAction = UIAlertAction(title: "YES", style: .default) {
                action in
                Util.printLog(viewC: self, tag: "共有アラート", contents: "共有する")
                self.sendMyDiary()
                self.navigationController?.popViewController(animated: true)        }
            let closeAction = UIAlertAction(title: "NO", style: .default) {
                action in
                Util.printLog(viewC: self, tag: "共有アラート", contents: "共有しない")
                self.saveMyDiary()
                self.navigationController?.popViewController(animated: true)
            }
            alert.addAction(shareAction)
            alert.addAction(closeAction)
            present(alert, animated: true, completion: nil)
        }else{
            let alert: UIAlertController = UIAlertController(title:"愚痴を入力してください",message:"",preferredStyle: .alert)
            let action = UIAlertAction(title: "YES", style: .default) {
                action in
            }
            alert.addAction(action)
            present(alert, animated: true, completion: nil)
        }
    }
    
    func sendMyDiary() -> Void {
        if picture.image == nil{
            picture.image = Util.clearImage(size: CGSize(width: 200, height: 200))
        }
        // strageの一番トップのReferenceを指定
        let storage = Storage.storage()
        // let storageRef = storage.reference(forURL: "gs://calender-4a2d3.appspot.com")
        let storageRef = storage.reference(forURL: "gs://diary-fbba6.appspot.com")
        //変数picに画像を設定
        if let pic = Util.resizeImage(src:picture.image!,max: 500){
            //変数dataにpicをNSDataにしたものを指定
            if let data = UIImagePNGRepresentation(pic) {
                // トップReferenceの一つ下の固有IDの枝を指定
                let riversRef = storageRef.child(myUUID).child(String.getRandomStringWithLength(length: 60))
                // strageに画像をアップロード
                riversRef.putData(data, metadata: nil, completion: { metaData, error in
                    let downloadURL: String = (metaData?.downloadURL()?.absoluteString)!
                    let name = self.userDefaults.string(forKey: "UserName")
                    let realm = try! Realm()
                    let result = realm.objects(UserModel.self).first
                    let iconURL = result?.iconURL
                    let data = ["userName":name,"contents": self.textView.text!,"date": self.dateManager.format(date: Date()),"URL": downloadURL,"like": 0,"iconURL":iconURL] as [String : Any]
                    //                    let data = ["userName":name,"contents": self.textView.text!,"date": self.hizukeTest,"URL": downloadURL,"like": 0,"iconURL":iconURL] as [String : Any]
                    let ref = Database.database().reference()
                    let sendRef = ref.child(self.myUUID).childByAutoId()
                    sendRef.setValue(data)
                    //保存処理
                    let dateReturn = self.dateManager.format(date: Date())
                    //            let dateReturn = hizukeTest
                    let realmModel : RealmModel = RealmModel()
                    realmModel.hizuke = dateReturn
                    realmModel.honbunn = self.textView.text
                    realmModel.UUID = Util.getUUID()
                    realmModel.key = sendRef.key
                    if self.picture.image != nil{
                        realmModel.image = UIImageJPEGRepresentation(self.picture.image!, 1.0) as! NSData
                    }
                    try! realm.write {
                        realm.add(realmModel)
                    }
                })
            }
        }
    }
    
    func saveMyDiary() -> Void {
        if picture.image == nil{
            picture.image = Util.clearImage(size: CGSize(width: 200, height: 200))
        }
        let dateReturn = dateManager.format(date: Date())
        //            let dateReturn = hizukeTest
        // 通常のSwiftのオブジェクトと同じように扱える
        let realmModel : RealmModel = RealmModel()
        realmModel.hizuke = dateReturn
        realmModel.honbunn = textView.text
        realmModel.UUID = Util.getUUID()
        realmModel.key = ""
        if picture.image != nil{
            realmModel.image = UIImageJPEGRepresentation(self.picture.image!, 1.0) as! NSData
        }
        //書き込みは必ずrealm.write内
        try! realm.write {
            realm.add(realmModel)
        }
    }
    
    @IBAction func toSecondViewController(_ sender: Any){
        self.performSegue(withIdentifier: "toSecondViewController", sender: nil)
    }
}
