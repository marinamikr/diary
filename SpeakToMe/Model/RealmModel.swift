//
//  RealmModel.swift
//  SpeakToMe
//
//  Created by User on 2018/06/05.
//  Copyright © 2018年 Marina Harada. All rights reserved.
//

import Foundation
import RealmSwift

class RealmModel: Object {
    
    dynamic var hizuke = String()
    dynamic var honbunn = String()
    dynamic var image =  NSData()
    dynamic var UUID = String()
    dynamic var key = String()
}
