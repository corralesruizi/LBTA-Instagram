//
//  HomeFeedCollectionViewCell.swift
//  InstagramFirebase
//
//  Created by Developer on 5/14/19.
//  Copyright © 2019 Developer. All rights reserved.
//

import UIKit

class HomeFeedCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imgPhoto: InstagramImageView!
    
    var post: Post? {
        didSet {
            guard let postImageUrl = post?.imageUrl else { return }
            imgPhoto.loadImage(urlString: postImageUrl)
        }
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
