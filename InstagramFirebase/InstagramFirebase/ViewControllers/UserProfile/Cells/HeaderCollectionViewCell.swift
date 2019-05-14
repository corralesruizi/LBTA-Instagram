import UIKit

class HeaderCollectionViewCell: UICollectionViewCell {

    static var cellKey: String = "HeaderCollectionViewCell";
    static var cellNib: UINib = UINib(nibName: HeaderCollectionViewCell.cellKey, bundle: nil)
    
    @IBOutlet weak var imgProfile: InstagramImageView!
    @IBOutlet weak var lblUserName: UILabel!
    @IBOutlet weak var lblPosts: UILabel!
    @IBOutlet weak var lblFollowers: UILabel!
    @IBOutlet weak var lblFollowing: UILabel!
    @IBOutlet weak var btnEdit: UIButton!
    
    var user: User?{
        didSet{
            SetupUI()
            guard let profileImageUrl = user?.profileImageUrl else { return }
            imgProfile.loadImage(urlString: profileImageUrl)
            lblUserName.text = user?.username
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    fileprivate func SetupUI()
    {
        btnEdit.layer.cornerRadius=5
        btnEdit.layer.borderWidth=1
        btnEdit.layer.borderColor=UIColor.lightGray.cgColor
        
        lblPosts.attributedText = AddTextAttributes(numberOfItems: "0", itemName: "posts")
        lblFollowers.attributedText = AddTextAttributes(numberOfItems: "0", itemName: "followers")
        lblFollowing.attributedText = AddTextAttributes(numberOfItems: "0", itemName: "following")
        
        imgProfile.layer.cornerRadius=40
    }
    
  
    fileprivate func AddTextAttributes(numberOfItems: String, itemName: String) -> NSMutableAttributedString{
        let attributedText = NSMutableAttributedString(string: "\(numberOfItems)\n", attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 14)])
        attributedText.append(NSAttributedString(string: itemName, attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14)]))
        
        return attributedText
    }
}
