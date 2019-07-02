import Firebase
class TabViewModel{
    weak var delegate: TabBarDelegate?
    
    func checkCredentials(){
        print("Validating user")
        if Auth.auth().currentUser == nil {
            DispatchQueue.main.async { [weak self] in
                self?.delegate?.showLogin()
            }
        }
    }
    
    func presentLibrary(){
        print("presenting gallery")
    }
}
