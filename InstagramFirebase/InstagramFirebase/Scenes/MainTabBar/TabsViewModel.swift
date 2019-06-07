import Firebase
class TabViewModel{
    weak var delegate: TabBarDelegate?
    
    func checkCredentials(){
        if Auth.auth().currentUser == nil {
            DispatchQueue.main.async { [weak self] in
                self?.delegate?.showLogin()
            }
        }
    }
}
