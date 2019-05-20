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
    var userId: String?
    var isFinishedPaging = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        cvUserImages.register(headerNib,
                              forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                              withReuseIdentifier: headerId)
        
        cvUserImages.register(cellNib,forCellWithReuseIdentifier: cellId)
        cvUserImages.dataSource = self
        cvUserImages.delegate = self
        setupLogoutButton()
        fetchUser()
    }
    
    fileprivate func setupLogoutButton()
    {
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "gear"), style: .plain, target: self, action: #selector(LogoutHandle))
    }
    
    @objc func LogoutHandle(){
        
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
        
        let uid = userId ?? (Auth.auth().currentUser?.uid ?? "")
        
        Database.fetchUserWithUID(uid: uid) {[weak self] (user) in
            self?.user = user
            self?.navigationItem.title = self?.user?.username
            self?.paginatePosts()
        }
    }
    
    fileprivate func paginatePosts()
    {
        guard let user = self.user else { return }
        
        let ref = Database.database().reference().child("posts").child(user.uid)
        var query = ref.queryOrdered(byChild: "creationDate")
        
        if posts.count > 0 {
            let value = posts.last?.creationDate.timeIntervalSince1970
            query = query.queryEnding(atValue: value)
        }
        
        query.queryLimited(toLast: 4).observeSingleEvent(of: .value, with: {[weak self] (snapshot) in
            
            guard var allObjects = snapshot.children.allObjects as? [DataSnapshot] else { return }
            allObjects.reverse()
            
            if allObjects.count < 4 {
                self?.isFinishedPaging = true
            }
            
            if self?.posts.count ?? 0 > 0 && allObjects.count > 0 {
                allObjects.removeFirst()
            }
            
            allObjects.forEach({ (snapshot) in
                guard let dictionary = snapshot.value as? [String: Any] else { return }
                var post = Post(user: user, dictionary: dictionary)
                post.id = snapshot.key
                self?.posts.append(post)
            })
            
            self?.cvUserImages?.reloadData()
            
        }){ (err) in
            print("Failed to paginate for posts:", err)
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
            if indexPath.item == self.posts.count - 1 && !isFinishedPaging {
                paginatePosts()
            }
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
