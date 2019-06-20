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
    
    fileprivate func BindUI(){
        
        signUpVM?.image.bind(observer: {[weak self] (observer, value) in
            self?.btnAddPhoto.setImage(value, for: .normal)
        })
        
        signUpVM?.errorMessage.bind(observer: { [weak self](observer, value) in
            AlertView.showAlert(view: self, title: "Error", message: value)
        })
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
        signUpVM?.singUp()
    }
    
    @IBAction func singInAction(_ sender: Any) {
        //Coordinator
        //navigationController?.popViewController(animated: true)
    }
    
    @IBAction func addPhotoTouchUpInside(_ sender: UIButton) {
        //Coordinator
        //let imagePicker = UIImagePickerController()
        //imagePicker.delegate=self
        //imagePicker.allowsEditing=true
        //present(imagePicker, animated: true, completion: nil)
    }
}

extension SignUpViewController: UIImagePickerControllerDelegate
{
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        var imageFromLibrary = UIImage()
        
        if let editedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            imageFromLibrary = editedImage.withRenderingMode(.alwaysOriginal)
        } else if let originalImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            imageFromLibrary = originalImage.withRenderingMode(.alwaysOriginal)
        }

        signUpVM?.selectPhoto(image: imageFromLibrary)
    }
}
