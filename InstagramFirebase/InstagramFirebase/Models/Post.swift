//
//  Post.swift
//  InstagramFirebase
//
//  Created by Developer on 5/14/19.
//  Copyright © 2019 Developer. All rights reserved.
//

import Foundation

struct Post {
    var id: String?
    let user: firebaseUser
    let imageUrl: String
    let caption: String
    let creationDate: Date
    
    var hasLiked = false
    
    init(user: firebaseUser, dictionary: [String: Any]) {
        self.user = user
        self.imageUrl = dictionary["imageUrl"] as? String ?? ""
        self.caption = dictionary["caption"] as? String ?? ""
        
        let secondsFrom1970 = dictionary["creationDate"] as? Double ?? 0
        self.creationDate = Date(timeIntervalSince1970: secondsFrom1970)
    }
}
