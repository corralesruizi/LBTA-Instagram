//
//  User.swift
//  InstagramFirebase
//
//  Created by Developer on 5/14/19.
//  Copyright © 2019 Developer. All rights reserved.
//

import Foundation

struct firebaseUser {
    let uid: String
    let username: String
    let profileImageUrl: String
    
    init(uid: String, dictionary: [String: Any]) {
        self.uid = uid
        self.username = dictionary["username"] as? String ?? ""
        self.profileImageUrl = dictionary["profileImageUrl"]  as? String ?? ""
    }
}
