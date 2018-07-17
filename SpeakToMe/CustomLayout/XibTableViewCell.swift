//
//  XibTableViewCell.swift
//  SpeakToMe
//
//  Created by User on 2018/06/05.
//  Copyright © 2018年 Marina Harada. All rights reserved.
//
import UIKit

class XibTableViewCell: UITableViewCell {

    @IBOutlet weak var userNameLabel: UILabel!
    
    @IBOutlet weak var dateLabel: UILabel!
    
    @IBOutlet weak var honbunLabel: UILabel!
    
    @IBOutlet weak var urlImage: UIImageView!
    
    @IBOutlet weak var likeLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
