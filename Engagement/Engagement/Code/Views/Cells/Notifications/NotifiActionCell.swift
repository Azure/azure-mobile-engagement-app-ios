//
//  NotifiActionCell.swift
//  Engagement
//
//  Created by Microsoft on 15/02/2016.
//  Copyright © 2016 Microsoft. All rights reserved.
//

import UIKit

/**
 *  Notify that the embeded UIButton has been "touch up inside"
 */
protocol NotifActionDelegate: class{
  func didTapButton(_ atIndex: IndexPath?)
}

/**
 Notification UI table view cell with an embeded UIButton and text description
 */
class NotifiActionCell: UITableViewCell {
  
  @IBOutlet weak var ibActionButton: AzButton!
  @IBOutlet weak var ibDescription: UILabel!
  
  static let identifier = "NotifiActionCell"
  
  fileprivate weak var delegate: NotifActionDelegate?
  fileprivate var index: IndexPath?
  
  //MARK: Overriding
  override func awakeFromNib() {
    super.awakeFromNib()
    
    self.ibDescription.font = UIFont(named: UIFont.AppFont.Italic, size: 13)
    self.ibActionButton.titleLabel?.font = UIFont(named: UIFont.AppFont.Medium, size: 17)
  }
  
  //MARK: Actions
  @IBAction func didTapActionButton(_ sender: AnyObject) {
    self.delegate?.didTapButton(self.index)
  }
  
  /**
   Update the notification cell with content
   
   - parameter item:     The NotificationScreenItem which contain several information like texts or UI colors
   - parameter index:    The indexPath of the UITableViewCell, used by the NotifActionDelegate (could be evolved with a completion block)
   - parameter delegate: NotifActionDelegate
   */
  func update(_ item: NotificationScreenItem, index: IndexPath, delegate: NotifActionDelegate)
  {
    ibActionButton.setTitle(item.title, for: UIControlState())
    ibActionButton.setBackgroundImage(UIColor.imageWithColor(item.color) , for: UIControlState())
    ibDescription.text = item.description
    self.delegate = delegate
    self.index = index
    
  }
  
}
