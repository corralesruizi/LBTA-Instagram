import Foundation
import Firebase

class LoginViewModel{
    
    var username: Observable<String> = Observable()
    var password: Observable<String> = Observable()
    var isValid: Observable<Bool> = Observable()
    weak var delegate: LoginDelegate?
    
    func login(){
        
        guard let email = username.value else { return }
        guard let pass = password.value else { return }
        
        Auth.auth().signIn(withEmail: email, password: pass, completion: { [weak self] (user, err) in
            if let err = err {
               self?.delegate?.onLoginFailure(errorMessage: err.localizedDescription)
                return
            }
            self?.delegate?.onLoginSucess()
        })
    }
    
    func signUp(){
        delegate?.signUp()
    }
}

extension LoginViewModel{
    
    func validateForm(){
        print("VAlidating")
        
        let usernameValidator = VaildatorFactory.validatorFor(type: .requiredField)
        let passwordValidator = VaildatorFactory.validatorFor(type: .requiredField)
        
        do {
            try usernameValidator.validated(username.value)
            try passwordValidator.validated(password.value)
            isValid.value = true
        }catch{
            isValid.value = false
        }
    }
}

