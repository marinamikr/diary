//
//  UserModel.swift
//  SpeakToMe
//
//  Created by User on 2018/07/20.
//  Copyright © 2018年 Marina Harada. All rights reserved.
//

import Foundation
import RealmSwift

class UserModel: Object {
    
    dynamic var nickName = String()
    dynamic var icon = NSData()
    dynamic var iconURL = String()   
}

