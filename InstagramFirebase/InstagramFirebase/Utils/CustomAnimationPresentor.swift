import UIKit

class CustomAnimationPresentor: NSObject, UIViewControllerAnimatedTransitioning {
    
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
        
        let startingFrame = CGRect(x: -vwWidth, y: 0, width: vwWidth, height: vwHeight)
    
        toView.frame = startingFrame
        

        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            
            toView.frame = CGRect(x: 0, y: 0, width: vwWidth, height: vwHeight)
            fromView.frame = CGRect(x: vwWidth, y: 0, width: vwWidth, height: vwHeight)
            
        }) { (_) in
            transitionContext.completeTransition(true)
        }
    }
    
}
