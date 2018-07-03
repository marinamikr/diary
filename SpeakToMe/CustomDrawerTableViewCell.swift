//
//  CustomDrawerTableViewCell.swift
//  SpeakToMe
//
//  Created by User on 2018/07/03.
//  Copyright © 2018年 Henry Mason. All rights reserved.
//

import UIKit

class CustomDrawerTableViewCell: UITableViewCell {

    
    
    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var label: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
