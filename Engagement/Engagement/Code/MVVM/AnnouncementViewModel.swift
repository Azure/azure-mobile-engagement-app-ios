//
//  AnnouncementViewModel.swift
//  Engagement
//
//  Created by Microsoft on 18/02/2016.
//  Copyright © 2016 Microsoft. All rights reserved.
//

import Foundation

/**
 *  Represent an announcement ViewModel
 It offers the possibility to regroup Azure and Fake Local announcement inside one repressentation
 It can be created via an Azure Reach Announcement
 */
struct AnnouncementViewModel {
  
  var title: String?
  var actionTitle: String?
  var exitTitle: String?
  var body: String?
  var URL: Foundation.URL?
  var type = AEAnnouncementType.unknown
  
  var action: (() -> Void)?
  
  init(){}
  
  /**
   Init the ViewModel with an AEReachAnnouncement Model
   
   - parameter announcement: Azure Announcement
   
   - returns: an AnnouncementViewModel
   */
  init(fromAnnouncement announcement: AEReachAnnouncement){
    self.title = announcement.title
    self.actionTitle = announcement.actionLabel
    self.exitTitle = announcement.exitLabel
    self.body = announcement.body
    self.type = announcement.type
  }
}
