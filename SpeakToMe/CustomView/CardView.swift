//
//  CardView.swift
//  DatabaseApp
//
//  Created by 橋詰明宗 on 2017/09/07.
//  Copyright © 2017年 橋詰明宗. All rights reserved.
//

import UIKit
import Cartography

class CardView: UIView {
    
    let pictureImageView = UIImageView()
    let iconImageView = UIImageView()
    let userNameLabel = UILabel()
    let contentsLabel = UILabel()
    let heartImageView = UIImageView()
    let dateLabel = UILabel()
    let heartLabel = UILabel()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    func setup() {
        // Shadow
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.25
        layer.shadowOffset = CGSize(width: 0, height: 1.5)
        layer.shadowRadius = 4.0
        layer.shouldRasterize = true
        layer.rasterizationScale = UIScreen.main.scale
        
        // Corner Radius
        layer.cornerRadius = 10.0;
        self.clipsToBounds = true
        
        let contentView = UIView(frame: self.bounds)
        contentView.backgroundColor = UIColor.white
        contentView.innerShadow()
        self.addSubview(contentView)
       
        
        
        
        contentView.addSubview(pictureImageView)
        contentView.addSubview(userNameLabel)
        contentView.addSubview(heartImageView)
        contentView.addSubview(heartLabel)
        contentView.addSubview(dateLabel)
        contentView.addSubview(iconImageView)
        contentView.addSubview(contentsLabel)
        
        
//        contentView.addSubview(iconImageView)
//
//
//
//        contentView.addSubview(contentsLabel)
//        contentView.addSubview(heartLabel)
//
//        contentView.addSubview(dateLabel)
        
        constrain(pictureImageView, contentView) { view1, view2 in
            view1.left == view2.left
            view1.top == view2.top
            view1.height == view2.height - 90
            view1.width == view2.width
        }
        constrain(userNameLabel, pictureImageView) { view1, view2 in
            view1.left == view2.left
            view1.top == view2.bottom
            view1.height == 45
            view1.width == view2.width * 0.4
            
        }
        constrain(heartImageView, userNameLabel) { view1, view2 in
            view1.left == view2.right
            view1.top == view2.top
            view1.height == 45
            view1.width == view2.width * 0.25
        }
        constrain(heartLabel, heartImageView) { view1, view2 in
            view1.left == view2.right
            view1.top == view2.top
            view1.height == 45
            view1.width == view2.width
        }
        constrain(dateLabel, heartLabel) { view1, view2 in
            view1.left == view2.right
            view1.top == view2.top
            view1.height == 45
            view1.width == view2.width * 4
        }
        constrain(iconImageView, userNameLabel) { view1, view2 in
            view1.left == view2.left
            view1.top == view2.bottom
            view1.height == 45
            view1.width == 45
        }
        constrain(contentsLabel, contentView) { view1, view2 in
            view1.right == view2.right
            view1.bottom == view2.bottom
            view1.height == 45
            view1.width == view2.width - 45
        }
        
        
        
        
        
//
//        constrain(heartLabel, pictureImageView) { view1, view2 in
//            view1.left == view2.left
//            view1.top == view2.bottom
//            view1.height == 90
//            view1.width == view2.width * 0.6
//        }
//
//        constrain(dateLabel, pictureImageView) { view1, view2 in
//            view1.left == view2.left
//            view1.top == view2.top
//            view1.height == 90
//            view1.width == view2.width
//        }
//
//        constrain(iconImageView, contentView) { view1, view2 in
//            view1.left == view2.left
//            view1.bottom == view2.bottom
//            view1.height == 60
//            view1.width == 60
//        }
//        constrain(contentsLabel, contentView) { view1, view2 in
//            view1.right == view2.right
//            view1.bottom == view2.bottom
//            view1.height == 60
//            view1.width == view2.width - 70
//        }
       
       
       
   
        
        
        
    }
    
    func setPicture(url: String){
        pictureImageView.loadImage(urlString: url)
    }
    
    func setIconImage(url: String){
        iconImageView.loadImage(urlString: url)
    }
    
    func setContentsText(text: String){
        contentsLabel.text = text
    }
    
    func setUserName(userName: String){
        userNameLabel.text = userName
    }
    func setHeartLabel(heartText: String){
        heartLabel.text = heartText
    }
    func setDateLabel(dateText: String){
        dateLabel.text = dateText
    }
    
    func setHeartImage(image: UIImage){
        heartImageView.image = image
    }
    
    func setBackGroundColor(hex:String){
        userNameLabel.backgroundColor = UIColor(hex: hex)
        iconImageView.backgroundColor = UIColor(hex: hex)
        contentsLabel.backgroundColor = UIColor(hex: hex)
        heartImageView.backgroundColor = UIColor(hex: hex)
        dateLabel.backgroundColor = UIColor(hex: hex)
        heartLabel.backgroundColor = UIColor(hex: hex)
    }
}
