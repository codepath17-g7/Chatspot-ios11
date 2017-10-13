//
//  ChatRoom.swift
//  chatspot
//
//  Created by Phuong Nguyen on 10/11/17.
//  Copyright © 2017 g7. All rights reserved.
//

import RealmSwift

class ChatRoom: Object { // Object is from Realm, this also extends a NSObject.
    
    @objc dynamic var guid: String!
    @objc dynamic var name: String!
    @objc dynamic var createdAt: Date!
    @objc dynamic var roomBanner: String?

    let longitude = RealmOptional<Double>() // primitive types can be made optional in realm by using a `RealmOptional`
    let latitude = RealmOptional<Double>()
    let userCount = RealmOptional<Int>()
    let roomActivity = RealmOptional<Int>()

    // linking between a chat room and all of its messages
    let messages = LinkingObjects(fromType: Message.self, property: "chatRoom")
    
    override static func primaryKey() -> String? {
        return "guid"
    }
}
