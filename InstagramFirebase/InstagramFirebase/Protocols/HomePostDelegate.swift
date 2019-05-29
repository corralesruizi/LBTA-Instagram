import Foundation
protocol HomePostCellDelegate:class {
    func didTapComment(post: Post)
    func didTapLike(for cell:HomeFeedCollectionViewCell)
}
