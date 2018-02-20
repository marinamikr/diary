/*
 Copyright (C) 2016 Apple Inc. All Rights Reserved.
 See LICENSE.txt for this sample’s licensing information
 
 Abstract:
 The primary view controller. The speach-to-text engine is managed an configured here.
 */

import UIKit
import Speech
import RealmSwift

public class ViewController: UIViewController, SFSpeechRecognizerDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate  {
    
    var dateManager: DateManager = DateManager()
    
    
    private let speechRecognizer = SFSpeechRecognizer(locale: Locale(identifier: "ja-JP"))!
    
    private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    
    private var recognitionTask: SFSpeechRecognitionTask?
    
    private let audioEngine = AVAudioEngine()
    
    @IBOutlet var textView : UITextView!
    
    @IBOutlet var recordButton : UIButton!
    
    @IBAction func keyboard() {
      self.textView.becomeFirstResponder()
    }
    
    @IBAction func buttonHide() {
        self.textView.resignFirstResponder()
    }
    
    @IBOutlet weak var picture: UIImageView!
    
    
    // カメラロールから写真を選択する処理
    @IBAction func choosePicture() {
        
    }
   
    
    
    // MARK: UIViewController
    
    public override func viewDidLoad() {
        super.viewDidLoad()
     
       
       
     picture.isUserInteractionEnabled = true
        picture.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(ViewController.picturetap(_:))))
        
        // Disable the record buttons until authorization has been granted.
        recordButton.isEnabled = false
    }
    
    // 写真を選んだ後に呼ばれる処理
    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        // 選択した写真を取得する
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        // ビューに表示する
        self.picture.image = image
        // 写真を選ぶビューを引っ込める
        self.dismiss(animated: true)
    }
    
    func picturetap(_ sender: UITapGestureRecognizer) {
        print("タップ")
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
            /*
             The callback may not be called on the main thread. Add an
             operation to the main queue to update the record button's state.
             */
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
        
        // Cancel the previous task if it's running.
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
        
        // Configure request so that results are returned before audio recording is finished
        recognitionRequest.shouldReportPartialResults = true
        
        // A recognition task represents a speech recognition session.
        // We keep a reference to the task so that it can be cancelled.
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
    
    // MARK: SFSpeechRecognizerDelegate
    
    public func speechRecognizer(_ speechRecognizer: SFSpeechRecognizer, availabilityDidChange available: Bool) {
        if available {
            recordButton.isEnabled = true
            recordButton.setTitle("Start", for: [])
        } else {
            recordButton.isEnabled = false
            recordButton.setTitle("Recognition", for: .disabled)
        }
    }
    
    // MARK: Interface Builder actions
    
    @IBAction func recordButtonTapped() {
        if audioEngine.isRunning {
            audioEngine.stop()
            recognitionRequest?.endAudio()
            recordButton.isEnabled = false
            recordButton.setTitle("Stop", for: .disabled)
        } else {
            try! startRecording()
            recordButton.setTitle("Stop", for: [])
        }
    }
    
    
    @IBAction func hozonbutton (){
     
        // デフォルトのRealmを取得
        let realm = try! Realm()
        
        let dateReturn = dateManager.format(date: Date())
       
        
        // 通常のSwiftのオブジェクトと同じように扱える
        let realmModel : RealmModel = RealmModel()
        realmModel.hizuke = dateReturn
        realmModel.honbunn = textView.text
        realmModel.image = UIImageJPEGRepresentation(self.picture.image!, 1.0) as! NSObject
        
        
        
        
        //書き込みは必ずrealm.write内
        try! realm.write {
            realm.add(realmModel)
        }
        
        print(dateReturn)
        let Alert: UIAlertController = UIAlertController(title:"保存が完了しました",message:"",preferredStyle: .alert)
        let CloseAction = UIAlertAction(title: "OK", style: .default) {
            action in
            print("OK")
        }
        Alert.addAction(CloseAction)
        present(Alert, animated: true, completion: nil)
        
    }
}

