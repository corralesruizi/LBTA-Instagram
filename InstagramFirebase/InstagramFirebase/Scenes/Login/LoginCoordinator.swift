import UIKit
class LoginCoordinator: Coordinator,LoginDelegate {
    
    private weak var tabMenu: UITabBarController?
    private weak var tabMenuDelegate: TabBarDelegate?
    private let navController: UINavigationController
    
    init(tabMenu: UITabBarController){
        self.tabMenu = tabMenu
        navController = UINavigationController()
    }
    
    override func start() {
        let loginVM = LoginViewModel()
        let loginVC = LoginViewController()
        loginVM.loginDelegate = self
        loginVC.loginVM=loginVM
        navController.viewControllers = [loginVC]
        tabMenu?.present(navController, animated: true, completion: nil)
    }
    
    func onLoginSucess() {
        navController.dismiss(animated: true, completion: nil)
        tabMenuDelegate?.showTabs()
    }
    
    func onLoginFailure(errorMessage: String) {
        AlertView.showAlert(view: navController, title: "Error", message: errorMessage)
    }
    
    func signUp() {
        let signUpVC = SignUpViewController()
        navController.pushViewController(signUpVC, animated: true)
    }
}
