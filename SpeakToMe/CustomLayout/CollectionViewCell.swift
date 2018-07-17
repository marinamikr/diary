//
//  CollectionViewCell.swift
//  SpeakToMe
//
//  Created by User on 2018/06/05.
//  Copyright © 2018年 Marina Harada. All rights reserved.
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
