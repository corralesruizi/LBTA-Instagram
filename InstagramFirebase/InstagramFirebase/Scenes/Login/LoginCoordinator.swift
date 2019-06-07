import UIKit
class LoginCoordinator: Coordinator,LoginDelegate {
    
    private weak var tabMenu: UITabBarController?
    private weak var delegate: TabBarDelegate?
    private let rootVC: UINavigationController
    
    init(tabMenu: UITabBarController){
        self.tabMenu = tabMenu
        rootVC = UINavigationController()
    }
    
    override func start() {
        let loginVM = LoginViewModel()
        let loginVC = LoginViewController()
        loginVM.delegate = self
        loginVC.loginVM=loginVM
        rootVC.viewControllers = [loginVC]
        tabMenu?.present(rootVC, animated: true, completion: nil)
    }
    
    func onLoginSucess() {
        rootVC.dismiss(animated: true, completion: nil)
        delegate?.showTabs()
    }
    
    func onLoginFailure(errorMessage: String) {
        AlertView.showAlert(view: rootVC, title: "Error", message: errorMessage)
    }
    
    func signUp() {
        let signUpVC = SignUpViewController()
        rootVC.pushViewController(signUpVC, animated: true)
    }
}
