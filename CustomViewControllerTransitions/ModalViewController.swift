//
//  ModalViewController.swift
//  CustomViewControllerTransitions
//
//  Created by Stephen Lynn on 8/13/15.
//  Copyright (c) 2015 FamilySearch. All rights reserved.
//

import UIKit

class ModalViewController: UIViewController {

  @IBAction func closePressed(sender: AnyObject) {
    self.dismissViewControllerAnimated(true, completion: nil)
  }
}
