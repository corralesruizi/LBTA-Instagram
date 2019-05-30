import UIKit
protocol HomeFeedDelegate:class {
    func reloadHomeFeed()
    func didLikePost(with post: Post, at index: Int)
    func goToComments(post: Post)
    func ShowDeviceCamera()
}

extension HomeFeedDelegate where Self: UIViewController {
    
    func ShowDeviceCamera(){
        #if targetEnvironment(simulator)
        return
        #endif
        
        present(CamearaViewController(), animated: true, completion: nil)
    }
    
    func goToComments(post: Post){
        let commentVC = CommentsViewController()
        commentVC.post = post
        navigationController?.pushViewController(commentVC, animated: true)
    }
}
