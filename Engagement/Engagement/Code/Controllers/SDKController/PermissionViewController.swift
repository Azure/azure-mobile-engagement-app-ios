//
//  PermissionViewController.swift
//  Engagement
//
//  Created by Microsoft on 02/03/2016.
//  Copyright © 2016 Microsoft. All rights reserved.
//

import Foundation

/// Tell the user to accept receive notifications
class PermissionViewController : UIViewController {
  
  @IBOutlet weak var ibLabel: UILabel!
  @IBOutlet weak var ibButton: AzButton!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    ibLabel.text = L10n.tr("permission.message")
    
    ibButton.titleLabel?.font = UIFont(named: UIFont.AppFont.Medium, size: 20)
    ibButton.setBackgroundImage(UIColor.imageWithColor(UIColor(named: UIColor.Name.secondaryOrange)) , for: UIControlState())
  }
  
  @IBAction func didOkButtonTap(_ sender: AnyObject) {
    
  }
  
}
