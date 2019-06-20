//
//  PhotoLibraryCoordinator.swift
//  InstagramFirebase
//
//  Created by Developer on 6/18/19.
//  Copyright © 2019 Developer. All rights reserved.
//

import UIKit
class PhotoLiubraryCoordinator: Coordinator{
    var navController: UINavigationController
    
    init(navController: UINavigationController) {
        self.navController = navController
    }
    
    override func start() {
        print("Started")
    }
    
}
