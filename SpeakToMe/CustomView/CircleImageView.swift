//
//  CircleImageView.swift
//  SpeakToMe
//
//  Created by 橋詰明宗 on 2018/07/20.
//  Copyright © 2018年 Henry Mason. All rights reserved.
//

import UIKit
class CircleImageView: UIImageView {
    @IBInspectable var borderColor :  UIColor = UIColor.black
    @IBInspectable var borderWidth :  CGFloat = 0.1
    
    override var image: UIImage? {
        didSet{
            layer.masksToBounds = false
            layer.borderColor = borderColor.cgColor
            layer.borderWidth = borderWidth
            layer.cornerRadius = frame.height/2
            clipsToBounds = true
        }
}
}
