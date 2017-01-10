//
//  SimpleHeaderLabel.swift
//  Engagement
//
//  Created by Microsoft on 23/02/2016.
//  Copyright © 2016 Microsoft. All rights reserved.
//

import Foundation

/**
 Header View type to differenciate implementation but with the same layout but different confihuration.
 Particularly, there is different superview margins
 
 - TableHeader:   For Table View Headers
 - SectionHeader: For Section View headers
 */
enum HeaderViewType{
  case tableHeader, sectionHeader
  
  func marginProperties() -> UIEdgeInsets{
    switch self{
    case .tableHeader:
      return  UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    case .sectionHeader:
      return UIEdgeInsets(top: 20, left: 10, bottom: 10, right: 10)
    }
  }
}

/// View with an embeded label with superview inset margins
class SimpleHeaderLabel: UIView{
  
  @IBOutlet weak var ibTopMargin: NSLayoutConstraint!
  @IBOutlet weak var ibBottomMargin: NSLayoutConstraint!
  @IBOutlet weak var ibLeftMargin: NSLayoutConstraint!
  @IBOutlet weak var ibRightMargin: NSLayoutConstraint!
  
  @IBOutlet weak var ibTitle: UILabel!
  @IBOutlet var ibRootView: UIView!
  
  //MARK: Initializations
  override init(frame: CGRect) {
    super.init(frame: frame)
    commonInit()
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    commonInit()
  }
  
  func commonInit() {
    Bundle.main.loadNibNamed("SimpleHeaderLabel", owner: self, options: nil)
    self.frame = self.ibRootView.frame
    self.addSubview(self.ibRootView)
  }
  
  fileprivate func updateType(_ headerType: HeaderViewType){
    self.ibTopMargin.constant = headerType.marginProperties().top
    self.ibBottomMargin.constant = headerType.marginProperties().bottom
    self.ibLeftMargin.constant = headerType.marginProperties().left
    self.ibRightMargin.constant = headerType.marginProperties().right
  }
  
  /**
   Update the view with text description and style
   
   - parameter font:       Label font
   - parameter mainTitle:  Label title
   - parameter headerType: Section type configuration
   */
  func update(_ font: UIFont?, mainTitle: String?, headerType: HeaderViewType){
    self.ibTitle.font = font
    self.ibTitle.text = mainTitle
    self.updateType(headerType)
  }
  
  func updateAttributed(_ title: NSAttributedString, headerType: HeaderViewType){
    self.ibTitle.attributedText = title
    self.updateType(headerType)
  }
  
  /**
   Compute and return the estimated header view height embeded in a specific view width
   
   - parameter font:        The Label font that will be set to the header
   - parameter forTitle:    The texte title that will be set to the header embeded label
   - parameter insideWidth: The parent container view width inside the header will be displayed
   - parameter headerType:  HeaderType configuration
   
   - returns: The estimated height of the header (CGFloat)
   */
  static func headerHeight(_ font: UIFont, forTitle: String, insideWidth: CGFloat, headerType: HeaderViewType) -> CGFloat
  {
    let size = CGSize(width: insideWidth - headerType.marginProperties().left - headerType.marginProperties().right,
      height: CGFloat.infinity)
    let computedTitleRect = forTitle.boundingRect(with: size,
      options: .usesLineFragmentOrigin,
      attributes: [NSFontAttributeName : font],
      context: nil)
    return computedTitleRect.height + headerType.marginProperties().top + headerType.marginProperties().bottom + 5
  }
}
