import UIKit
import Firebase

class SignUpViewController: UIViewController {

    @IBOutlet weak var btnAddPhoto: UIButton!
    @IBOutlet weak var btnSignUp: UIButton!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtUsername: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    
    var signUpVM: SignUpViewModel?
    
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
            btnSignUp.backgroundColor = .mainAppColor
        } else {
            btnSignUp.isEnabled = false
            btnSignUp.backgroundColor = .lightMainAppColor
        }
    }
    
    @IBAction func shouldReturn(_ sender: UITextField) {
        sender.resignFirstResponder()
    }
    
    @IBAction func singupTouchUpInside(_ sender: UIButton) {
        //Call SignUp
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
