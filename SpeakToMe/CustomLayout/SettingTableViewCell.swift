//
//  SettingTableViewCell.swift
//  SpeakToMe
//
//  Created by 橋詰明宗 on 2018/07/20.
//  Copyright © 2018年 Henry Mason. All rights reserved.
//

import UIKit
import Firebase

class SettingTableViewCell: UITableViewCell {

    @IBOutlet weak var settingLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func changPermission(_ sender: UISwitch) {
        let ref = Database.database().reference()
        
        let data = ["read":sender.isOn]
        ref.child("permission").child(Util.getUUID()).setValue(data)
    }
    
}
