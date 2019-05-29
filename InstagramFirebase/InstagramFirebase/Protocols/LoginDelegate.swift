import Foundation
protocol LoginDelegate:class {
    func onLoginSucess()
    func onLoginFailure(errorMessage: String)
    func signUp()
}
