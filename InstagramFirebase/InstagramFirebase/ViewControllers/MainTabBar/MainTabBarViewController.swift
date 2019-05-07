//
//  File.swift
//  InstagramFirebase
//
//  Created by Developer on 5/7/19.
//  Copyright © 2019 Developer. All rights reserved.
//

import Foundation
import UIKit

class MainTabBarController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let userProfile = UserProfileViewController()
        let navController = UINavigationController(rootViewController: userProfile)
        userProfile.tabBarItem.image = #imageLiteral(resourceName: "profile_unselected")
        userProfile.tabBarItem.selectedImage = #imageLiteral(resourceName: "profile_selected")
        viewControllers=[navController,UIViewController()]
    }
}
