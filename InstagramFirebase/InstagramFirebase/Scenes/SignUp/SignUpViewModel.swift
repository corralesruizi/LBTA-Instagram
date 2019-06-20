import Foundation
import Firebase

class SignUpViewModel{
    
    var username: Observable<String> = Observable()
    var password: Observable<String> = Observable()
    var isValid: Observable<Bool> = Observable()
    var hasImage: Observable<Bool> = Observable()
    var image: Observable<UIImage> = Observable()
    var errorMessage: Observable<String> = Observable()
 
    weak var loginDelegate: LoginDelegate?
    
    func singUp(){
        
        guard let email = username.value else { return }
        guard let pass = password.value else { return }
     
         Auth.auth().createUser(withEmail: email, password: pass, completion: { [weak self] (user, error: Error?) in
            
            if let err = error {
                self?.errorMessage.value = err.localizedDescription
                return
            }
            self?.uploadImage()
         })
    }
    
    func selectPhoto(image: UIImage){
        self.image.value = image
    }
    
    private func uploadImage(){
        
        guard let img = image.value else {return}
        guard let uploadData = img.jpegData(compressionQuality: 0.3) else { return }
        
        let filename = NSUUID().uuidString
        let storageRef = Storage.storage().reference().child("profile_images").child(filename)
        
        storageRef.putData(uploadData, metadata: nil, completion: { [weak self](metadata, err) in
            
            if let err = err {
                self?.errorMessage.value = err.localizedDescription
                return
            }
            
            storageRef.downloadURL(completion: { (downloadURL, err) in
                if let err = err {
                    self?.errorMessage.value = err.localizedDescription
                    return
                }
                
                guard let profileImageUrl = downloadURL?.absoluteString else { return }
                self?.updateUser(profileImageUrl: profileImageUrl)
            })
        })
    }
    
    private func updateUser(profileImageUrl: String){
        
        guard let uid = Auth.auth().currentUser?.uid else { return }
        guard let username = username.value else { return }
        let dictionaryValues = ["username": username, "profileImageUrl": profileImageUrl]
        let values = [uid: dictionaryValues]
        
        Database.database().reference().child("users").updateChildValues(values, withCompletionBlock: { [weak self](err, ref) in
            
            if let err = err {
                self?.errorMessage.value = err.localizedDescription
                return
            }
            
            self?.loginDelegate?.onLoginSucess()
        })
    }
}
