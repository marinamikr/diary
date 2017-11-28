/*
 Copyright (C) 2016 Apple Inc. All Rights Reserved.
 See LICENSE.txt for this sample’s licensing information
 
 Abstract:
 The primary view controller. The speach-to-text engine is managed an configured here.
 */

import UIKit
import Speech
import RealmSwift

public class ViewController: UIViewController, SFSpeechRecognizerDelegate {
    // MARK: Properties
    var dayCellLists: [String?] = []
    
    //ラベルに表示するための年と月の変数
    var targetYear: Int!  = CurrentDateSetting.getCurrentYearAndMonth().targetYear
    var targetMonth: Int! = CurrentDateSetting.getCurrentYearAndMonth().targetMonth
    
    //日本の祝祭日判定用のインスタンス
    let holidayObj: CalculateCalendarLogic = CalculateCalendarLogic()
    
    
    
    
    
    private let speechRecognizer = SFSpeechRecognizer(locale: Locale(identifier: "ja-JP"))!
    
    private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    
    private var recognitionTask: SFSpeechRecognitionTask?
    
    private let audioEngine = AVAudioEngine()
    
    @IBOutlet var textView : UITextView!
    
    @IBOutlet var recordButton : UIButton!
    
    @IBOutlet weak var calendarCollectionView: UICollectionView!
    
    
    // MARK: UIViewController
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        // Disable the record buttons until authorization has been granted.
        recordButton.isEnabled = false
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
                self.recordButton.setTitle("Start Recording", for: [])
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
            recordButton.setTitle("Start Recording", for: [])
        } else {
            recordButton.isEnabled = false
            recordButton.setTitle("Recognition not available", for: .disabled)
        }
    }
    
    // MARK: Interface Builder actions
    
    @IBAction func recordButtonTapped() {
        if audioEngine.isRunning {
            audioEngine.stop()
            recognitionRequest?.endAudio()
            recordButton.isEnabled = false
            recordButton.setTitle("Stopping", for: .disabled)
        } else {
            try! startRecording()
            recordButton.setTitle("Stop recording", for: [])
        }
    }
    
    
    @IBAction func hozonbutton (){
        
        let f = DateFormatter()
        f.dateStyle = .long
        f.timeStyle = .none
        let now = Date()
        
        // デフォルトのRealmを取得
        let realm = try! Realm()
        
        // 通常のSwiftのオブジェクトと同じように扱える
        let realmModel : RealmModel = RealmModel()
        realmModel.hizuke = f.string(from: now)
        realmModel.honbunn = textView.text
        
        //書き込みは必ずrealm.write内
        try! realm.write {
            realm.add(realmModel)
        }
        
        
        
    }
}

extension ViewController: UICollectionViewDataSource {
    
    
    
    private enum indexType: Int {
        case weekdayTitleArea     = 0
        case calendarContentsArea = 1
    }
    
    private enum calendar: Int {
        case firstSectionItemCount = 7
        case secondSectionItemCount = 42
        case defaultCount = 0
        case sectionCount = 2
     }
    
    private enum collection: String{
        case cellName = "CollectionViewCell"
    }
    
    func updateDataSource() {
        var day = 1
        dayCellLists = []
        for i in 0..<(CalendarSetting.secondSectionItemCount) {
            if isCellUsing(i) {
                dayCellLists.append(String(day))
                day += 1
            } else {
                dayCellLists.append(nil)
            }
        }
    }
    
    //セルに値が格納されるかを判定する
 func isCellUsing(_ index: Int) -> Bool {
        
        //該当の年と月から1日の曜日と最大日数のタプルを取得する
        let targetConcern: (Int, Int) = TargetDateSetting.getTargetYearAndMonthCalendar(targetYear, month: targetMonth)
        let targetWeekdayIndex: Int = targetConcern.0
        let targetMaxDay: Int       = targetConcern.1
        
        //CollectionViewの該当セルインデックスに値が入るかを判定する
        if (index < targetWeekdayIndex - 1) {
            return false
        } else if (index == targetWeekdayIndex - 1 || index < targetWeekdayIndex + targetMaxDay - 1) {
            return true
        } else if (index == targetWeekdayIndex + targetMaxDay - 1 || index < CalendarSetting.secondSectionItemCount) {
            return false
        }
        return false
    }


    
    
    //配置したCollectionViewのセクション数を返す
    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        return calendar.sectionCount.rawValue
    }
    
    
    //配置したCollectionViewの各セクションのアイテム数を返す
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section {
        case indexType.weekdayTitleArea.rawValue:
            return calendar.firstSectionItemCount.rawValue
        case indexType.calendarContentsArea.rawValue:
            return calendar.secondSectionItemCount.rawValue
        default:
            return calendar.defaultCount.rawValue
        }
        
        
        
    }
    //中身
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: collection.cellName.rawValue, for: indexPath) as! CollectionViewCell
        
        switch indexPath.section {
        case indexType.weekdayTitleArea.rawValue:
            //曜日を表示する
            cell.setCell(
                cellText: CalendarSetting.weekList[indexPath.row],
                cellTextColor: CalendarSetting.getCalendarColor(indexPath.row)
            )
            return cell
            
        case indexType.calendarContentsArea.rawValue:
            //該当年月の日付を表示する
            let day: String? = dayCellLists[indexPath.row]
            if isCellUsing(indexPath.row) {
                let isHoliday: Bool = holidayObj.judgeJapaneseHoliday(year: targetYear, month: targetMonth, day: Int(day!)!)
                cell.setCell(
                    cellText: day!,
                    cellTextColor: CalendarSetting.getCalendarColor(indexPath.row, isHoliday: isHoliday)
                )
            } else {
                cell.setCell(
                    cellText: "",
                    cellTextColor: CalendarSetting.getCalendarColor(indexPath.row)
                )
            }
            return cell
        default:
            return cell
        }
        
    }

    
    
    
}
