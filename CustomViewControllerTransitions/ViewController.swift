//
//  ViewController.swift
//  CustomViewControllerTransitions
//
//  Created by Stephen Lynn on 8/13/15.
//  Copyright (c) 2015 FamilySearch. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

  override func viewDidLoad() {
    super.viewDidLoad()
  }
  
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    if segue.identifier == "customSegue" {
      if let destVC = segue.destinationViewController as? UIViewController {
        setupCustomPresentation(destVC)
      }
    }
  }
  
  @IBAction func customPressed(sender: AnyObject) {
    if let destVC = self.storyboard?.instantiateViewControllerWithIdentifier("modalVC") as? UIViewController {
      setupCustomPresentation(destVC)
      self.presentViewController(destVC, animated: true, completion: nil)
    }
  }
  
  func setupCustomPresentation(toViewController: UIViewController) {
    toViewController.transitioningDelegate = CustomModalTransitioning1()
//    toViewController.transitioningDelegate = CustomModalTransitioning2()
//    toViewController.transitioningDelegate = CustomModalTransitioningFinal()
//    toViewController.transitioningDelegate = CustomModalTransitioningOther()
    
    
    
    toViewController.modalPresentationStyle = UIModalPresentationStyle.Custom
  }
  
}

