//
//  ImageCollectionViewCell.swift
//  InstagramFirebase
//
//  Created by Developer on 5/7/19.
//  Copyright © 2019 Developer. All rights reserved.
//

import UIKit

class ImageCollectionViewCell: UICollectionViewCell {

    static var cellKey: String = "ImageCollectionViewCell";
    static var cellNib: UINib = UINib(nibName: ImageCollectionViewCell.cellKey, bundle: nil)
    
    @IBOutlet weak var imgPhoto: UIImageView!
    
    var post: Post?{
        didSet{
            
            guard let imageUrl = post?.imageUrl else { return }
            guard let url = URL(string: imageUrl) else { return }
            
            URLSession.shared.dataTask(with: url) { [weak self](data, response, err) in
                if let err = err {
                    print("Failed to fetch post image:", err)
                    return
                }
                
                guard let imageData = data else { return }
                let photoImage = UIImage(data: imageData)
                
                DispatchQueue.main.async {
                    self?.imgPhoto.image = photoImage
                }
                
                }.resume()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
}
