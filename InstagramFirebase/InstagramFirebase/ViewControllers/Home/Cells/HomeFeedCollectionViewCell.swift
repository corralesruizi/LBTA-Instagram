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
    @IBOutlet weak var lblUser: UILabel!
    @IBOutlet weak var imgUser: InstagramImageView!
    
    var post: Post? {
        didSet {
            guard let user = post?.user else { return }
            guard let postImageUrl = post?.imageUrl else { return }
            
            lblUser.text = user.username
            imgUser.layer.cornerRadius=20
            imgUser.loadImage(urlString: user.profileImageUrl)
            imgPhoto.loadImage(urlString: postImageUrl)
        }
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    @IBAction func btnMore(_ sender: UIButton) {
        print("More")
    }
    
    @IBAction func btnLike(_ sender: UIButton) {
        print("Like")
    }
    
    @IBAction func btnMessage(_ sender: UIButton) {
        print("Message")
    }
    
    @IBAction func bttnSend(_ sender: UIButton) {
        print("Send")
    }
    @IBAction func btnRibbon(_ sender: UIButton) {
        print("Ribbon")
    }
}
