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
    
    var post: Post? {
        didSet {
            
            guard let postImageUrl = post?.imageUrl else { return }
            guard let username = post?.user.username else { return }
            guard let caption = post?.caption else { return }
            
            imgPhoto.loadImage(urlString: postImageUrl)
            lblUser.text = username+caption
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
