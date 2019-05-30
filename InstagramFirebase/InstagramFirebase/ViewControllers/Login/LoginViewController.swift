import UIKit
import Firebase

class LoginViewController: UIViewController,LoginDelegate {

    @IBOutlet private weak var txtEmail: UITextField!
    @IBOutlet private weak var txtPassword: UITextField!
    @IBOutlet private weak var btnSignUp: UIButton!
    @IBOutlet private weak var btnLogIn: InstagramButtom!
    
    private var loginVM = LoginViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        BindUI()
    }
    
    private func setupUI(){
        navigationController?.isNavigationBarHidden=true
    }
    
    private func BindUI(){
        
        loginVM.delegate = self
        txtEmail.bind(with: loginVM.username)
        txtPassword.bind(with: loginVM.password)
        btnLogIn.bind(with: loginVM.isValid)
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

