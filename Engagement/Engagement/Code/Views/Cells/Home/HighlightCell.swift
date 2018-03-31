//
//  HighlightCell.swift
//  Engagement
//
//  Created by Microsoft on 11/02/2016.
//  Copyright © 2016 Microsoft. All rights reserved.
//

import UIKit

/**
 Displayed into the Home Screen, displayed Check Mark fetaures Highlights of the AzME SDK
 */
class HighlightCell: UITableViewCell {
  
  @IBOutlet weak var ibTitle: UILabel!
  @IBOutlet weak var ibImage: UIImageView!
  
  static let identifier = "HighlightCell"
  
  override func awakeFromNib() {
    super.awakeFromNib()
    
    self.backgroundColor = UIColor(named: UIColor.Name.secondaryOrange)
    
    self.ibTitle.font = UIFont(named: UIFont.AppFont.Medium, size: 14)
    self.ibImage.image = AzIcon.iconCheck(15).image(with: CGSize(width: 15, height: 15)).withRenderingMode(.alwaysTemplate)
  }
  
  func updateWith(_ title: String?){
    self.ibTitle.text = title
  }
  
}
