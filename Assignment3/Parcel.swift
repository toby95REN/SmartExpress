//
//  Parcel.swift
//  Assignment3
//
//  Created by apple on 2018/11/1.
//  Copyright © 2018年 Monash University. All rights reserved.
//

import UIKit

class Parcel: NSObject {
    var uniqueId: String?
    var parcelNumber: String?
    var sender: String?
    var senderLocation: String?
    var senderPostcode: String?
    var senderState: String?
    var receiver: String?
    var receiverLocation: String?
    var receiverPostcode: String?
    var receiverState: String?
    var status: String?
    
    override init() {
        uniqueId = ""
        parcelNumber = ""
        sender = ""
        receiver = ""
        senderLocation = ""
        receiverLocation = ""
        status = ""
    }
}
