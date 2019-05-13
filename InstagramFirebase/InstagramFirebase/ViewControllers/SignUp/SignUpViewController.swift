import UIKit
import Firebase

class SignUpViewController: UIViewController {

    @IBOutlet weak var btnAddPhoto: UIButton!
    @IBOutlet weak var btnSignUp: UIButton!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtUsername: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        
        navigationController?.isNavigationBarHidden=true
    }
    
    func setPhoto(image: UIImage)
    {
        btnAddPhoto.setImage(image, for: .normal)
    }
    
    
    fileprivate func setupUI()
    {
        btnAddPhoto.layer.cornerRadius = btnAddPhoto.frame.width/2
        btnAddPhoto.layer.masksToBounds = true
        btnAddPhoto.layer.borderColor = UIColor.black.cgColor
        btnAddPhoto.layer.borderWidth = 3
    }
    
    @IBAction func textChanged(_ sender: UITextField) {
        let isFormValid = txtEmail.text?.isEmpty != true
            && txtUsername.text?.isEmpty != true
            && txtPassword.text?.isEmpty != true
        
        if isFormValid {
            btnSignUp.isEnabled = true
            btnSignUp.backgroundColor = AppColor.mainAppColor
        } else {
            btnSignUp.isEnabled = false
            btnSignUp.backgroundColor = AppColor.lightMainAppColor
        }
    }
    
    @IBAction func shouldReturn(_ sender: UITextField) {
        sender.resignFirstResponder()
    }
    
    @IBAction func singupTouchUpInside(_ sender: UIButton) {
        
        guard let email = txtEmail.text, !email.isEmpty else{return}
        guard let username = txtUsername.text, !username.isEmpty else{return}
        guard let password = txtPassword.text, !password.isEmpty else{return}
        guard let image = btnAddPhoto.imageView?.image,image != #imageLiteral(resourceName: "addPhoto") else { return }
        
        Auth.auth().createUser(withEmail: email, password: password, completion: { [weak self] (user, error: Error?) in
            
            if let err = error {
                AlertView.showAlert(view: self, title: "", message: err.localizedDescription)
                return
            }
            
            guard let uploadData = image.jpegData(compressionQuality: 0.3) else { return }
            
            let filename = NSUUID().uuidString
            
            let storageRef = Storage.storage().reference().child("profile_images").child(filename)
            storageRef.putData(uploadData, metadata: nil, completion: { (metadata, err) in
                
                if let err = err {
                    print("Failed to upload profile image:", err)
                    return
                }
                
                // Firebase 5 Update: Must now retrieve downloadURL
                storageRef.downloadURL(completion: { (downloadURL, err) in
                    if let err = err {
                        print("Failed to fetch downloadURL:", err)
                        return
                    }
                    
                    guard let profileImageUrl = downloadURL?.absoluteString else { return }
                    
                    print("Successfully uploaded profile image:", profileImageUrl)
                    
                    guard let uid = user?.user.uid else { return }
                    
                    let dictionaryValues = ["username": username, "profileImageUrl": profileImageUrl]
                    let values = [uid: dictionaryValues]
                    
                    Database.database().reference().child("users").updateChildValues(values, withCompletionBlock: { (err, ref) in
                        
                        if let err = err {
                            print("Failed to save user info into db:", err)
                            return
                        }
                        
                        guard let mainTabBarController = UIApplication.shared.keyWindow?.rootViewController
                            as? MainTabBarController else { return }
                        mainTabBarController.setupTabs()
                        self?.dismiss(animated: true, completion: nil)
                    })
                })
            })
        })
    }
    
    
    @IBAction func singInAction(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func addPhotoTouchUpInside(_ sender: UIButton) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate=self
        imagePicker.allowsEditing=true
        present(imagePicker, animated: true, completion: nil)
    }
}

extension SignUpViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate
{
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        var imageFromLibrary = UIImage()
        
        if let editedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            imageFromLibrary = editedImage.withRenderingMode(.alwaysOriginal)
        } else if let originalImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            imageFromLibrary = originalImage.withRenderingMode(.alwaysOriginal)
        }
        setPhoto(image: imageFromLibrary)
        dismiss(animated: true,completion: nil)
    }
}
