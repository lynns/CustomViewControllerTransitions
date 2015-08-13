import UIKit

class CustomModalTransitioningFinal: NSObject {
  var isPresenting = false
  let animationDuration = 0.3
  let margin: CGFloat = 52
  let modalWidth: CGFloat = 615
  var presentingVC: UIViewController?
  var topConstraint: NSLayoutConstraint?
  
  var anchor: CustomModalTransitioningFinal?
  
  override init() {
    super.init()
    self.anchor = self
  }
}

extension CustomModalTransitioningFinal: UIViewControllerTransitioningDelegate {
  func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
    isPresenting = true
    return self
  }
  
  func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
    isPresenting = false
    return self
  }
}

extension CustomModalTransitioningFinal: UIViewControllerAnimatedTransitioning {
  func transitionDuration(transitionContext: UIViewControllerContextTransitioning) -> NSTimeInterval {
    return animationDuration
  }
  
  
// START 1 //
  func tapped() {
    presentingVC?.dismissViewControllerAnimated(true, completion: nil)
  }
// END 1 //
  
  
  func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
    let containerView: UIView = transitionContext.containerView();
    
    if let fromViewController = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey),
      let toViewController = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey)
    {
      if(isPresenting == true) {
        
        
      // START 2 //
        self.presentingVC = fromViewController
        
        let tapOffToDismissView = UIView()
        tapOffToDismissView.backgroundColor = UIColor.clearColor()
        tapOffToDismissView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: Selector("tapped")))
        containerView.addSubview(tapOffToDismissView)
        
        tapOffToDismissView.setTranslatesAutoresizingMaskIntoConstraints(false)
        containerView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-0-[view]-0-|", options: NSLayoutFormatOptions.allZeros, metrics: nil, views: ["view": tapOffToDismissView]))
        containerView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-0-[view]-0-|", options: NSLayoutFormatOptions.allZeros, metrics: nil, views: ["view": tapOffToDismissView]))
      // END 2 //
        
        
        containerView.addSubview(toViewController.view)
        
        toViewController.view.setTranslatesAutoresizingMaskIntoConstraints(false)
        containerView.addConstraint(NSLayoutConstraint(item: toViewController.view, attribute: .Width, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1.0, constant: modalWidth))
        containerView.addConstraint(NSLayoutConstraint(item: toViewController.view, attribute: .CenterX, relatedBy: .Equal, toItem: containerView, attribute: .CenterX, multiplier: 1.0, constant: 0))
        
        let topOffset = fromViewController.view.frame.height
        let verticalConstraints = NSLayoutConstraint.constraintsWithVisualFormat("V:|-(topOffset)-[view]-0-|", options: NSLayoutFormatOptions.allZeros, metrics: ["topOffset": topOffset], views: ["view": toViewController.view])
        containerView.addConstraints(verticalConstraints)
        topConstraint = verticalConstraints.first as? NSLayoutConstraint
        
        containerView.layoutIfNeeded()
        
        fromViewController.view.alpha = 1.0;
        
        UIView.animateWithDuration(animationDuration, delay: 0, options:UIViewAnimationOptions.CurveEaseOut, animations: { [weak self] () -> Void in
          fromViewController.view.alpha = 0.3;
          self?.topConstraint?.constant = self!.margin
          containerView.layoutIfNeeded()
          
        }, completion: { (completed) -> Void in
            transitionContext.completeTransition(completed)
        })
        
      } else {
        UIView.animateWithDuration(animationDuration, delay: 0, options:UIViewAnimationOptions.CurveEaseOut, animations: { [weak self] () -> Void in
          toViewController.view.alpha = 1.0;
          self?.topConstraint?.constant = toViewController.view.frame.height
          containerView.layoutIfNeeded()
          
        }, completion: { [weak self] (completed) -> Void in
          fromViewController.view.removeFromSuperview()
          transitionContext.completeTransition(completed)
          self?.presentingVC = nil
          self?.anchor = nil
        })
      }
    }
  }
}