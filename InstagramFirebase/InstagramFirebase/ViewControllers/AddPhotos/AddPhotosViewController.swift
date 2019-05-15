import UIKit
import Photos
import Foundation

class AddPhotosViewController: UIViewController {

    @IBOutlet weak var cvPhotos: UICollectionView!
    let photoHeaderId = "photoHeaderId"
    let imageCellId = "cellId"
    var photosFromLibrary: PHFetchResult<PHAsset>?
    var selectedPhoto: UIImage?
  
    
    deinit {
        print("AddPhotosViewController Gone")
    }
    
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
        DispatchQueue.global(qos: .background).async {[weak self] in
            self?.photosFromLibrary = PHAsset.fetchAssets(with: .image, options: self?.assetsFetchOptions())
            
            guard let photos = self?.photosFromLibrary else {return}
            self?.RequesteImage(asset: photos[0],targetSize: CGSize(width: 600, height: 600)) { [weak self](image) in
                self?.selectedPhoto = image
                self?.cvPhotos.reloadData()
            }
        }
    }
    
    @objc func handleNext() {
        let sharePhotoController = SharePhotoViewController()
        sharePhotoController.selectedPhoto = selectedPhoto
        navigationController?.pushViewController(sharePhotoController, animated: true)
    }
    
    @objc func handleCancel() {
        dismiss(animated: true, completion: nil)
    }
    
}

extension AddPhotosViewController:UICollectionViewDataSource,UICollectionViewDelegateFlowLayout
{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photosFromLibrary?.count ?? 0;
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
       
        guard let photos = photosFromLibrary else { return }
        RequesteImage(asset: photos[indexPath.item],targetSize: CGSize(width: 600, height: 600)) {[weak self](assetImage) in
            self?.selectedPhoto=assetImage
            self?.cvPhotos.reloadData()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath)
        -> UICollectionViewCell {
            let imagecell = collectionView.dequeueReusableCell(withReuseIdentifier: imageCellId,
                                                               for: indexPath) as! ImageCollectionViewCell
            guard let photos = photosFromLibrary else {
                return imagecell
            }
            
            let dimen = (UIScreen.main.bounds.width-3)/4
            RequesteImage(asset: photos[indexPath.item],targetSize: CGSize(width: dimen, height: dimen)) {(assetImage) in
                imagecell.imgPhoto.image=assetImage
            }
            return imagecell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String,
                        at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(
            ofKind: kind, withReuseIdentifier: photoHeaderId, for: indexPath) as! AddPhotosHeaderView
        
        
        
        header.imgPhoto.image=selectedPhoto
        
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
