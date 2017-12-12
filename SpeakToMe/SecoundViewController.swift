//
//  SecoundViewController.swift
//  SpeakToMe
//
//  Created by User on 2017/12/12.
//  Copyright © 2017年 Henry Mason. All rights reserved.
//

import UIKit

class SecoundViewController: UIViewController {
  
    // MARK: Properties
    var dayCellLists: [String?] = []
    
    //ラベルに表示するための年と月の変数
    var targetYear: Int!  = CurrentDateSetting.getCurrentYearAndMonth().targetYear
    var targetMonth: Int! = CurrentDateSetting.getCurrentYearAndMonth().targetMonth
    
    //日本の祝祭日判定用のインスタンス
    let holidayObj: CalculateCalendarLogic = CalculateCalendarLogic()
    
    
    @IBOutlet weak var calendarCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let nib:UINib = UINib(nibName: "CollectionViewCell", bundle: nil)
        calendarCollectionView.register(nib, forCellWithReuseIdentifier: "Cell")
        calendarCollectionView.dataSource = self
        
        updateDataSource()
        
        
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



extension SecoundViewController: UICollectionViewDataSource {
    
    
    
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
    
    
    
    
}
