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
    
    func fetchPostsWithUser(user: firebaseUser) {
        
        Database.fetchPostsWithUser(user: user) { [weak self](postsFromUser) in
            print("Fetching posts")
            
            print("appending ")
            self?.tempPosts.append(contentsOf: postsFromUser)
            self?.tempPosts.sort(by: { (p1, p2) -> Bool in
                return p1.creationDate.compare(p2.creationDate) == .orderedDescending
            })
            
            self?.posts.value=self?.tempPosts ?? []
            self?.delegate?.reloadHomeFeed()
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
}
