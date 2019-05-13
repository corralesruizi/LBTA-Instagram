import Foundation
import UIKit
import Firebase

class MainTabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if Auth.auth().currentUser == nil {
            DispatchQueue.main.async { [weak self] in
                let loginController = LoginViewController()
                self?.present(UINavigationController(rootViewController: loginController),
                             animated: true, completion: nil)
            }
            return
        }
        
        setupTabs()
        setupTabImages()
    }
    
    func setupTabs()
    {
        let homeController = templateNavController(unselectedImage: #imageLiteral(resourceName: "home_unselected"), selectedImage: #imageLiteral(resourceName: "home_selected"))
        let searchController = templateNavController(unselectedImage: #imageLiteral(resourceName: "search_unselected"), selectedImage: #imageLiteral(resourceName: "search_selected"))
        let cameraController = templateNavController(unselectedImage: #imageLiteral(resourceName: "plus_unselected"), selectedImage: #imageLiteral(resourceName: "plus_unselected"))
        let likeController = templateNavController(unselectedImage: #imageLiteral(resourceName: "like_unselected"), selectedImage: #imageLiteral(resourceName: "like_selected"))
        let userProfileController = templateNavController(unselectedImage: #imageLiteral(resourceName: "profile_unselected"), selectedImage: #imageLiteral(resourceName: "profile_selected"),
                                                          root: UserProfileViewController())
        
        
        viewControllers=[homeController,
                         searchController,
                         cameraController,
                         likeController,
                         userProfileController]
    }
    
    
    fileprivate func setupTabImages()
    {
        guard let items = tabBar.items else { return }
        
        for item in items {
            item.imageInsets = UIEdgeInsets(top: 4, left: 0, bottom: -4, right: 0)
        }
    }
    
    fileprivate func templateNavController(unselectedImage: UIImage,selectedImage: UIImage,
                                           root: UIViewController=UIViewController())->UINavigationController{
        
        let navController = UINavigationController(rootViewController: root)
        navController.tabBarItem.image = unselectedImage
        navController.tabBarItem.selectedImage = selectedImage
        return navController
    }
}
