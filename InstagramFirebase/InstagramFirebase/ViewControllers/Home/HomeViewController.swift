import UIKit
import Firebase

class HomeViewController: UIViewController,UIScrollViewDelegate,HomePostCellDelegate,HomeFeedDelegate {
   
    @IBOutlet weak var cvPosts: UICollectionView!
    
    let cellId = "cellId"
    let cellNib = UINib(nibName: "HomeFeedCollectionViewCell", bundle: nil)
    var posts = [Post]()
    
    var homeVM = HomeViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationItems()
        setupCollectionView()
        BindUI()
        homeVM.fetchPosts()
        homeVM.fetchFollowingUserIds()
    }
    
    func BindUI()
    {
        homeVM.delegate=self
        
        homeVM.posts.bind {[unowned self] (observable, value) in
            self.posts = value
        }
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
        
        #if targetEnvironment(simulator)
        return
        #endif
        
        present(CamearaViewController(), animated: true, completion: nil)
    }
    
    func reloadHomeFeed() {
        self.cvPosts.reloadData()
    }

    func didTapComment(post: Post) {
        let commentVC = CommentsViewController()
        commentVC.post = post
        navigationController?.pushViewController(commentVC, animated: true)
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


