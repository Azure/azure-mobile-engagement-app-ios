//
//  SuccessPollViewController.swift
//  Engagement
//
//  Created by Microsoft on 23/02/2016.
//  Copyright © 2016 Microsoft. All rights reserved.
//

import UIKit

/// SuccessPollViewController
class SuccessPollViewController: UIViewController {
  
  @IBOutlet weak var ibImageView: UIImageView!
  @IBOutlet weak var ibSuccessTitle: UILabel!
  @IBOutlet weak var ibCloseButton: AzButton!
  
  //MARK: View Life Cycle
  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.view.backgroundColor = UIColor(named: UIColor.Name.primaryThemeLight)
    
    ibSuccessTitle.text = L10n.tr("new.poll.end.message")
    ibSuccessTitle.font = UIFont(named: UIFont.AppFont.Medium, size: 18)
    ibCloseButton.setBackgroundImage(UIColor.imageWithColor(UIColor(named: UIColor.Name.secondaryPurple)), for: UIControlState())
    ibCloseButton.setTitle("Close", for: UIControlState())
    self.navigationItem.hidesBackButton = true
    self.title = L10n.tr("new.poll.title")
    // Do any additional setup after loading the view.
  }
  
  //MARK: Actions
  @IBAction func didTapCloseButton(_ sender: AnyObject) {
    self.dismiss(animated: true, completion: nil)
  }
  
}
