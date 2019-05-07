//
//  HeaderCollectionViewCell.swift
//  InstagramFirebase
//
//  Created by Developer on 5/7/19.
//  Copyright © 2019 Developer. All rights reserved.
//

import UIKit

class HeaderCollectionViewCell: UICollectionViewCell {

    static var cellKey: String = "HeaderCollectionViewCell";
    static var cellNib: UINib = UINib(nibName: HeaderCollectionViewCell.cellKey, bundle: nil)
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
