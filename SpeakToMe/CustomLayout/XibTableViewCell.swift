//
//  XibTableViewCell.swift
//  SpeakToMe
//
//  Created by User on 2018/06/05.
//  Copyright © 2018年 Marina Harada. All rights reserved.
//
import UIKit
import Firebase

class XibTableViewCell: UITableViewCell {
    
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var honbunLabel: UILabel!
    @IBOutlet weak var urlImage: UIImageView!
    @IBOutlet weak var likeLabel: UILabel!
    var uuId: String!
    var key: String!
    var userName :String!
    var contents :String!
    var date :String!
    var URL :String!
    var like : Int!
    let ref = Database.database().reference()
    var postDict :[String : AnyObject]!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    @IBAction func favorite(_ sender: Any) {
        like = like + 1
        likeLabel.text = String(like)
        let data = ["userName":userName,"contents": contents,"date": date,"URL": URL,"like": like] as [String : Any]
        self.ref.child(uuId).child(key).updateChildValues(data)
    }
}
