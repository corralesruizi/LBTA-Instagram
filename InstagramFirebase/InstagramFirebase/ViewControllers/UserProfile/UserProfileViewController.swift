import UIKit
import Firebase
import Foundation

class UserProfileViewController: UIViewController {

    @IBOutlet weak var cvUserImages: UICollectionView!
    
    let cellId="cellId"
    let headerId="headerId"
    let headerNib = UINib(nibName: "HeaderCollectionViewCell", bundle: nil)
    let cellNib = UINib(nibName: "ImageCollectionViewCell", bundle: nil)
    var user: User?
    var posts = [Post]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("UserProfileViewController viewDidLoad")
        cvUserImages.register(headerNib,
                              forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                              withReuseIdentifier: headerId)
        
        cvUserImages.register(cellNib,forCellWithReuseIdentifier: cellId)
        
        cvUserImages.dataSource = self
        cvUserImages.delegate = self
        fetchUser()
        fetchPosts()
        //fetchOrderedPosts()
        setupLogoutButton()
    }
    
    fileprivate func setupLogoutButton()
    {
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "gear"), style: .plain, target: self, action: #selector(LogoutHandle))
    }
    
    @objc func LogoutHandle()
    {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        alertController.addAction(UIAlertAction(title: "Log Out", style: .destructive, handler: { [weak self] (_) in
            
            do {
                try Auth.auth().signOut()
                
                let loginController = LoginViewController()
                let navController = UINavigationController(rootViewController: loginController)
                self?.present(navController, animated: true, completion: nil)
                
            } catch let signOutErr {
                AlertView.showAlert(view: self, title: "", message: "An Error has occured: \(signOutErr)")
            }
        }))
        
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(alertController, animated: true, completion: nil)
    }
    
    fileprivate func fetchUser() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        Database.database().reference().child("users").child(uid).observeSingleEvent(of: .value, with: { [weak self] (snapshot) in
            print(snapshot.value ?? "")
            
            guard let dictionary = snapshot.value as? [String: Any] else { return }
            
            self?.user = User(dictionary: dictionary)
            self?.navigationItem.title = self?.user?.username
            
            if let header = self?.cvUserImages.supplementaryView(forElementKind: UICollectionView.elementKindSectionHeader, at: IndexPath(item: 0, section:0)) as? HeaderCollectionViewCell {
                header.user = self?.user
            }
            
        }) { (err) in
            print("Failed to fetch user:", err)
        }
    }
    
    fileprivate func fetchPosts(){
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        let ref = Database.database().reference().child("posts").child(uid)
        ref.observeSingleEvent(of: .value, with: { [weak self](snapshot) in
            
            guard let dictionaries = snapshot.value as? [String: Any] else { return }
            
            dictionaries.forEach({ (key, value) in
                
                guard let dictionary = value as? [String: Any] else { return }
                
                let post = Post(dictionary: dictionary)
                self?.posts.append(post)
            })
            
            self?.cvUserImages?.reloadData()
            
        }) { (err) in
            print("Failed to fetch posts:", err)
        }

    }
    
    fileprivate func fetchOrderedPosts() {
        print("fetch ordered post Called")
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let ref = Database.database().reference().child("posts").child(uid)
        //perhaps later on we'll implement some pagination of data
        ref.queryOrdered(byChild: "creationDate").observe(.childAdded, with: { [weak self](snapshot) in
            guard let dictionary = snapshot.value as? [String: Any] else { return }
            
            let post = Post(dictionary: dictionary)
            self?.posts.append(post)
            self?.cvUserImages.reloadData()
            print("Psot was added")
            
        }) { (err) in
            print("Failed to fetch ordered posts:", err)
        }
    }
}

extension UserProfileViewController:UICollectionViewDataSource,UICollectionViewDelegateFlowLayout
{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posts.count;
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath)
        -> UICollectionViewCell {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! ImageCollectionViewCell
            cell.post = posts[indexPath.item]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String,
                        at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(
            ofKind: kind, withReuseIdentifier: headerId, for: indexPath) as! HeaderCollectionViewCell
        header.user=user
        return header
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1;
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
                        referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: UIScreen.main.bounds.width, height: 190)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let dimen = (UIScreen.main.bounds.width-2)/3
        return CGSize(width: dimen,height: dimen)
    }
}
