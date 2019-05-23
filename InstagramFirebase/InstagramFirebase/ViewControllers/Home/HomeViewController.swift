import UIKit
import Firebase

class HomeViewController: UIViewController,UIScrollViewDelegate,HomePostCellDelegate {
   
    

    @IBOutlet weak var cvPosts: UICollectionView!
    
    let cellId = "cellId"
    let cellNib = UINib(nibName: "HomeFeedCollectionViewCell", bundle: nil)
    
    var posts = [Post]()
    
    deinit {
        print("HomeViewController Gone")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationItems()
        setupCollectionView()
        fetchPosts()
        fetchFollowingUserIds()
    }

    fileprivate func setupNavigationItems() {
        navigationItem.titleView = UIImageView(image: #imageLiteral(resourceName: "navlogo"))
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "sendMessage"), style: .plain, target: self, action: nil)
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "cameraIcon"), style: .plain, target: self, action: #selector(ShowCamera))
    }
    
    fileprivate func setupCollectionView()
    {
        cvPosts.register(cellNib,forCellWithReuseIdentifier:cellId)
        cvPosts.dataSource = self
        cvPosts.delegate = self
    }
    
    @objc fileprivate func ShowCamera(){
        present(CamearaViewController(), animated: true, completion: nil)
    }
    
    fileprivate func fetchPosts() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        Database.fetchUserWithUID(uid: uid) { [weak self](user) in
            self?.fetchPostsWithUser(user: user)
        }
    }
    
    fileprivate func fetchPostsWithUser(user: User) {
        
        Database.fetchPostsWithUser(user: user) { [weak self](postsFromUser) in
            self?.posts.append(contentsOf: postsFromUser)
            
            self?.posts.sort(by: { (p1, p2) -> Bool in
                return p1.creationDate.compare(p2.creationDate) == .orderedDescending
            })
            
            self?.cvPosts.reloadData()
        }
    }
    
    fileprivate func fetchFollowingUserIds() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        Database.database().reference().child("following").child(uid).observeSingleEvent(of: .value, with: {[weak self] (snapshot) in
            
            guard let userIdsDictionary = snapshot.value as? [String: Any] else { return }
            
            userIdsDictionary.forEach({ (key, value) in
                Database.fetchUserWithUID(uid: key, completion: { (user) in
                    self?.fetchPostsWithUser(user: user)
                })
            })
            
        }) { (err) in
            print("Failed to fetch following user ids:", err)
        }
    }
    
    func didTapComment(post: Post) {
        navigationController?.pushViewController(CommentsViewController(), animated: true)
    }
}

extension HomeViewController:UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posts.count;
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath)
        -> UICollectionViewCell {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! HomeFeedCollectionViewCell
            cell.post = posts[indexPath.item]
            cell.delegate=self
            return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = UIScreen.main.bounds.width
        let height = 56 + width + 44 + 74
        return CGSize(width: width,height: height)
    }
}


