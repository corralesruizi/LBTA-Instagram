import Foundation
import Firebase

class LoginViewModel{
    
    var username: Observable<String> = Observable()
    var password: Observable<String> = Observable()
    var isValid: Observable<Bool> = Observable()
    weak var loginDelegate: LoginDelegate?
    
    func login(){
        
        guard let email = username.value else { return }
        guard let pass = password.value else { return }
        
        Auth.auth().signIn(withEmail: email, password: pass, completion: { [weak self] (user, err) in
            if let err = err {
               self?.loginDelegate?.onLoginFailure(errorMessage: err.localizedDescription)
                return
            }
            self?.loginDelegate?.onLoginSucess()
        })
    }
    
    func signUp(){
        loginDelegate?.signUp()
    }
}

extension LoginViewModel{
    
    func validateForm(){
        
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

