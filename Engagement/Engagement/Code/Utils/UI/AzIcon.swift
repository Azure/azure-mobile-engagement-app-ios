//
//  AzIcon.swift
//  Engagement
//
//  Created by Microsoft on 10/02/2016.
//  Copyright © 2016 Microsoft. All rights reserved.
//

import Foundation
import FontAwesomeKit

/*
 Font Awesome icon class to generate dynamic images from a Font file SVG icons and targetted sizes
 */
class AzIcon: FAKIcon{
    struct const {
        static let fontName = "AzME_icons"      // Postscript Font File Name.
        static let fontFileName = "AzME_icons"
    }
    
    override class func iconFont(withSize size: CGFloat) -> UIFont {
        
        DispatchQueue.once(token: "fontIcon", block: {
            _ = UIFont.familyNames //see https://github.com/PrideChung/FontAwesomeKit/issues/97
            AzIcon.registerFont(with: Bundle(for: self).url(forResource: const.fontFileName, withExtension: "ttf"))
        })
        
        guard let font = UIFont(name: const.fontFileName, size: size) else {
            fatalError("UIFont object should not be nil, check if the font file is added to the application bundle and you're using the correct font name.")
        }
        return font
    }
    
    class func iconMenuAbout(_ size: Int = 20) -> AzIcon { return AzIcon(code: "A", size: CGFloat(size)) }
    class func iconMenuDataPush(_ size: Int = 20) -> AzIcon { return AzIcon(code: "B", size: CGFloat(size)) }
    class func iconMenuDemoAppBackend(_ size: Int = 20) -> AzIcon { return AzIcon(code: "C", size: CGFloat(size)) }
    class func iconMenuFeatures(_ size: Int = 20) -> AzIcon { return AzIcon(code: "D", size: CGFloat(size)) }
    class func iconMenuFullScreen(_ size: Int = 20) -> AzIcon { return AzIcon(code: "E", size: CGFloat(size)) }
    class func iconMenGetDeviceID(_ size: Int = 20) -> AzIcon { return AzIcon(code: "F", size: CGFloat(size)) }
    class func iconMenuHelpfulLinks(_ size: Int = 20) -> AzIcon { return AzIcon(code: "G", size: CGFloat(size)) }
    class func iconMenuHome(_ size: Int = 20) -> AzIcon { return AzIcon(code: "H", size: CGFloat(size)) }
    class func iconMenuInApp(_ size: Int = 20) -> AzIcon { return AzIcon(code: "I", size: CGFloat(size)) }
    class func iconMenuOutApp(_ size: Int = 20) -> AzIcon { return AzIcon(code: "J", size: CGFloat(size)) }
    class func iconMenuPoll(_ size: Int = 20) -> AzIcon { return AzIcon(code: "K", size: CGFloat(size)) }
    class func iconMenuPopUp(_ size: Int = 20) -> AzIcon { return AzIcon(code: "L", size: CGFloat(size)) }
    class func iconMenuRecentUpdates(_ size: Int = 20) -> AzIcon { return AzIcon(code: "M", size: CGFloat(size)) }
    class func iconMenuTwitter(_ size: Int = 20) -> AzIcon { return AzIcon(code: "N", size: CGFloat(size)) }
    class func iconMenuVideos(_ size: Int = 20) -> AzIcon { return AzIcon(code: "O", size: CGFloat(size)) }
    class func iconLogoAzme(_ size: Int = 20) -> AzIcon { return AzIcon(code: "P", size: CGFloat(size)) }
    class func iconCheck(_ size: Int = 20) -> AzIcon { return AzIcon(code: "Q", size: CGFloat(size)) }
    class func iconDocumentation(_ size: Int = 20) -> AzIcon { return AzIcon(code: "R", size: CGFloat(size)) }
    class func iconMSDNForum(_ size: Int = 20) -> AzIcon { return AzIcon(code: "S", size: CGFloat(size)) }
    class func iconPricing(_ size: Int = 20) -> AzIcon { return AzIcon(code: "T", size: CGFloat(size)) }
    class func iconSLA(_ size: Int = 20) -> AzIcon { return AzIcon(code: "U", size: CGFloat(size)) }
    class func iconUserVoiceForum(_ size: Int = 20) -> AzIcon { return AzIcon(code: "V", size: CGFloat(size)) }
    class func iconMenuArrow(_ size: Int = 20) -> AzIcon { return AzIcon(code: "W", size: CGFloat(size)) }
    class func iconMenu(_ size: Int = 20) -> AzIcon { return AzIcon(code: "X", size: CGFloat(size)) }
    class func iconClose(_ size: Int = 20) -> AzIcon { return AzIcon(code: "Y", size: CGFloat(size)) }
    
}
