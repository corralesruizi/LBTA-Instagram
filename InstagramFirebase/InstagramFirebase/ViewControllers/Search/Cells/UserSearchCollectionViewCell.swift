import UIKit

class UserSearchCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var lblUsername: UILabel!
    @IBOutlet weak var imgUser: InstagramImageView!
    
    var user: firebaseUser? {
        didSet {
            imgUser.layer.cornerRadius=20
            lblUsername.text = user?.username
            guard let profileImageUrl = user?.profileImageUrl else { return }
            imgUser.loadImage(urlString: profileImageUrl)
        }
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
