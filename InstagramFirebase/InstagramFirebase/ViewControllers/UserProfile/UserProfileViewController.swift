//
//  UserProfileViewController.swift
//  InstagramFirebase
//
//  Created by Developer on 5/7/19.
//  Copyright © 2019 Developer. All rights reserved.
//

import UIKit
import Firebase
import Foundation

class UserProfileViewController: UIViewController {

    @IBOutlet weak var cvUserImages: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        cvUserImages.register(HeaderCollectionViewCell.cellNib,
                              forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                              withReuseIdentifier: HeaderCollectionViewCell.cellKey)
        
        cvUserImages.register(ImageCollectionViewCell.cellNib,
                              forCellWithReuseIdentifier: ImageCollectionViewCell.cellKey)
        
        cvUserImages.dataSource = self
        cvUserImages.delegate = self
        fetchUser()
    }
    
    fileprivate func fetchUser() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        Database.database().reference().child("users").child(uid)
            .observeSingleEvent(of: .value, with: { (snapshot) in
            
            guard let dictionary = snapshot.value as? [String: Any] else { return }
            
            let username = dictionary["username"] as? String
            self.navigationItem.title = username
            
        }) { (err) in
            print("Failed to fetch user:", err)
        }
    }
}
extension UserProfileViewController:UICollectionViewDataSource,UICollectionViewDelegateFlowLayout
{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 20;
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath)
        -> UICollectionViewCell {
        return collectionView.dequeueReusableCell(withReuseIdentifier: ImageCollectionViewCell.cellKey, for: indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String,
                        at indexPath: IndexPath) -> UICollectionReusableView {
        return collectionView.dequeueReusableSupplementaryView(
            ofKind: kind, withReuseIdentifier: HeaderCollectionViewCell.cellKey, for: indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
                        referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: UIScreen.main.bounds.width, height: 400)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 100,height: 100)
    }
}
