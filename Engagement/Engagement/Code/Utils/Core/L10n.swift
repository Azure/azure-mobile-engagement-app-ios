//
//  L10n.swift
//  Engagement
//
//  Created by Microsoft on 08/02/2016.
//  Copyright © 2016 Microsoft. All rights reserved.
//

import Foundation

/**
 *  Retrieve localizable strings with a specific key
 */
struct L10n {
  /**
   Return the correct localizable string value via the localizable key
   
   - parameter key:  localizable key
   - parameter args: format parameters (if needed)
   
   - returns: Localizable String
   */
  static func tr(_ key: String, _ args: CVarArg...) -> String {
    let format = NSLocalizedString(key, comment: "")
    return String(format: format, arguments: args)
  }
}
