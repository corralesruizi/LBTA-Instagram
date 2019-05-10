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
    
    @IBOutlet weak var imgProfile: UIImageView!
    @IBOutlet weak var lblUserName: UILabel!
    @IBOutlet weak var lblPosts: UILabel!
    @IBOutlet weak var lblFollowers: UILabel!
    @IBOutlet weak var lblFollowing: UILabel!
    
    @IBOutlet weak var btnEdit: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    fileprivate func SetupUI()
    {
        btnEdit.layer.cornerRadius=5
        btnEdit.layer.borderWidth=1
        btnEdit.layer.borderColor=UIColor.lightGray.cgColor
        
        imgProfile.layer.cornerRadius=40
    }
    
    func updateHeader()
    {
        SetupUI()
    }
}
