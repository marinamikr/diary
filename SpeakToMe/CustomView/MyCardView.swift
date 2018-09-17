//
//  MyCardView.swift
//  SpeakToMe
//
//  Created by User on 2018/07/20.
//  Copyright © 2018年 Marina Harada. All rights reserved.
//

import UIKit
import Cartography
import Firebase

class MyCardView: UIView {
    
    let iconImageView = UIImageView()
    let userNameLabel = UILabel()
    let dateLabel = UILabel()
    let pictureImageView = UIImageView()
    let contentsLabel = UILabel()
    let heartImageView = UIImageView()
    let heartLabel = UILabel()
    let view1 = UIView()
    let view2 = UIView()
    var contentView : UIView!
    let ref = Database.database().reference()
    var postDict :[String : AnyObject]!
    var UUID: String!
    var key: String!
    var userName :String!
    var contents :String!
    var date :String!
    var URL :String!
    var like : Int!
    var index :Int!
    
    
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
        contentView = UIView(frame: self.bounds)
        contentView.backgroundColor = UIColor.white
        self.addSubview(contentView)
        //SetFont
        contentsLabel.font = UIFont(name: "Mamelon", size: contentsLabel.font.pointSize)
        userNameLabel.font = UIFont(name: "Mamelon", size: userNameLabel.font.pointSize)
        heartLabel.font = UIFont(name: "Mamelon", size: heartLabel.font.pointSize)
        dateLabel.font = UIFont(name: "Mamelon", size: dateLabel.font.pointSize)
        
        //font position
        dateLabel.textAlignment = NSTextAlignment.right
        heartLabel.textAlignment = NSTextAlignment.center
        
        //サイズの自動調整
        contentsLabel.numberOfLines = 0
        contentsLabel.sizeToFit()
        contentsLabel.adjustsFontSizeToFitWidth = true
        contentsLabel.minimumScaleFactor = 0.3
        
        heartLabel.numberOfLines = 0
        heartLabel.sizeToFit()
        heartLabel.adjustsFontSizeToFitWidth = true
        heartLabel.minimumScaleFactor = 0.3
        
        userNameLabel.numberOfLines = 0
        userNameLabel.sizeToFit()
        userNameLabel.adjustsFontSizeToFitWidth = true
        userNameLabel.minimumScaleFactor = 0.3
        
        dateLabel.numberOfLines = 0
        dateLabel.sizeToFit()
        dateLabel.adjustsFontSizeToFitWidth = true
        dateLabel.minimumScaleFactor = 0.3
        
        contentView.addSubview(pictureImageView)
        contentView.addSubview(userNameLabel)
        contentView.addSubview(heartImageView)
        contentView.addSubview(heartLabel)
        contentView.addSubview(dateLabel)
        contentView.addSubview(iconImageView)
        contentView.addSubview(contentsLabel)
        contentView.addSubview(view1)
        contentView.addSubview(view2)
        
        constrain(iconImageView, contentView) { view1, view2 in
            view1.left == view2.left + 10
            view1.top == view2.top + 10
            view1.height == 35
            view1.width == 35
        }
        constrain(userNameLabel, iconImageView,contentView) { view1, view2,view3 in
            view1.left == view2.right + 10
            view1.top == view2.top
            view1.height == 35
            view1.width == (view3.width - 35) * 0.4
        }
        constrain(view1, userNameLabel,dateLabel) { view1, view2 ,view3 in
            view1.left == view2.right
            view1.top == view2.top
            view1.right == view3.left
            view1.height == 35
            
        }
        constrain(dateLabel, contentView,contentView) { view1, view2,view3 in
            view1.right == view2.right - 10
            view1.top == view2.top + 10
            view1.height == 35
            view1.width == (view3.width - 35) * 0.4 - 10
        }
        constrain(pictureImageView, contentView) { view1, view2 in
            view1.left == view2.left
            view1.top == view2.top + 35 + 10 + 10
            view1.height == view2.height - 130
            view1.width == view2.width
        }
        constrain(contentsLabel, contentView) { view1, view2 in
            view1.left == view2.left +  10
            view1.bottom == view2.bottom - 10
            view1.height == 55
            view1.width == view2.width * 0.7
        }
        constrain(view2, contentsLabel) { view1, view2 in
            view1.left == view2.right
            view1.top == view2.top
            view1.width == view2.width * 0.25
            view1.height == view2.height * 0.5
            
        }
        constrain(heartImageView, contentsLabel) { view1, view2 in
            view1.left == view2.right + 10
            view1.bottom == view2.bottom
            view1.height == view2.height * 0.5
            view1.width == view1.height
        }
        constrain(heartLabel, heartImageView,contentView) { view1, view2,view3 in
            view1.left == view2.right
            view1.right == view3.right
            view1.bottom == view2.bottom
            view1.height == view2.height
            
        }
    }
    
    func setPicture(image: UIImage){
        pictureImageView.image = image
    }
    
    func setIconImage(image: UIImage){
        iconImageView.image =  image
    }
    
    func setContentsText(text: String){
        self.contents = text
        contentsLabel.text = text
    }
    
    func setUserName(userName: String){
        self.userName = userName
        userNameLabel.text = userName
    }
    
    func setHeartLabel(heartText: String){
        self.like = Int(heartText)
        heartLabel.text = heartText
    }
    
    func setDateLabel(dateText: String){
        self.date = dateText
        dateLabel.text = dateText
    }
    
    func setHeartImage(image: UIImage){
        heartImageView.image = image
    }
    
    func setIndex(index: Int){
        self.index = index
    }
    
    func setBackGroundColor(hex:String){
        userNameLabel.backgroundColor = UIColor(hex: hex)
        iconImageView.backgroundColor = UIColor(hex: hex)
        contentsLabel.backgroundColor = UIColor(hex: hex)
        heartImageView.backgroundColor = UIColor(hex: hex)
        dateLabel.backgroundColor = UIColor(hex: hex)
        heartLabel.backgroundColor = UIColor(hex: hex)
        view1.backgroundColor = UIColor(hex: hex)
        view2.backgroundColor = UIColor(hex: hex)
        contentView.backgroundColor = UIColor(hex: hex)
    }
    
    func setClear(){
        userNameLabel.backgroundColor = UIColor.clear
        iconImageView.backgroundColor = UIColor.clear
        contentsLabel.backgroundColor = UIColor.clear
        heartImageView.backgroundColor = UIColor.clear
        dateLabel.backgroundColor = UIColor.clear
        heartLabel.backgroundColor = UIColor.clear
        view1.backgroundColor = UIColor.clear
        view2.backgroundColor = UIColor.clear
        contentView.backgroundColor = UIColor.clear
        self.backgroundColor = UIColor.clear
    }
    
    func setShadow()  {
        contentView.innerShadow()
    }
    
    
}
