//
//  UIFont.swift
//  Engagement
//
//  Created by Microsoft on 11/02/2016.
//  Copyright © 2016 Microsoft. All rights reserved.
//

import UIKit

extension UIFont {
    enum AppFont : String {
        case Black        = "SanFranciscoDisplay-Black"
        case Ultralight   = "SanFranciscoDisplay-Ultralight"
        case Regular      = "SanFranciscoDisplay-Regular"
        case Semibold     = "SanFranciscoDisplay-Semibold"
        case Heavy        = "SanFranciscoDisplay-Heavy"
        case Light        = "SanFranciscoDisplay-Light"
        case Medium       = "SanFranciscoDisplay-Medium"
        case Bold         = "SanFranciscoDisplay-Bold"
        case Thin         = "SanFranciscoDisplay-Thin"
        case Italic       = "SFUIText-MediumItalic"
    }
    
    /**
     Create an return a desired default App Font
     
     - parameter name: The AppFont enum font name
     - parameter size: desired size of your string
     
     - returns: Custom UIFont
     */
    convenience init(named name: AppFont, size:CGFloat) {
        self.init(name:name.rawValue, size:size)!
    }
}
