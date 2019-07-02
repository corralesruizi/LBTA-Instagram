import UIKit

protocol TabBarDelegate:class {
    func showTabs()
    func showLogin()
    func showPhotoLibrary()
}

class AppCoordinator: Coordinator
{
    let window: UIWindow?
    
    lazy var tabMenuViewModel: TabViewModel = {
        let tabVM = TabViewModel()
        tabVM.delegate = self
        return tabVM
    }()
    
    lazy var tabBarController: MainTabBarController = {
        let tab = MainTabBarController()
        tab.tabVM = tabMenuViewModel
        return tab
    }()
    
    init(window: UIWindow?) {
        self.window = window
    }
    
    override func start() {
        window?.rootViewController = tabBarController
        window?.makeKeyAndVisible()
        showTabs()
    }
}

extension AppCoordinator: TabBarDelegate
{
    func showTabs() {
        
        removeAllChildCoordinatorsWith(type: LoginCoordinator.self)
        let homeController = templateNavController(unselectedImage: #imageLiteral(resourceName: "home_unselected"), selectedImage: #imageLiteral(resourceName: "home_selected"),root: HomeViewController())
        let searchController = templateNavController(unselectedImage: #imageLiteral(resourceName: "search_unselected"), selectedImage: #imageLiteral(resourceName: "search_selected"),root: SearchViewController())
        let cameraController = templateNavController(unselectedImage: #imageLiteral(resourceName: "plus_unselected"), selectedImage: #imageLiteral(resourceName: "plus_unselected"))
        let likeController = templateNavController(unselectedImage: #imageLiteral(resourceName: "like_unselected"), selectedImage: #imageLiteral(resourceName: "like_selected"),root: LikeViewController())
        let userProfileController = templateNavController(unselectedImage: #imageLiteral(resourceName: "profile_unselected"), selectedImage: #imageLiteral(resourceName: "profile_selected"),
                                                          root: UserProfileViewController())
        
        let vcs=[homeController,
                         searchController,
                         cameraController,
                         likeController,
                         userProfileController]
        
        tabBarController.setViewControllers(vcs, animated: true)
        alignImages()
    }
    
    func showLogin() {
        let loginCoordinator = LoginCoordinator(tabMenu: tabBarController)
        loginCoordinator.tabMenuDelegate = self
        addChildCoordinator(loginCoordinator)
        loginCoordinator.start()
    }
    
    func showPhotoLibrary(){
        //Do some child coordinator stuff
    }
    
    fileprivate func alignImages()
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
