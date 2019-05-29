import Foundation
import Firebase

class HomeViewModel{
    
    weak var delegate: HomeFeedDelegate?
    var posts: Observable<[Post]> = Observable<[Post]>([Post]())
    var tempPosts = [Post]()
 
    func fetchPosts() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        Database.fetchUserWithUID(uid: uid) { [weak self](user) in
            self?.fetchPostsWithUser(user: user)
        }
    }
    
//    func fetchPostsWithUser(user: firebaseUser) {
//
//        Database.fetchPostsWithUser(user: user) { [weak self](postsFromUser) in
//            print("Fetching posts")
//
//            print("appending ")
//            self?.tempPosts.append(contentsOf: postsFromUser)
//            self?.tempPosts.sort(by: { (p1, p2) -> Bool in
//                return p1.creationDate.compare(p2.creationDate) == .orderedDescending
//            })
//
//            self?.posts.value=self?.tempPosts ?? []
//            self?.delegate?.reloadHomeFeed()
//        }
//    }
    
    
    fileprivate func fetchPostsWithUser(user: firebaseUser) {
        let ref = Database.database().reference().child("posts").child(user.uid)
        ref.observeSingleEvent(of: .value, with: {[weak self] (snapshot) in
            
            guard let dictionaries = snapshot.value as? [String: Any] else { return }
            
            dictionaries.forEach({ (key, value) in
                guard let dictionary = value as? [String: Any] else { return }
                
                var post = Post(user: user, dictionary: dictionary)
                post.id = key
                
                guard let uid = Auth.auth().currentUser?.uid else { return }
                Database.database().reference().child("likes").child(key).child(uid).observeSingleEvent(of: .value, with: { (snapshot) in
        
                    if let value = snapshot.value as? Int, value == 1 {
                        post.hasLiked = true
                    } else {
                        post.hasLiked = false
                    }
                    
                    self?.tempPosts.append(post)
                    self?.tempPosts.sort(by: { (p1, p2) -> Bool in
                        return p1.creationDate.compare(p2.creationDate) == .orderedDescending
                    })
                    self?.posts.value=self?.tempPosts ?? []
                    self?.delegate?.reloadHomeFeed()
                    
                }, withCancel: { (err) in
                    print("Failed to fetch like info for post:", err)
                })
            })
            
        }) { (err) in
            print("Failed to fetch posts:", err)
        }
    }
    
    func fetchFollowingUserIds() {
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
    
    
    
    func likePost(for post:Post, index: Int) {
        
        guard let uid = Auth.auth().currentUser?.uid else { return }
        guard let postId = post.id else { return }
        let values = [uid: post.hasLiked == true ? 0 : 1]
        
        Database.database().reference().child("likes").child(postId).updateChildValues(values) {[weak self] (err, _) in
            
            if let err = err {
                print("Failed to like post:", err)
                return
            }
            
            print("Successfully liked post.")
            self?.delegate?.didLikePost(with: post, at: index)
        }
    }
}
