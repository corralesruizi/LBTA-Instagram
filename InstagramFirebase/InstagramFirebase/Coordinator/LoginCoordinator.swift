import UIKit
class LoginCoordinator: Coordinator {
    
    var navigationController: UINavigationController
    
    init(navController: UINavigationController) {
        self.navigationController = navController
    }
    
    override func start() {
        print("Hello")
    }
    
}
