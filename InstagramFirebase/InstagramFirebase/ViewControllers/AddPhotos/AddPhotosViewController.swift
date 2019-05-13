import UIKit
import Photos

class AddPhotosViewController: UIViewController {

    @IBOutlet weak var cvPhotos: UICollectionView!
    var images = [UIImage]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        cvPhotos.register(AddPhotosHeaderView.cellNib,
                              forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                              withReuseIdentifier: AddPhotosHeaderView.cellKey)
        
        cvPhotos.register(ImageCollectionViewCell.cellNib,
                              forCellWithReuseIdentifier: ImageCollectionViewCell.cellKey)
        
        cvPhotos.dataSource = self
        cvPhotos.delegate = self
        
        setupNavigationButtons()
        fetchPhotosFromLibrary()
    }
    
    fileprivate func setupNavigationButtons() {
        navigationController?.navigationBar.tintColor = .black
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(handleCancel))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Next", style: .plain, target: self, action: #selector(handleNext))
    }
    
    
    fileprivate func fetchPhotosFromLibrary()
    {
        let fetchOptions = PHFetchOptions()
        let sortDescriptor = NSSortDescriptor(key: "creationDate", ascending: false)
        
        fetchOptions.fetchLimit = 10
        fetchOptions.sortDescriptors = [sortDescriptor]
        
        let allPhotos = PHAsset.fetchAssets(with: .image, options: fetchOptions)
        
        allPhotos.enumerateObjects({ (asset, count, stop) in
            let imageManager = PHImageManager.default()
            let targetSize = CGSize(width: 350, height: 350)
            let options = PHImageRequestOptions()
            options.isSynchronous = true
            imageManager.requestImage(for: asset, targetSize: targetSize,contentMode: .aspectFit, options: options,
                                      resultHandler: { [weak self](image, info) in
                                        
                                        if let image = image {
                                            self?.images.append(image)
                                        }
                                        
                                        
                                        DispatchQueue.main.async {
                                            if count == allPhotos.count - 1 {
                                                self?.cvPhotos?.reloadData()
                                            }
                                        }
            })
            
        })
        
    }
    
    @objc func handleNext() {
        print("Handling next")
    }
    
    @objc func handleCancel() {
        dismiss(animated: true, completion: nil)
    }
    
}


extension AddPhotosViewController:UICollectionViewDataSource,UICollectionViewDelegateFlowLayout
{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count;
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath)
        -> UICollectionViewCell {
            let imagecell = collectionView.dequeueReusableCell(withReuseIdentifier: ImageCollectionViewCell.cellKey,
                                                               for: indexPath) as! ImageCollectionViewCell
            
            imagecell.imgPhoto.image=images[indexPath.row]
            return imagecell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String,
                        at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(
            ofKind: kind, withReuseIdentifier: AddPhotosHeaderView.cellKey, for: indexPath) as! AddPhotosHeaderView
        
        return header
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1;
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 1, left: 0, bottom: 1, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
                        referenceSizeForHeaderInSection section: Int) -> CGSize {
        let headerWidth = UIScreen.main.bounds.width
        return CGSize(width: headerWidth, height: headerWidth)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let dimen = (UIScreen.main.bounds.width-3)/4
        return CGSize(width: dimen,height: dimen)
    }
}
