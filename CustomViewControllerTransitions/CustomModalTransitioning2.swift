import UIKit

class CustomModalTransitioning2: NSObject {
  var isPresenting = false
  let animationDuration = 0.3
  let modalWidth: CGFloat = 615
  var topConstraint: NSLayoutConstraint?
  
  var anchor: CustomModalTransitioning2?
  
  override init() {
    super.init()
    self.anchor = self
  }
}

extension CustomModalTransitioning2: UIViewControllerTransitioningDelegate {
  func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
    isPresenting = true
    return self
  }
  
  func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
    isPresenting = false
    return self
  }
}

extension CustomModalTransitioning2: UIViewControllerAnimatedTransitioning {
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
        
      // START 1 //
        toViewController.view.setTranslatesAutoresizingMaskIntoConstraints(false)
        containerView.addConstraint(NSLayoutConstraint(item: toViewController.view, attribute: .Width, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1.0, constant: modalWidth))
        containerView.addConstraint(NSLayoutConstraint(item: toViewController.view, attribute: .CenterX, relatedBy: .Equal, toItem: containerView, attribute: .CenterX, multiplier: 1.0, constant: 0))
        
        let topOffset = fromViewController.view.frame.height
        let verticalConstraints = NSLayoutConstraint.constraintsWithVisualFormat("V:|-(topOffset)-[view]-0-|", options: NSLayoutFormatOptions.allZeros, metrics: ["topOffset": topOffset], views: ["view": toViewController.view])
        containerView.addConstraints(verticalConstraints)
        topConstraint = verticalConstraints.first as? NSLayoutConstraint
        
        containerView.layoutIfNeeded()
      // END 1 //
        
        fromViewController.view.alpha = 1.0;
        
        UIView.animateWithDuration(animationDuration, delay: 0, options:UIViewAnimationOptions.CurveEaseOut, animations: { [weak self] () -> Void in
          fromViewController.view.alpha = 0.3;
          
        // START 2 //
          self?.topConstraint?.constant = 52
          containerView.layoutIfNeeded()
        // END 2 //
          
        }, completion: { (completed) -> Void in
            transitionContext.completeTransition(completed)
        })
        
      } else {
        UIView.animateWithDuration(animationDuration, delay: 0, options:UIViewAnimationOptions.CurveEaseOut, animations: { [weak self] () -> Void in
          toViewController.view.alpha = 1.0;
          
        // START 3 //
          self?.topConstraint?.constant = toViewController.view.frame.height
          containerView.layoutIfNeeded()
        // END 3 //
          
        }, completion: { [weak self] (completed) -> Void in
          fromViewController.view.removeFromSuperview()
          transitionContext.completeTransition(completed)
          self?.anchor = nil
        })
      }
    }
  }
}