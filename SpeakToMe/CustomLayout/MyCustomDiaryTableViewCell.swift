//
//  MyCustomDiaryTableViewCell.swift
//  SpeakToMe
//
//  Created by User on 2018/06/05.
//  Copyright © 2018年 Marina Harada. All rights reserved.
//

import UIKit

class MyCustomDiaryTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var myDateLabel: UILabel!
    @IBOutlet weak var myHonbunLabel: UILabel!
    @IBOutlet weak var myUImageView: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}