//
//  PollChoiceCell.swift
//  Engagement
//
//  Created by Microsoft on 22/02/2016.
//  Copyright © 2016 Microsoft. All rights reserved.
//

import UIKit

/**
 Poll Choice UI, with a radio button
 */
class PollChoiceCell: UITableViewCell {
  
  @IBOutlet weak var ibRadioImage: UIImageView!
  @IBOutlet weak var ibChoiceTitle: UILabel!
  
  static let identifier = "PollChoiceCell"
  
  //MARK: Overriding
  override func setSelected(_ selected: Bool, animated: Bool) {
    
    self.applyStyleForSelecteState(selected)
  }
  
  override func setHighlighted(_ highlighted: Bool, animated: Bool) {
    if highlighted == true{
      ibRadioImage.image = UIImage(named: "radio_button_off_pressed")
    }
    else{
      self.applyStyleForSelecteState(self.isSelected)
    }
  }
  
  /**
   Apply the correct selected style for the radio image (like a button)
   
   - parameter selected: Selected state
   */
  fileprivate func applyStyleForSelecteState(_ selected: Bool){
    if selected == true{
      ibRadioImage.image = UIImage(named: "radio_button_on")
    }
    else{
      ibRadioImage.image = UIImage(named: "radio_button_off")
    }
  }
  
  /**
   Update the poll cell choice title
   
   - parameter title: Choice title
   */
  func update(_ title: String){
    self.ibChoiceTitle.text = title
  }
}
