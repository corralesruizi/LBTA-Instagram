import UIKit
import Firebase

class LoginViewController: UIViewController,LoginDelegate {

    @IBOutlet private weak var txtEmail: UITextField!
    @IBOutlet private weak var txtPassword: UITextField!
    @IBOutlet private weak var btnSignUp: UIButton!
    @IBOutlet private weak var btnLogIn: InstagramButtom!
    
    var loginVM: LoginViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("LoginLoaded")
        setupUI()
        BindUI()
    }
    
    private func setupUI(){
        navigationController?.isNavigationBarHidden=true
    }
    
    private func BindUI(){
        guard let vm = loginVM else { return}
        txtEmail.bind(with: vm.username)
        txtPassword.bind(with: vm.password)
        btnLogIn.bind(with: vm.isValid)
    }
    
    @IBAction func signUpAction(_ sender: UIButton) {
        loginVM?.signUp()
    }
    
    @IBAction func logInAction(_ sender: UIButton) {
        loginVM?.login()
    }

    @IBAction func textChanged(_ sender: UITextField) {
        sender.valueChanged()
        loginVM?.validateForm()
    }
    
    @IBAction func returnPressed(_ sender: UITextField) {
        sender.resignFirstResponder()
    }
}

