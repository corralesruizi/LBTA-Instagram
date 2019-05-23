import UIKit

class CommentsTableViewCell: UITableViewCell {

    @IBOutlet weak var imgProfile: InstagramImageView!
    @IBOutlet weak var lblComment: UILabel!
    
    var comment: Comment? {
        didSet {
            guard let comment = comment else { return }
            
            let attributedText = NSMutableAttributedString(string: comment.user.username, attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 14)])
            
            attributedText.append(NSAttributedString(string: " " + comment.text, attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14)]))
            
            lblComment.attributedText = attributedText
            imgProfile.loadImage(urlString: comment.user.profileImageUrl)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    
    }
    
}
