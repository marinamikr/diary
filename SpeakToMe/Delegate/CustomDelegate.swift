//
//  CustomDelegate.swift
//  SpeakToMe
//
//  Created by User on 2018/07/20.
//  Copyright © 2018年 Marina Harada. All rights reserved.
//

import Foundation

protocol CustomDelegate {
    func toMyDiary() -> Void
    func toMyFriendDiary() -> Void
    func tocamera() -> Void
    func toqrcode() -> Void
    func tosetting() -> Void
}
