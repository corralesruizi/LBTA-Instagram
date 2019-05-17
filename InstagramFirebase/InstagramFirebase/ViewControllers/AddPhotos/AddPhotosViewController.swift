import UIKit
import Photos
import Foundation

class AddPhotosViewController: UIViewController {

    @IBOutlet weak var cvPhotos: UICollectionView!
    
    let photoHeaderId = "photoHeaderId"
    let imageCellId = "cellId"
    
    var selectedImage: UIImage?
    var images = [UIImage]()
    var assets = [PHAsset]()
  
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        cvPhotos.register(UINib(nibName: "AddPhotosHeaderView", bundle: nil),
                              forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                              withReuseIdentifier: photoHeaderId)
        
        cvPhotos.register(UINib(nibName: "ImageCollectionViewCell", bundle: nil),
                              forCellWithReuseIdentifier: "cellId")
        
        cvPhotos.dataSource = self
        cvPhotos.delegate = self
        
        setupNavigationButtons()
        fetchPhotosFromLibrary()
        
       
    }
    
    fileprivate func setupNavigationButtons() {
        
        navigationController?.navigationBar.tintColor = .black
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(handleCancel))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Next", style: .done, target: self, action: #selector(handleNext))
        navigationItem.rightBarButtonItem?.tintColor = .mainAppColor
    }
    
    fileprivate func assetsFetchOptions() -> PHFetchOptions{
        let fetchOptions = PHFetchOptions()
        let sortDescriptor = NSSortDescriptor(key: "creationDate", ascending: false)
        fetchOptions.fetchLimit = 30
        fetchOptions.sortDescriptors = [sortDescriptor]
        return fetchOptions
    }
    
    
    fileprivate func RequesteImage(asset: PHAsset,targetSize:CGSize = CGSize(width: 200, height: 200), completionHandler: @escaping (UIImage?)->Void)
    {
        let requestOptions = PHImageRequestOptions()
        requestOptions.isSynchronous=true
        
        PHImageManager.default().requestImage(for: asset, targetSize: targetSize, contentMode: .aspectFill, options:nil,
                                              resultHandler: {(result, info) in
            DispatchQueue.main.async {
                completionHandler(result)
            }
        })
    }
    
    fileprivate func fetchPhotosFromLibrary()
    {
        let allPhotos = PHAsset.fetchAssets(with: .image, options: assetsFetchOptions())
        
        DispatchQueue.global(qos: .background).async {
            allPhotos.enumerateObjects({ (asset, count, stop) in
                let imageManager = PHImageManager.default()
                let targetSize = CGSize(width: 200, height: 200)
                let options = PHImageRequestOptions()
                options.isSynchronous = true
                imageManager.requestImage(for: asset, targetSize: targetSize, contentMode: .aspectFit, options:
                    options, resultHandler: { [weak self](image, info) in
                    
                    if let image = image {
                        self?.images.append(image)
                        self?.assets.append(asset)
                        
                        if self?.selectedImage == nil {
                            self?.selectedImage = image
                        }
                    }
                    
                    if count == allPhotos.count - 1 {
                        DispatchQueue.main.async {
                            self?.cvPhotos?.reloadData()
                        }
                    }
                    
                })
                
            })
        }
    }
    
    @objc func handleNext() {
        let sharePhotoController = SharePhotoViewController()
        sharePhotoController.selectedPhoto = selectedImage
        navigationController?.pushViewController(sharePhotoController, animated: true)
    }
    
    @objc func handleCancel() {
        dismiss(animated: true, completion: nil)
    }
}

extension AddPhotosViewController:UICollectionViewDataSource,UICollectionViewDelegateFlowLayout
{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
       
        self.selectedImage = images[indexPath.item]
        self.cvPhotos?.reloadData()
        
        let indexPath = IndexPath(item: 0, section: 0)
        cvPhotos.scrollToItem(at: indexPath, at: .bottom, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath)
        -> UICollectionViewCell {
            let imagecell = collectionView.dequeueReusableCell(withReuseIdentifier: imageCellId,
                                                               for: indexPath) as! ImageCollectionViewCell
            
            imagecell.imgPhoto.image = images[indexPath.item]
            return imagecell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String,
                        at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(
            ofKind: kind, withReuseIdentifier: photoHeaderId, for: indexPath) as! AddPhotosHeaderView
        
        
        header.imgPhoto.image = selectedImage
        
        if let selectedImage = selectedImage {
            if let index = self.images.firstIndex(of: selectedImage) {
                let selectedAsset = self.assets[index]
                
                let imageManager = PHImageManager.default()
                let targetSize = CGSize(width: 600, height: 600)
                imageManager.requestImage(for: selectedAsset, targetSize: targetSize, contentMode: .default, options: nil, resultHandler: { (image, info) in
                    header.imgPhoto.image = image
                })
            }
        }
        
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
