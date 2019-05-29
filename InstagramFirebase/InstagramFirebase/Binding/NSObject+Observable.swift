//
//  NSObject+Observable.swift
//  InstagramFirebase
//
//  Created by Developer on 5/27/19.
//  Copyright © 2019 Developer. All rights reserved.
//

import Foundation

extension NSObject {
    public func observe<T>(for observable: Observable<T>, with: @escaping (T) -> ()) {
        observable.bind { observable, value  in
            DispatchQueue.main.async {
                with(value)
            }
        }
    }
}
