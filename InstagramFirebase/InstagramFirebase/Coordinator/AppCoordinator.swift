import Foundation
import  UIKit


protocol AppCoordinatorDelegate {
    func showLogin()
    func showTabmenu()
}

class AppCoordinator:Coordinator,AppCoordinatorDelegate  {
    func showLogin() {
        
    }
    
    func showTabmenu() {
        
    }
    
    
    let window: UIWindow?
    
    lazy var rootViewController: MainTabBarController = {
        let mainTab = MainTabBarController()
        return MainTabBarController()
    }()
    
    init(window: UIWindow?) {
        self.window = window
    }
    
    override func start() {
        guard let window = window else {
            return
        }
        
        window.rootViewController = rootViewController
        window.makeKeyAndVisible()
    }
}
