//
//  AllDiaryViewController.swift
//  SpeakToMe
//
//  Created by User on 2018/06/05.
//  Copyright © 2018年 Marina Harada. All rights reserved.
//


import UIKit

class AllDiaryViewController: UIViewController {
    
    @IBOutlet weak var diaryTextView: UITextView!
    @IBOutlet weak var diaryImageView: UIImageView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var likeLabel: UILabel!
    var userName = String()
    var date = String()
    var contents = String()
    var url = String()
    var like = String()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        diaryTextView.text = contents
        diaryImageView.loadImage(urlString: url)
        dateLabel.text = date
        likeLabel.text = like + " likes"
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
