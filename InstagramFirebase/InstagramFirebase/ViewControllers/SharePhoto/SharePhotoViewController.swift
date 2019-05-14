import UIKit
import Firebase

class SharePhotoViewController: UIViewController {

    @IBOutlet weak var imgPhoto: UIImageView!
    @IBOutlet weak var txtCaption: UITextField!
    
    var selectedPhoto: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationButtons()
        imgPhoto.layer.cornerRadius=10
        imgPhoto.image=selectedPhoto
    }
    
    
    fileprivate func setupNavigationButtons() {
        
        navigationController?.navigationBar.tintColor = .black
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Share", style: .done,
                                                            target: self, action: #selector(ShareHandler))
        navigationItem.rightBarButtonItem?.tintColor = .mainAppColor
    }
    
    @IBAction func returnAction(_ sender: UITextField) {
        sender.resignFirstResponder()
    }
    
    
    fileprivate func saveToDatabaseWithImageUrl(imageUrl: String){
        guard let postImage = selectedPhoto else { return }
        guard let caption = txtCaption.text else { return }
        
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        let userPostRef = Database.database().reference().child("posts").child(uid)
        let ref = userPostRef.childByAutoId()
        
        let values = ["imageUrl": imageUrl, "caption": caption, "imageWidth": postImage.size.width, "imageHeight": postImage.size.height, "creationDate": Date().timeIntervalSince1970] as [String : Any]
        
        ref.updateChildValues(values) { (err, ref) in
            if let err = err {
                self.navigationItem.rightBarButtonItem?.isEnabled = true
                print("Failed to save post to DB", err)
                return
            }
            
            print("Successfully saved post to DB")
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    @objc func ShareHandler(){
        
        view.endEditing(true)
        
        guard let image = selectedPhoto else {return}
        guard let uploadData = image.jpegData(compressionQuality: 0.5) else {return}
        let fileName = NSUUID().uuidString
        
        self.navigationItem.rightBarButtonItem?.isEnabled = false
        
        let storageRef = Storage.storage().reference().child("posts").child(fileName)
        
        storageRef.putData(uploadData, metadata: nil) { [weak self](metaData, err) in
            if let err = err {
                DispatchQueue.main.async {
                    self?.navigationItem.rightBarButtonItem?.isEnabled = true
                }
                print("Failed to upload post image:", err)
                return
            }
            
            storageRef.downloadURL(completion: {(downloadURL, err) in
                if let err = err {
                    print("Failed to fetch downloadURL:", err)
                    return
                }
                guard let imageUrl = downloadURL?.absoluteString else { return }
                
                print("Successfully uploaded post image:", imageUrl)
                
                self?.saveToDatabaseWithImageUrl(imageUrl: imageUrl)
            })
        }
    }
}
