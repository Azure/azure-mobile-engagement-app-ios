//
//  CenterViewController.swift
//  Engagement
//
//  Created by Microsoft on 10/02/2016.
//  Copyright © 2016 Microsoft. All rights reserved.
//

import UIKit
// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}

// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func <= <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l <= r
  default:
    return !(rhs < lhs)
  }
}


class CenterViewController: EngagementViewController {
  
  override func viewDidLoad() {
    super.viewDidLoad()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
    if self.navigationController?.viewControllers.count <= 1
    {
      self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: AzIcon.iconMenu(18).image(with: CGSize(width: 18, height: 18)),
        style: .plain,
        target: self,
        action: #selector(CenterViewController.toggleDrawer))
    }
  }
  
  func toggleDrawer(){
    self.mm_drawerController.toggle(.left, animated: true) { [weak self] (finished) -> Void in
      if self?.mm_drawerController.openSide == .left{
        UIApplication.setStatusBarStyle(.default)
      }else{
        UIApplication.setStatusBarStyle(.lightContent)
      }
    }
  }
}
