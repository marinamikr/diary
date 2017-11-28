//
//  CollectionViewCell.swift
//  SpeakToMe
//
//  Created by User on 2017/11/28.
//  Copyright © 2017年 Henry Mason. All rights reserved.
//

import UIKit

class CollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var cellLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    //セルの表示を行うメソッド
    func setCell(cellText: String, cellTextColor: UIColor) {
        cellLabel?.text = cellText
        cellLabel?.textColor = cellTextColor
    }

}
