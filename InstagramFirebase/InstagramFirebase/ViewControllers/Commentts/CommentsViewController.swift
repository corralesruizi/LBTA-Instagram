//
//  CommentsViewController.swift
//  InstagramFirebase
//
//  Created by Developer on 5/22/19.
//  Copyright © 2019 Developer. All rights reserved.
//

import UIKit

class CommentsViewController: UIViewController,CommentInputAccessoryViewDelegate {
    
    func didSubmit(for comment: String) {
        print("Submits")
    }
    
    lazy var containerView: CommentInputAccessoryView = {
        let frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50)
        let commentInputAccessoryView = CommentInputAccessoryView(frame: frame)
        commentInputAccessoryView.delegate = self
        return commentInputAccessoryView
    }()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Comments"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        tabBarController?.tabBar.isHidden = false
    }
    
    override var inputAccessoryView: UIView? {
        get {
            return containerView
        }
    }

    override var canBecomeFirstResponder: Bool {
        return true
    }
    
    @objc func handleSubmit() {
        print("Handling Submit...")
    }
}
