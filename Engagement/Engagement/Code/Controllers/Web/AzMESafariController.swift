//
//  AzMESafariController.swift
//  Engagement
//
//  Created by Microsoft on 10/02/2016.
//  Copyright © 2016 Microsoft. All rights reserved.
//

import UIKit
import SafariServices

/// Simple Overriding of the SFSafariViewController controller class, to customize UI elements
class AzMESafariController: SFSafariViewController {
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.view.tintColor = UIColor(named: UIColor.Name.primaryTheme)
    
  }
}
