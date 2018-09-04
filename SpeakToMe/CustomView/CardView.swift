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
        self.addSubview(contentView)
        
        contentView.addSubview(iconImageView)
        contentView.addSubview(pictureImageView)
        contentView.addSubview(contentsLabel)
        contentView.addSubview(userNameLabel)
        
        constrain(pictureImageView, contentView) { view1, view2 in
            view1.left == view2.left
            view1.top == view2.top
            view1.height == view2.height - 60
            view1.width == view2.width
        }
        
        constrain(iconImageView, contentView) { view1, view2 in
            view1.left == view2.left
            view1.bottom == view2.bottom
            view1.height == 60
            view1.width == 60
        }
        constrain(contentsLabel, contentView) { view1, view2 in
            view1.right == view2.right
            view1.bottom == view2.bottom
            view1.height == 60
            view1.width == view2.width - 70
        }
        constrain(userNameLabel, contentView) { view1, view2 in
            view1.left == view2.left
            view1.top == view2.top
            view1.height == 90
            view1.width == 180
        }
        
        
        
        
        
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
    
}
