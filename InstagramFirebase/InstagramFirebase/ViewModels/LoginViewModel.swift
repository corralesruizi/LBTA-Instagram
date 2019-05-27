//
//  LoginViewModel.swift
//  InstagramFirebase
//
//  Created by Developer on 5/24/19.
//  Copyright © 2019 Developer. All rights reserved.
//

import Foundation

class LoginViewModel{
    
    private var user = User()
    private var firebaseUser: firebaseUser?
    
    var username: Observable<String> = Observable("")
    var pasword: Observable<String> = Observable("")
    
    func login(){
        username.value = "Hello"
        print("Login as user: \(username.value) with password \(pasword.value)" )
    }
}

