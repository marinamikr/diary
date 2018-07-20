//
//  CalenderViewController.swift
//  SpeakToMe
//
//  Created by User on 2018/06/05.
//  Copyright © 2018年 Marina Harada. All rights reserved.
//


import UIKit
import KYDrawerController

class CalenderViewController: UIViewController{
    
    var number: Int = 0
    
    
    var datemanager2: DateManager = DateManager()
    var currentDateSetting : CurrentDateSetting = CurrentDateSetting()
    
    var day: Int = 0
    
    
    // MARK: Properties
    var dayCellLists: [String?] = []
    
    //ラベルに表示するための年と月の変数
    var targetYear: Int!
    var targetMonth: Int!
    
    var sideBackView: UIView!

    @IBAction func toMakeDiaryViewController(_ sender: Any) {
        self.performSegue(withIdentifier: "toMakeDiaryViewController", sender: nil)
    }
    
    @IBAction func nowMonth() {
        number = 0
        targetYear = currentDateSetting.getCurrentYearAndMonth(number: number).targetYear
        targetMonth = currentDateSetting.getCurrentYearAndMonth(number: number).targetMonth
        updateDataSource()
        calendarCollectionView.reloadData()
        
        monthlabel.text = String(targetMonth)
        yearlabel.text = String(targetYear)
        
        
    }
    
    //日本の祝祭日判定用のインスタンス
    let holidayObj: CalculateCalendarLogic = CalculateCalendarLogic()
    
    @IBOutlet weak var yearlabel: UILabel!
    
    @IBOutlet weak var monthlabel: UILabel!
    
    @IBAction func before(_ sender: Any){
        number = number - 1
        targetYear = currentDateSetting.getCurrentYearAndMonth(number: number).targetYear
        targetMonth = currentDateSetting.getCurrentYearAndMonth(number: number).targetMonth
        updateDataSource()
        calendarCollectionView.reloadData()
        
        monthlabel.text = String(targetMonth)
        yearlabel.text = String(targetYear)
        
        
    }
    @IBAction func next(_ sender: Any) {
        number = number + 1
        targetYear = currentDateSetting.getCurrentYearAndMonth(number: number).targetYear
        targetMonth = currentDateSetting.getCurrentYearAndMonth(number: number).targetMonth
        updateDataSource()
        calendarCollectionView.reloadData()
        
        monthlabel.text = String(targetMonth)
        yearlabel.text = String(targetYear)
    }
    @IBOutlet weak var calendarCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        targetYear = currentDateSetting.getCurrentYearAndMonth(number: number).targetYear
        
        targetMonth = currentDateSetting.getCurrentYearAndMonth(number: number).targetMonth
        
        monthlabel.text = String(targetMonth)
        
        yearlabel.text = String(targetYear)

        
        let nib:UINib = UINib(nibName: "CollectionViewCell", bundle: nil)
        calendarCollectionView.register(nib, forCellWithReuseIdentifier: "Cell")
        calendarCollectionView.dataSource = self
        calendarCollectionView.delegate = self
        
        updateDataSource()
        // 影を消すには両方必要
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        
        
        let elDrawer = self.navigationController?.parent as! KYDrawerController
        (elDrawer.drawerViewController as! DrawerViewController).dalegate = self
        
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func open(_ sender: Any) {
        let elDrawer = self.navigationController?.parent as! KYDrawerController
        elDrawer.setDrawerState(KYDrawerController.DrawerState.opened, animated: true)
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

extension CalenderViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    
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
        print(calendar.sectionCount.rawValue)
        return calendar.sectionCount.rawValue
    }
    
    
    //配置したCollectionViewの各セクションのアイテム数を返す
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section {
        case indexType.weekdayTitleArea.rawValue:
            print(calendar.firstSectionItemCount.rawValue)
            return calendar.firstSectionItemCount.rawValue
        case indexType.calendarContentsArea.rawValue:
            print(calendar.secondSectionItemCount.rawValue)
            return calendar.secondSectionItemCount.rawValue
        default:
            return calendar.defaultCount.rawValue
        }
        
        
        
    }
    //中身
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! CollectionViewCell
        
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
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        // 例えば端末サイズの半分の width と height にして 2 列にする場合
        let width: CGFloat = UIScreen.main.bounds.width / 7 - 13
        let height: CGFloat = (UIScreen.main.bounds.height - 220) / 6 - 13
        return CGSize(width: width, height: height )
    }
    
    
    // Cell が選択された場合
    func collectionView(_ collectionView: UICollectionView,
                        didSelectItemAt indexPath: IndexPath) {
//        print(dayCellLists[indexPath.row])
        print(dayCellLists)
        print(indexPath.row)
        day = Int(dayCellLists[indexPath.row]!)!
        
        // SubViewController へ遷移するために Segue を呼び出す
        performSegue(withIdentifier: "toShowMyDiaryViewController",sender: nil)
        
        
        
    }
    // Segue 準備
    override func prepare(for segue: UIStoryboardSegue, sender: Any!) {
        if (segue.identifier == "toShowMyDiaryViewController") {
            let subVC: ShowMyDiaryViewController = (segue.destination as? ShowMyDiaryViewController)!
            
            let stringReturn = datemanager2.toDateString(year: targetYear, month: targetMonth, day: day)
            
            subVC.dateString = stringReturn
        }
    }
    
    
}

extension CalenderViewController: CustomDelegate {
    
    func toMyDiary() {
        performSegue(withIdentifier: "toAllMyDiaryViewController", sender: nil)
    }
}


