//
//  File.swift
//  InstagramFirebase
//
//  Created by Developer on 5/10/19.
//  Copyright © 2019 Developer. All rights reserved.
//

import Foundation
import UIKit

class AlertView:NSObject
{
    class func showAlert(view: UIViewController ,title:String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        
        DispatchQueue.main.async {
            view.present(alert, animated: true, completion: nil)
        }
    }
}
