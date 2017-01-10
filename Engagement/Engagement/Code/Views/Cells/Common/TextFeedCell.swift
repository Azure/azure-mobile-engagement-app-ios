//
//  TextFeedCell.swift
//  Engagement
//
//  Created by Microsoft on 10/02/2016.
//  Copyright © 2016 Microsoft. All rights reserved.
//

import UIKit

/*
UITableViewCell used by the Home and RecentUpdate screens.
Display informations about SDK news
*/
class TextFeedCell: UITableViewCell {
  
  @IBOutlet weak var ibSubTitle: UILabel!
  @IBOutlet weak var ibMainTitle: UILabel!
  @IBOutlet weak var ibFeedContentView: UIView!
  @IBOutlet weak var ibDescription: UILabel!
  
  static let identifier = "TextFeedCell"
  
  //MARK: Overriding
  override func awakeFromNib() {
    super.awakeFromNib()
    
    self.ibFeedContentView.layer.borderColor = UIColor(named: UIColor.Name.primaryTextPressed).cgColor
    self.ibFeedContentView.layer.borderWidth = 1
    
    self.ibMainTitle.font = UIFont(named: UIFont.AppFont.Medium, size: 15)
    self.ibMainTitle.textColor = UIColor(named: UIColor.Name.generalText)
    
    self.ibSubTitle.font = UIFont(named: UIFont.AppFont.Regular, size: 13)
    self.ibSubTitle.textColor = UIColor(named: UIColor.Name.smallMentions)
    
    self.ibDescription.font = UIFont(named: UIFont.AppFont.Regular, size: 15)
    self.ibDescription.textColor = UIColor(named: UIColor.Name.secondaryText)
    
    self.backgroundColor = UIColor(named: UIColor.Name.secondaryGrey)
  }
  
  override func setSelected(_ selected: Bool, animated: Bool) {
    
    if selected == true{
      self.ibFeedContentView.backgroundColor = UIColor(named: UIColor.Name.secondaryGrey)
    }else{
      self.ibFeedContentView.backgroundColor = .white
    }
  }
  
  override func setHighlighted(_ highlighted: Bool, animated: Bool) {
    if highlighted == true{
      self.ibFeedContentView.backgroundColor = UIColor(named: UIColor.Name.secondaryGrey)
    }else{
      self.ibFeedContentView.backgroundColor = .white
    }
  }
  
  /**
   Update cell content with news titles
   
   - parameter title:       The news title
   - parameter subTitle:    SubTitle (the date for instance)
   - parameter description: News description
   */
  func updateWith(_ title: String?, subTitle: String?, description: String?){
    self.ibMainTitle.text = title
    self.ibSubTitle.text  = subTitle
    self.ibDescription.text  = description
  }
  
}
