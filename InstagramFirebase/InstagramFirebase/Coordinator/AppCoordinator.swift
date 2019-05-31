import UIKit

protocol TabBarDelegate:class {
    func setUpTabs()
    func showLogin()
    func showPhotoLibrary()
}

class AppCoordinator: Coordinator
{
    let window: UIWindow?
    var tabBarController: MainTabBarController
    
    init(window: UIWindow?) {
        self.window = window
        tabBarController = MainTabBarController()
    }
    
    override func start() {
        tabBarController.tabVM = TabViewModel()
        window?.rootViewController = tabBarController
        window?.makeKeyAndVisible()
    }
}

extension AppCoordinator: TabBarDelegate
{
    func setUpTabs() {
        let homeController = templateNavController(unselectedImage: #imageLiteral(resourceName: "home_unselected"), selectedImage: #imageLiteral(resourceName: "home_selected"),root: HomeViewController())
        let searchController = templateNavController(unselectedImage: #imageLiteral(resourceName: "search_unselected"), selectedImage: #imageLiteral(resourceName: "search_selected"),root: SearchViewController())
        let cameraController = templateNavController(unselectedImage: #imageLiteral(resourceName: "plus_unselected"), selectedImage: #imageLiteral(resourceName: "plus_unselected"))
        let likeController = templateNavController(unselectedImage: #imageLiteral(resourceName: "like_unselected"), selectedImage: #imageLiteral(resourceName: "like_selected"),root: LikeViewController())
        let userProfileController = templateNavController(unselectedImage: #imageLiteral(resourceName: "profile_unselected"), selectedImage: #imageLiteral(resourceName: "profile_selected"),
                                                          root: UserProfileViewController())
        
        
        tabBarController.viewControllers=[homeController,
                         searchController,
                         cameraController,
                         likeController,
                         userProfileController]
        
        setupTabImages()
    }
    
    func showLogin() {
        //Do some child coordinator logic
    }
    
    func showPhotoLibrary(){
        //Do some child coordinator stuff
    }
    
    fileprivate func setupTabImages()
    {
        guard let items = tabBarController.tabBar.items else { return }
        
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
