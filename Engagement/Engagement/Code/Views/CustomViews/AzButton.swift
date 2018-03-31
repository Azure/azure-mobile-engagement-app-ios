//
//  AzButton.swift
//  Engagement
//
//  Created by Microsoft on 12/02/2016.
//  Copyright © 2016 Microsoft. All rights reserved.
//

/// AzME Default Button Style
class AzButton : UIButton {
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    
    applyTheme()
  }
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    applyTheme()
  }
  
  func applyTheme() {
    self.backgroundColor = UIColor(named: UIColor.Name.primaryTheme)
    self.layer.cornerRadius = 5
    self.layer.masksToBounds = true
  }
}
