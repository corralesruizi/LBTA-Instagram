import UIKit
import Firebase

class HomeViewController: UIViewController {

    @IBOutlet weak var cvPosts: UICollectionView!
    
    let cellId = "cellId"
    let cellNib = UINib(nibName: "HomeFeedCollectionViewCell", bundle: nil)
    
    var posts = [Post]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupCollectionView()
        fetchPosts()
    }
    
    fileprivate func setupCollectionView()
    {
        cvPosts.register(cellNib,forCellWithReuseIdentifier:cellId)
        cvPosts.dataSource = self
        cvPosts.delegate = self
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
            
            self?.cvPosts?.reloadData()
            
        }) { (err) in
            print("Failed to fetch posts:", err)
        }
    }

}

extension HomeViewController:UICollectionViewDataSource,UICollectionViewDelegateFlowLayout
{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posts.count;
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath)
        -> UICollectionViewCell {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! HomeFeedCollectionViewCell
            cell.post = posts[indexPath.item]
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
        let dimen = UIScreen.main.bounds.width
        return CGSize(width: dimen,height: 626)
    }
}


