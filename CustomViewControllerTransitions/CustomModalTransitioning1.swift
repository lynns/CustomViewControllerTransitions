

import UIKit

class CustomModalTransitioning1: NSObject {
  var isPresenting = false
  let animationDuration = 0.3
  var anchor: CustomModalTransitioning1?
  
  override init() {
    super.init()
    self.anchor = self
  }
}

extension CustomModalTransitioning1: UIViewControllerTransitioningDelegate {
  func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
    isPresenting = true
    return self
  }
  
  func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
    isPresenting = false
    return self
  }
}

extension CustomModalTransitioning1: UIViewControllerAnimatedTransitioning {
  func transitionDuration(transitionContext: UIViewControllerContextTransitioning) -> NSTimeInterval {
    return animationDuration
  }
  
  func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
    let containerView: UIView = transitionContext.containerView();
    
    if let fromViewController = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey),
       let toViewController = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey)
    {
      if(isPresenting) {
        containerView.addSubview(toViewController.view)

        fromViewController.view.alpha = 1.0;
        toViewController.view.alpha = 0;
        
        toViewController.view.frame = CGRectMake(50, 50, 668, 668)
        
        UIView.animateWithDuration(animationDuration, delay: 0, options:UIViewAnimationOptions.CurveEaseOut, animations: { [weak self] () -> Void in
          toViewController.view.alpha = 1.0;
          fromViewController.view.alpha = 0.3;
          
        }, completion: { (completed) -> Void in
          transitionContext.completeTransition(completed)
        })
        
//        toViewController.view.clipsToBounds = true
//        toViewController.view.layer.cornerRadius = 10
        
      } else {
        UIView.animateWithDuration(animationDuration, delay: 0, options:UIViewAnimationOptions.CurveEaseOut, animations: { [weak self] () -> Void in
          toViewController.view.alpha = 1.0;
          fromViewController.view.alpha = 0;
          
        }, completion: { [weak self] (completed) -> Void in
          fromViewController.view.removeFromSuperview()
          transitionContext.completeTransition(completed)
          self?.anchor = nil
        })
      }
    }
  }
}