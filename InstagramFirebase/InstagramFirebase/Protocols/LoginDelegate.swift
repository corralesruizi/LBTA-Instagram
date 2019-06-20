import UIKit
protocol LoginDelegate:class {
    func goToLogin()
    func goToSignUp()
    func onLoginSucess()
    func onLoginFailure(errorMessage: String)
    func onSignUpSucess()
    func onSignUpFailure(errorMessage: String)
    func showPhotoLibrary()
    func closePhotoLibrary()
}
