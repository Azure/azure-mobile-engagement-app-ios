//
//  MenuCell.swift
//  Engagement
//
//  Created by Microsoft on 09/02/2016.
//  Copyright © 2016 Microsoft. All rights reserved.
//

import UIKit

/**
 UITableViewCell displayed into the Menu Left Screen
 */
class MenuCell: UITableViewCell {
  
  @IBOutlet weak var ibIcon: UIImageView!
  @IBOutlet weak var ibTitle: UILabel!
  @IBOutlet weak var ibExpandIndicator: UIImageView!
  
  static let identifier = "MenuCell"
  
  var menuItem: MenuItem? {
    didSet {
      if let item = menuItem {
        self.ibTitle?.text = item.title
        self.ibIcon?.image = item.icon
        
        if item.isChild == true {
          self.backgroundColor = UIColor(named: UIColor.Name.secondaryGrey)
          
        }else{
          self.backgroundColor = .white
        }
        
        if item.selectedCompletion != nil && item.isChild == false {
          self.ibExpandIndicator.isHidden = false
        } else {
          self.ibExpandIndicator.isHidden = true
        }
      }
    }
    
  }
  
  override func awakeFromNib() {
    super.awakeFromNib()
    self.layoutMargins = UIEdgeInsets.zero
    ibTitle.font = UIFont(named: UIFont.AppFont.Medium, size: 15)
  }
  
  override func setSelected(_ selected: Bool, animated: Bool) {
    if (menuItem?.isSelectable == true) {
      if selected == true {
        self.ibTitle.textColor = UIColor(named: UIColor.Name.primaryTheme)
      } else {
        self.ibTitle.textColor = UIColor(named: UIColor.Name.generalText)
        
      }
    }
    else{
      self.ibTitle.textColor = UIColor(named: UIColor.Name.generalText)
      if menuItem?.isChild == true{
        self.ibTitle.textColor = UIColor(named: UIColor.Name.secondaryText)
      }
    }
    self.ibIcon.tintColor = self.ibTitle.textColor
  }
  
  //TODO
  func toggleIndicator()
  {
    let rotationAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
    rotationAnimation.toValue = M_PI
    rotationAnimation.duration = 1.0
    
    self.ibExpandIndicator.layer.add(rotationAnimation, forKey: "rotationAnimation")
  }
  
}
