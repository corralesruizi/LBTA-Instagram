import UIKit

class AddPhotosHeaderView: UICollectionViewCell {

    static var cellKey: String = "AddPhotosHeaderView";
    static var cellNib: UINib = UINib(nibName: AddPhotosHeaderView.cellKey, bundle: nil)
    
    @IBOutlet weak var imgPhoto: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
}
