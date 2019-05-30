import UIKit
protocol LoginDelegate:class {
    func onLoginSucess()
    func onLoginFailure(errorMessage: String)
    func signUp()
}

extension LoginDelegate where Self: UIViewController
{
    func onLoginSucess(){
        guard let mainTabBarController = UIApplication.shared.keyWindow?.rootViewController
            as? MainTabBarController else { return }
        mainTabBarController.setupTabs()
        dismiss(animated: true, completion: nil)
    }
    
    func onLoginFailure(errorMessage: String){
        AlertView.showAlert(view: self, title: "Error", message: errorMessage)
    }
    
    func signUp() {
        navigationController?.pushViewController(SignUpViewController(), animated: true)
    }
}
