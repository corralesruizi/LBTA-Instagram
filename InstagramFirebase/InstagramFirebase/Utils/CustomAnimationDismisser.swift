//
//  CustomAnimationDismisser.swift
//  InstagramFirebase
//
//  Created by Brian Voong on 4/29/17.
//  Copyright © 2017 Lets Build That App. All rights reserved.
//

import UIKit

class CustomAnimationDismisser: NSObject, UIViewControllerAnimatedTransitioning {
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.25
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        //my custom transition animation code logic
        
        let containerView = transitionContext.containerView
        
        guard let fromView = transitionContext.view(forKey: .from) else { return }
        guard let toView = transitionContext.view(forKey: .to) else { return }
        
        containerView.addSubview(toView)
        
        let vwWidth = UIScreen.main.bounds.width
        let vwHeight = UIScreen.main.bounds.height
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            //animation??
            
            fromView.frame = CGRect(x: -vwWidth, y: 0, width: vwWidth, height: vwHeight)
            toView.frame = CGRect(x: 0, y: 0, width: vwWidth, height: vwHeight)
            
        }) { (_) in
            transitionContext.completeTransition(true)
        }
        
    }
    
}
