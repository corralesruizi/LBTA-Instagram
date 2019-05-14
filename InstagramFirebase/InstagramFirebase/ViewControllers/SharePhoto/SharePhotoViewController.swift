import UIKit

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
    
    @objc func ShareHandler(){
        view.endEditing(true)
        print("Shared")
    }
}
