import UIKit

class CustomAnimationDismisser: NSObject, UIViewControllerAnimatedTransitioning {
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.25
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        let containerView = transitionContext.containerView
        
        guard let fromView = transitionContext.view(forKey: .from) else { return }
        guard let toView = transitionContext.view(forKey: .to) else { return }
        
        containerView.addSubview(toView)
        
        let vwWidth = UIScreen.main.bounds.width
        let vwHeight = UIScreen.main.bounds.height
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            
            fromView.frame = CGRect(x: -vwWidth, y: 0, width: vwWidth, height: vwHeight)
            toView.frame = CGRect(x: 0, y: 0, width: vwWidth, height: vwHeight)
            
        }) { (_) in
            transitionContext.completeTransition(true)
        }
        
    }
    
}
