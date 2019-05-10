import Foundation
import UIKit
import Firebase

class MainTabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if Auth.auth().currentUser == nil {
            DispatchQueue.main.async { [weak self] in
              self?.showLogin()
            }
            return
        }
        
        setupTabs()
    }
    
    func setupTabs()
    {
        let userProfile = UserProfileViewController()
        let navController = UINavigationController(rootViewController: userProfile)
        userProfile.tabBarItem.image = #imageLiteral(resourceName: "profile_unselected")
        userProfile.tabBarItem.selectedImage = #imageLiteral(resourceName: "profile_selected")
        viewControllers=[navController,UIViewController()]
    }
    
    fileprivate func showLogin()
    {
        let loginController = LoginViewController()
        self.present(UINavigationController(rootViewController: loginController),
                     animated: true, completion: nil)
    }
}
