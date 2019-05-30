import UIKit
protocol LoginDelegate:class {
    func onLoginSucess()
    func onLoginFailure(errorMessage: String)
    func signUp()
}

extension LoginDelegate where Self: UIViewController
{
    func onLoginSucess(){
        dismiss(animated: true, completion: nil)
    }
    
    func onLoginFailure(errorMessage: String){
        AlertView.showAlert(view: self, title: "Error", message: errorMessage)
    }
    
    func signUp() {
        navigationController?.pushViewController(SignUpViewController(), animated: true)
    }
}
