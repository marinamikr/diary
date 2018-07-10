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
    var like = Int()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        diaryTextView.text = contents
        diaryImageView.loadImage(urlString: url)
        dateLabel.text = date
        likeLabel.text = String(like)

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
