//
//  UIKit+Extensions.swift
//  Engagement
//
//  Created by Microsoft on 10/02/2016.
//  Copyright © 2016 Microsoft. All rights reserved.
//

import Foundation
import MMDrawerController

//MARK: UIApplication
extension UIApplication{
  static func showHUD(){
    UIApplication.shared.isNetworkActivityIndicatorVisible = true
  }
  static func dismissHUD(){
    UIApplication.shared.isNetworkActivityIndicatorVisible = false
  }
  
  static func setStatusBarStyle(_ style: UIStatusBarStyle, animated: Bool = false){
    UIApplication.shared.setStatusBarStyle(style, animated: animated)
  }
  
  static func checkStatusBarForDrawer(_ drawer: MMDrawerController?){
    if let drawer = drawer {
      if drawer.openSide == .left{
        UIApplication.setStatusBarStyle(.default)
      }else{
        UIApplication.setStatusBarStyle(.lightContent)
      }
    }
  }
}

//MARK: UIAlertController
extension UIAlertController{
  static func alertControllerPreventNotification(_ completion : @escaping () -> Void) -> UIAlertController {
    let alertController = UIAlertController(title: "A notification is going to be sent",
      message: "The out-of-app can't appear in the notification center if you are still in the application. Please press OK on this popup and then press the home button on your phone.",
      preferredStyle: UIAlertControllerStyle.alert)
    let okAction = UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: {
      action in
      
      completion()
      
    })
    alertController.addAction(okAction)
    
    return alertController
  }
}

//MARK: UIViewController
extension UIViewController{
  func closeDrawer () {
    self.mm_drawerController.closeDrawer(animated: true,
      completion: { [weak self] completed in
        UIApplication.checkStatusBarForDrawer(self?.mm_drawerController)
      })
  }
}

//MARK: UITableView
extension UITableView {
  //set the tableHeaderView so that the required height can be determined, update the header's frame and set it again
  func setAndLayoutTableFooterView(_ footer: UIView) {
    self.tableFooterView = footer
    footer.setNeedsLayout()
    footer.layoutIfNeeded()
    let height = footer.systemLayoutSizeFitting(UILayoutFittingCompressedSize).height
    var frame = footer.frame
    frame.size.height = height
    footer.frame = frame
    self.tableFooterView = footer
  }
  
  func layoutTableFooterView() {
    if let footer = self.tableFooterView{
      let height = footer.systemLayoutSizeFitting(UILayoutFittingCompressedSize).height
      var frame = footer.frame
      frame.size.height = height
      footer.frame = frame
      self.tableFooterView = footer
    }
  }
  
  func setAndLayoutTableHeaderView(_ header: UIView) {
    self.tableHeaderView = header
    header.setNeedsLayout()
    header.layoutIfNeeded()
    let height = header.systemLayoutSizeFitting(UILayoutFittingCompressedSize).height
    var frame = header.frame
    frame.size.height = height
    header.frame = frame
    self.tableHeaderView = header
  }
  
  func layoutTableHeaderView() {
    if let header = self.tableHeaderView{
      let height = header.systemLayoutSizeFitting(UILayoutFittingCompressedSize).height
      var frame = header.frame
      frame.size.height = height
      header.frame = frame
      self.tableHeaderView = header
    }
  }
}
