//
//  VideoCell.swift
//  Engagement
//
//  Created by Microsoft on 11/02/2016.
//  Copyright © 2016 Microsoft. All rights reserved.
//

import UIKit
import AlamofireImage

/**
 UITableViewCell to represent a video model
 */
class VideoCell: UITableViewCell {
  
  @IBOutlet weak var ibVideoImage: UIImageView!
  @IBOutlet weak var ibVideoTitle: UILabel!
  @IBOutlet weak var ibVideoDescription: UILabel!
  @IBOutlet weak var ibSubContentView: UIView!
  
  static let identifier = "VideoCell"
  
  //MARK: Overriding
  override func awakeFromNib()
  {
    super.awakeFromNib()
    
    ibVideoTitle.font = UIFont(named: UIFont.AppFont.Regular, size: 18)
    ibVideoTitle.textColor = UIColor(named: UIColor.Name.primaryTheme)
    
    ibVideoDescription.font = UIFont(named: UIFont.AppFont.Regular, size: 15)
    ibVideoDescription.textColor = UIColor(named: UIColor.Name.secondaryText)
    
    ibSubContentView.layer.borderWidth = 1
    ibSubContentView.layer.borderColor = UIColor(named: UIColor.Name.lightGrey).cgColor
  }
  
  override func prepareForReuse() {
    super.prepareForReuse()
    self.ibVideoImage.af_cancelImageRequest()
  }
  
  /**
   Update the video cell with specific datas
   
   - parameter title:      Video title
   - parameter subTitle:   Video description
   - parameter imageLink:  URL Image to download
   - parameter localImage: true if the URL image is in the App Assets
   */
  func updateWith(_ title: String?, subTitle: String?, imageLink: String?, localImage: Bool = false)
  {
    self.ibVideoTitle.text = title
    self.ibVideoDescription.text = subTitle
    if let imageName = imageLink, localImage == true
    {
      self.ibVideoImage.image = UIImage(named: imageName)
    }
    else if let link = imageLink, let imageURL = URL(string: link)
    {
        
        self.ibVideoImage.af_setImage(withURL: imageURL,
                                      imageTransition: UIImageView.ImageTransition.crossDissolve(0.3))
    }
  }
  
  override func setHighlighted(_ highlighted: Bool, animated: Bool) {
    super.setHighlighted(highlighted, animated: animated)
    
    if (highlighted == true)
    {
      self.ibSubContentView.backgroundColor = UIColor.lightGray
    }
    else
    {
      self.ibSubContentView.backgroundColor = UIColor.white
    }
  }
  
}
