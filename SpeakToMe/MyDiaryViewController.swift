//
//  MyDiaryViewController.swift
//  SpeakToMe
//
//  Created by User on 2018/06/30.
//  Copyright © 2018年 Henry Mason. All rights reserved.
//

import Foundation
import UIKit

class MyDiaryViewController: UIViewController {
    @IBOutlet weak var myHonbun: UITextView!
    @IBOutlet weak var myImage: UIImageView!
    @IBOutlet weak var hidukeLabel: UILabel!
    
    var date = String()
    var contents = String()
    var images = UIImage()
    var myimages = NSData()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        myImage.image = UIImage(data: myimages as Data)
        
        hidukeLabel.text = date
        myHonbun.text = contents
      
        
        
    }
        override func didReceiveMemoryWarning() {
            super.didReceiveMemoryWarning()
        }
        
}

