//
//  Colors.swift
//  Engagement
//
//  Created by Microsoft on 08/02/2016.
//  Copyright © 2016 Microsoft. All rights reserved.
//

import Foundation

extension UIColor {
  convenience init(rgbaValue: UInt32) {
    let red   = CGFloat((rgbaValue >> 24) & 0xff) / 255.0
    let green = CGFloat((rgbaValue >> 16) & 0xff) / 255.0
    let blue  = CGFloat((rgbaValue >>  8) & 0xff) / 255.0
    let alpha = CGFloat((rgbaValue      ) & 0xff) / 255.0
    
    self.init(red: red, green: green, blue: blue, alpha: alpha)
  }
}

extension UIColor {
  
  convenience init(named name: Name) {
    self.init(rgbaValue: name.rawValue)
  }
  
  enum Name: UInt32 {
    case primaryTheme       = 0x00abecff// #00abec
    case primaryThemeLight  = 0x33bcf0ff// #33bcf0
    case primaryThemeDark   = 0x0089bdff// #0089bd
    case primaryText        = 0xffffffff// #ffffff
    case primaryTextPressed = 0xedededff// #ededed
    case generalText        = 0x303030ff// #303030
    case secondaryText      = 0x6a6a6aff// #6a6a6a
    case smallMentions      = 0xa9a9a9ff// #a9a9a9
    case secondaryOrange    = 0xff8c00ff// #f8c00
    case secondaryPurple    = 0x68217aff// #68217a
    case secondaryGrey      = 0xf6f6f6ff// #f6f6f6
    case lightGrey          = 0xcacbccff// #cacbcc
    case darkGrey          = 0x9e9e9eff// #9E9E9E
  }
  
  /**
   Return an UIImage based on an UIColor
   
   - parameter color: The UIColor to based on
   - parameter size:  the desired size, 20x20 by default
   
   - returns: an UIImage based on an UIColor
   */
  static func imageWithColor(_ color: UIColor, size: CGSize = CGSize(width: 20, height: 20)) -> UIImage {
    let rect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
    UIGraphicsBeginImageContextWithOptions(size, false, 0)
    color.setFill()
    UIRectFill(rect)
    let image: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
    UIGraphicsEndImageContext()
    return image
  }
  
}
