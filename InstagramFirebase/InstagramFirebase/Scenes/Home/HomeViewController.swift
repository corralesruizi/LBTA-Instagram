import UIKit
import Firebase

class HomeViewController: UIViewController,UIScrollViewDelegate,HomePostCellDelegate,HomeFeedDelegate {
   
    @IBOutlet weak var cvPosts: UICollectionView!
    
    let cellId = "cellId"
    let cellNib = UINib(nibName: "HomeFeedCollectionViewCell", bundle: nil)
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
            self.cvPosts.reloadData()
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
      homeVM.showDeviceCamera()
    }
    
    func reloadHomeFeed() {
        self.cvPosts.reloadData()
    }
    
    func didLikePost(with post: Post, at index: Int) {
        self.cvPosts?.reloadItems(at: [IndexPath(item: index, section: 0)])
    }

    func didTapComment(post: Post) {
        homeVM.goToCommentDetails(post: post)
    }
    
    func didTapLike(for cell:HomeFeedCollectionViewCell) {
//        guard let indexPath = cvPosts?.indexPath(for: cell) else { return }
//        let post = self.posts[indexPath.item]
//        homeVM.likePost(for: post, index: indexPath.item)
    }
}

extension HomeViewController:UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if let posts = homeVM.posts.value {
            return posts.count
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath)
        -> UICollectionViewCell {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! HomeFeedCollectionViewCell
            
            if let posts = homeVM.posts.value{
                cell.post = posts[indexPath.item]
            }
            
            cell.delegate=self
            return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = UIScreen.main.bounds.width
        let height = 56 + width + 44 + 74
        return CGSize(width: width,height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets.zero
    }
}


