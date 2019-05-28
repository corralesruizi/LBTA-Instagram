import UIKit
import Firebase

class LoginViewController: UIViewController {

    @IBOutlet private weak var txtEmail: UITextField!
    @IBOutlet private weak var txtPassword: UITextField!
    @IBOutlet private weak var btnSignUp: UIButton!
    @IBOutlet private weak var btnLogIn: UIButton!
    
    private var loginVM = LoginViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        BindUI()
    }
    
    private func setupUI()
    {
        navigationController?.isNavigationBarHidden=true
    }
    
    private func BindUI()
    {
        loginVM.delegate = self
        txtEmail.bind(with: loginVM.username)
        txtPassword.bind(with: loginVM.password)
    }
    
    @IBAction func signUpAction(_ sender: UIButton) {
        loginVM.signUp()
    }
    
    @IBAction func logInAction(_ sender: UIButton) {
        loginVM.login()
    }

    @IBAction func textChanged(_ sender: UITextField) {
        sender.valueChanged()
        loginVM.validateForm()
    }
    
    @IBAction func returnPressed(_ sender: UITextField) {
        sender.resignFirstResponder()
    }
}

extension LoginViewController: LoginDelegate{
    
    func onLoginSucess() {
        guard let mainTabBarController = UIApplication.shared.keyWindow?.rootViewController as?
            MainTabBarController else { return }
        
        mainTabBarController.setupTabs()
        self.dismiss(animated: true, completion: nil)
    }
    
    func onLoginFailure(errorMessage: String) {
        AlertView.showAlert(view: self, title: "Error", message: errorMessage)
    }
    
    func enableLogin() {
        btnLogIn.isEnabled=true
        btnLogIn.backgroundColor = .mainAppColor
    }
    
    func disableLogin() {
        btnLogIn.isEnabled=false
        btnLogIn.backgroundColor = .lightMainAppColor
    }
    
    func signUp() {
        navigationController?.pushViewController(SignUpViewController(), animated: true)
    }
}

