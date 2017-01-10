//
//  HomeDataSource.swift
//  Engagement
//
//  Created by Microsoft on 23/02/2016.
//  Copyright © 2016 Microsoft. All rights reserved.
//

import Foundation

//MARK: Data Source Structs
struct HomeSection{
  var title: String
  var titleColor: UIColor
  var bgColor: UIColor
  var buttonTitle: String
  var action: (() -> Void)?
}

/**
 *  Home Data Source structure, contains default highlited elements
 */
struct HomeDataSource {
  var highlights = [L10n.tr("home.hightlight.1"),
    L10n.tr("home.hightlight.2"),
    L10n.tr("home.hightlight.3"),
    L10n.tr("home.hightlight.4"),
    L10n.tr("home.hightlight.5"),
    L10n.tr("home.hightlight.6"),
    L10n.tr("home.hightlight.7")]
  
  let sectionHighlights = HomeSection(title: L10n.tr("home.hightlight.title"),
    titleColor: .white,
    bgColor: UIColor(named: UIColor.Name.secondaryOrange),
    buttonTitle: "",
    action: nil)
  
  var sections = [(section: HomeSection, items: [AnyObject])]()
  
  init(){
    sections.append((self.sectionHighlights, self.highlights as [AnyObject]))
  }
}
