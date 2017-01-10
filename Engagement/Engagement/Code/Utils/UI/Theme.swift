//
//  Theme.swift
//  Engagement
//
//  Created by Microsoft on 08/02/2016.
//  Copyright © 2016 Microsoft. All rights reserved.
//

import Foundation

/**
 *  Configure the UI default styles like navigation bar appearence
 */
struct Theme{
  
  /**
   Prepare the default style. The method have to be initially call from the app delegate didFinishLauching method
   */
  static func prepareThemeAppearance(){
    UIApplication.setStatusBarStyle(.lightContent)
    
    //Custom UINavigationBar Appearance
    let navAppearance = UINavigationBar.appearance()
    navAppearance.barTintColor = UIColor(named: UIColor.Name.primaryTheme)
    navAppearance.tintColor = .white
    navAppearance.titleTextAttributes = [NSForegroundColorAttributeName : UIColor.white]
    navAppearance.isTranslucent = false
    navAppearance.setBackgroundImage(UIImage(), for: .any, barMetrics: .default)
    navAppearance.shadowImage = UIImage()
  }
}
