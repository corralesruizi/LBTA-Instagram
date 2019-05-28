import Foundation
protocol LoginDelegate:class {
    func enableLogin()
    func disableLogin()
    func onLoginSucess()
    func onLoginFailure(errorMessage: String)
    func signUp()
}
