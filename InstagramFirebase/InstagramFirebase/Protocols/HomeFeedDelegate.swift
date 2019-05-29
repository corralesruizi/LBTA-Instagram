import Foundation
protocol HomeFeedDelegate:class {
    func reloadHomeFeed()
    func didLikePost(with post: Post, at index: Int)
}
