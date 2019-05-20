import UIKit
import Firebase

class HeaderCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var imgProfile: InstagramImageView!
    @IBOutlet weak var lblUserName: UILabel!
    @IBOutlet weak var lblPosts: UILabel!
    @IBOutlet weak var lblFollowers: UILabel!
    @IBOutlet weak var lblFollowing: UILabel!
    @IBOutlet weak var btnEdit: UIButton!
    
    var user: User?{
        didSet{
            
            guard let profileImageUrl = user?.profileImageUrl else { return }
            imgProfile.loadImage(urlString: profileImageUrl)
            lblUserName.text = user?.username
            SetupUI()
            setupEditFollowButton()
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
    
    fileprivate func setupFollowStyle()
    {
        btnEdit.setTitle("Follow", for: .normal)
        btnEdit.backgroundColor = .mainAppColor
        btnEdit.setTitleColor(.white, for: .normal)
        btnEdit.layer.borderColor = UIColor(white: 0, alpha: 0.2).cgColor
    }
    
    fileprivate func setupUnfollowStyle()
    {
        btnEdit.setTitle("Unfollow", for: .normal)
        btnEdit.backgroundColor = .white
        btnEdit.setTitleColor(.black, for: .normal)
        btnEdit.layer.borderColor = UIColor(white: 0, alpha: 0.2).cgColor
    }
    
    
    fileprivate func setupEditFollowButton() {
        guard let currentLoggedInUserId = Auth.auth().currentUser?.uid else { return }
        guard let userId = user?.uid else { return }
        
        if currentLoggedInUserId == userId {
            //edit profile
        } else {
            Database.database().reference().child("following").child(currentLoggedInUserId).child(userId)
                .observeSingleEvent(of: .value, with: { [weak self](snapshot) in
                
                if let isFollowing = snapshot.value as? Int, isFollowing == 1 {
                    
                    self?.btnEdit.setTitle("Unfollow", for: .normal)
                    
                } else {
                    self?.setupFollowStyle()
                }
                
            }, withCancel: { (err) in
                print("Failed to check if following:", err)
            })
        }
    }
    
    @IBAction func EditAction(_ sender: UIButton) {
        
        print("Execute edit profile / follow / unfollow logic...")
        guard let currentLoggedInUserId = Auth.auth().currentUser?.uid else { return }
        guard let userId = user?.uid else { return }
        
        if btnEdit.titleLabel?.text == "Unfollow" {
            //unfollowing
            Database.database().reference().child("following").child(currentLoggedInUserId).child(userId)
                .removeValue(completionBlock: { [weak self](err, ref) in
                    
                if let err = err {
                    print("Failed to unfollow user:", err)
                    return
                }
                
                print("Successfully unfollowed user:", self?.user?.username ?? "")
                self?.setupFollowStyle()
            })
        }else {
            let ref = Database.database().reference().child("following").child(currentLoggedInUserId)
            let values = [userId: 1]
            
            ref.updateChildValues(values) { [weak self] (err, ref) in
                if let err = err {
                    print("Failed to follow user:", err)
                    return
                }
                print("Successfully followed user: ", self?.user?.username ?? "")
                self?.setupUnfollowStyle()
            }
        }
        
    }
    
}
