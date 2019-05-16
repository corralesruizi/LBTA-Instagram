//
//  NSImageCache.swift
//  InstagramFirebase
//
//  Created by Developer on 5/15/19.
//  Copyright © 2019 Developer. All rights reserved.
//

import Foundation
class NSImageCache{
    static let shared = NSImageCache()
    let imageCache = NSCache<AnyObject, AnyObject>()
    private init(){}
    
}
