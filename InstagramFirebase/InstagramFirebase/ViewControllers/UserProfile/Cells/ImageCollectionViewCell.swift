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
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
