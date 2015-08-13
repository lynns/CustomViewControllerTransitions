import UIKit

class CustomModalTransitioningOther: NSObject {
  var isPresenting = false
  let animationDuration = 0.3
  let margin: CGFloat = 100
  let modalWidth: CGFloat = 500
  var presentingVC: UIViewController?
  var topConstraint: NSLayoutConstraint?
  var theContainer: UIView?
  var animator: UIDynamicAnimator?
  var pics = [UIView]()
  
  var anchor: CustomModalTransitioningOther?
  
  override init() {
    super.init()
    self.anchor = self
  }
}

extension CustomModalTransitioningOther: UIViewControllerTransitioningDelegate {
  func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
    isPresenting = true
    return self
  }
  
  func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
    isPresenting = false
    return self
  }
}

extension CustomModalTransitioningOther: UIViewControllerAnimatedTransitioning {
  func transitionDuration(transitionContext: UIViewControllerContextTransitioning) -> NSTimeInterval {
    return animationDuration
  }
  
  func tapped() {
    if let container = theContainer {
      container.layoutIfNeeded()
      
      let topLeft = container.bounds.origin
      let topRight = CGPointMake(container.bounds.size.width, container.bounds.origin.y)
      let bottomLeft = CGPointMake(container.bounds.origin.x, container.bounds.size.height)
      let bottomRight = CGPointMake(container.bounds.size.width, container.bounds.size.height)
      
      let dave = UIImageView(image: UIImage(named: "dave.png"))
      container.addSubview(dave)
      dave.frame = CGRectMake(container.center.x, container.center.y, 100, 100)
      container.sendSubviewToBack(dave)
      
      let bj = UIImageView(image: UIImage(named: "bj.png"))
      container.addSubview(bj)
      bj.frame = CGRectMake(container.center.x + 110, container.center.y + 110, 100, 100)
      container.sendSubviewToBack(bj)
      
      let newPics = [dave, bj]
      
      if animator == nil {
        animator = UIDynamicAnimator(referenceView: container)
      }
      
      let walls = UICollisionBehavior(items: newPics)
      walls.addBoundaryWithIdentifier("left", fromPoint: topLeft, toPoint: bottomLeft)
      walls.addBoundaryWithIdentifier("bottom", fromPoint: bottomLeft, toPoint: bottomRight)
      walls.addBoundaryWithIdentifier("right", fromPoint: bottomRight, toPoint: topRight)
      walls.addBoundaryWithIdentifier("top", fromPoint: topRight, toPoint: topLeft)
      animator?.addBehavior(walls)
      
      let behavior = UIDynamicItemBehavior(items: newPics)
      behavior.elasticity = 1.0
      behavior.allowsRotation = true
      behavior.resistance = 0
      behavior.angularResistance = 0
      behavior.addLinearVelocity(CGPointMake(-150, -200), forItem: dave)
      behavior.addAngularVelocity(1.1, forItem: dave)
      behavior.addLinearVelocity(CGPointMake(150, 150), forItem: bj)
      behavior.addAngularVelocity(-1.1, forItem: bj)
      animator?.addBehavior(behavior)
      
      pics.append(dave)
      pics.append(bj)
    }
  }
  
  func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
    let containerView: UIView = transitionContext.containerView();
    theContainer = containerView
    
    if let fromViewController = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey),
      let toViewController = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey)
    {
      if(isPresenting == true) {
        
        self.presentingVC = fromViewController
        
        let tapOffToDismissView = UIView()
        tapOffToDismissView.backgroundColor = UIColor.clearColor()
        tapOffToDismissView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: Selector("tapped")))
        containerView.addSubview(tapOffToDismissView)
        
        tapOffToDismissView.setTranslatesAutoresizingMaskIntoConstraints(false)
        containerView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-0-[view]-0-|", options: NSLayoutFormatOptions.allZeros, metrics: nil, views: ["view": tapOffToDismissView]))
        containerView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-0-[view]-0-|", options: NSLayoutFormatOptions.allZeros, metrics: nil, views: ["view": tapOffToDismissView]))
        
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
          self?.pics.map{ $0.alpha = 0 }
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