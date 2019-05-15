//
//  ImageCollectionViewCell.swift
//  InstagramFirebase
//
//  Created by Developer on 5/7/19.
//  Copyright © 2019 Developer. All rights reserved.
//

import UIKit

class ImageCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imgPhoto: InstagramImageView!
    
    var post: Post?{
        didSet{
            guard let imageUrl = post?.imageUrl else { return }
            imgPhoto.loadImage(urlString: imageUrl)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
}
