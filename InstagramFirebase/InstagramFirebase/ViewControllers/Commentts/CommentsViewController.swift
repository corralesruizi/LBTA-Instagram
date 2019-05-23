import UIKit
import Firebase

class CommentsViewController: UIViewController,CommentInputAccessoryViewDelegate {
    
    var post: Post?
    var comments = [Comment]()
    var shouldRefesh = false
    
    let cellId = "cellId"
    let cellNib = UINib(nibName: "CommentsTableViewCell", bundle: nil)
    
    @IBOutlet weak var tbComments: UITableView!
    
    lazy var containerView: CommentInputAccessoryView = {
        let frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50)
        let commentInputAccessoryView = CommentInputAccessoryView(frame: frame)
        commentInputAccessoryView.delegate = self
        return commentInputAccessoryView
    }()
    
    override var inputAccessoryView: UIView? {
        get {
            return containerView
        }
    }
    
    override var canBecomeFirstResponder: Bool {
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Comments"
        SetupTableView()
        fetchComments()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        tabBarController?.tabBar.isHidden = false
    }
    
  
    
    fileprivate func fetchComments() {
        guard let postId = self.post?.id else { return }
        let ref = Database.database().reference().child("comments").child(postId)
        ref.observe(.childAdded, with: { [weak self](snapshot) in
            
            guard let dictionary = snapshot.value as? [String: Any] else { return }
            guard let uid = dictionary["uid"] as? String else { return }
            
            Database.fetchUserWithUID(uid: uid, completion: { (user) in
                let comment = Comment(user: user, dictionary: dictionary)
                self?.comments.append(comment)
                self?.tbComments.reloadData()
            })
            
        }) { (err) in
            print("Failed to observe comments")
        }
    }
    
    func didSubmit(for comment: String) {
        print("Trying to insert comment into Firebase")
        guard let uid = Auth.auth().currentUser?.uid else { return }
        guard let postId = self.post?.id else {return}
        
        print("post id:", self.post?.id ?? "")
        
        print("Inserting comment:", comment)
        let values = ["text": comment, "creationDate": Date().timeIntervalSince1970, "uid": uid] as [String : Any]
        
        Database.database().reference().child("comments").child(postId).childByAutoId().updateChildValues(values) { (err, ref) in
            
            if let err = err {
                print("Failed to insert comment:", err)
                return
            }
            
            print("Successfully inserted comment.")
            self.containerView.clearCommentTextField()
        }

    }
}

extension CommentsViewController: UITableViewDelegate,UITableViewDataSource
{
    fileprivate func SetupTableView()
    {
        tbComments.register(cellNib, forCellReuseIdentifier: cellId)
        tbComments.delegate=self
        tbComments.dataSource=self
        tbComments.rowHeight = UITableView.automaticDimension
        tbComments.estimatedRowHeight = 100
        tbComments.tableFooterView = UIView()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return comments.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! CommentsTableViewCell
        cell.comment=comments[indexPath.item]
        return cell
    }
    
}
