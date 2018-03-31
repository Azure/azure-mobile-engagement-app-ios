//
//  NotifTableHeader.swift
//  Engagement
//
//  Created by Microsoft on 15/02/2016.
//  Copyright © 2016 Microsoft. All rights reserved.
//

import UIKit

/*
Table Header View which didsplay the Notification's scenario description (image + text)
*/
class NotifTableHeader: UIView {
  
  @IBOutlet var ibRootView: UIView!
  @IBOutlet weak var ibMainTitle: UILabel!
  @IBOutlet weak var ibIcon: UIImageView!
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    commonInit()
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    commonInit()
  }
  
  func commonInit() {
    Bundle.main.loadNibNamed("NotifTableHeader", owner: self, options: nil)
    self.frame = self.ibRootView.frame
    self.addSubview(self.ibRootView)
    
    self.ibMainTitle.font = UIFont(named: UIFont.AppFont.Regular, size: 22)
  }
  
  /**
   Update the view with correct description elements
   
   - parameter image:     Top left image
   - parameter mainTitle: descritpion text, displayed above image
   */
  func update(_ image: UIImage?, mainTitle: String?){
    self.ibIcon.image = image?.withRenderingMode(.alwaysTemplate)
    self.ibMainTitle.text = mainTitle
  }
}
