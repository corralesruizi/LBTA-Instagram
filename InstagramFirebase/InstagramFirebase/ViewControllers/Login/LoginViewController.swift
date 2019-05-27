import UIKit
import Firebase

class LoginViewController: UIViewController {

    //MVVM Section
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var btnSignUp: UIButton!
    @IBOutlet weak var btnLogIn: UIButton!
    
    private var loginVM = LoginViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        BindUI()
        navigationController?.isNavigationBarHidden=true
    }
    
    private func BindUI()
    {
        loginVM.username.bind { [weak self] in
            self?.txtEmail.text = $0
        }
        
        loginVM.pasword.bind { [weak self] in
            self?.txtPassword.text = $0
        }
    }
    
    //IGNORE MVC Code Below
    @IBAction func signUpAction(_ sender: UIButton) {
        navigationController?.pushViewController(SignUpViewController(), animated: true)
    }
    
    
    @IBAction func logInAction(_ sender: UIButton) {
        
        loginVM.login()
        return
        
        guard let email = txtEmail.text else { return }
        guard let password = txtPassword.text else { return }
        
        Auth.auth().signIn(withEmail: email, password: password, completion: { [weak self] (user, err) in
            
            if let err = err {
                AlertView.showAlert(view: self, title: "Error", message: err.localizedDescription)
                return
            }
            
            guard let mainTabBarController = UIApplication.shared.keyWindow?.rootViewController as?
                MainTabBarController else { return }
            
            mainTabBarController.setupTabs()
            self?.dismiss(animated: true, completion: nil)
        })
    }
    
    
    
    @IBAction func textChanged(_ sender: UITextField) {

        loginVM.username.value = txtEmail.text ?? ""
        loginVM.pasword.value = txtPassword.text ?? ""
        
        let isFormValid = txtEmail.text?.isEmpty == false
            && txtPassword.text?.isEmpty == false

        if isFormValid{
            btnLogIn.isEnabled=true
            btnLogIn.backgroundColor = .mainAppColor
        }
        else
        {
            btnLogIn.isEnabled=false
            btnLogIn.backgroundColor = .lightMainAppColor
        }
    }
    
    @IBAction func returnPressed(_ sender: UITextField) {
        sender.resignFirstResponder()
    }
    
}

