//
//  AzMENotifier.swift
//  Engagement
//
//  Created by Microsoft on 16/02/2016.
//  Copyright © 2016 Microsoft. All rights reserved.
//

import Foundation

// from http://stackoverflow.com/questions/37886994/dispatch-once-in-swift-3
public extension DispatchQueue {
  
  private static var onceTracker = [String]()
  
  /**
   Executes a block of code, associated with a unique token, only once.  The code is thread safe and will
   only execute the code once even in the presence of multithreaded calls.
   
   - parameter token: A unique reverse DNS style name such as com.vectorform.<name> or a GUID
   - parameter block: Block to execute once
   */
  public class func once(token: String, block: (Void) -> Void) {
    objc_sync_enter(self); defer { objc_sync_exit(self) }
    
    if onceTracker.contains(token) {
      return
    }
    
    onceTracker.append(token)
    block()
  }
}
