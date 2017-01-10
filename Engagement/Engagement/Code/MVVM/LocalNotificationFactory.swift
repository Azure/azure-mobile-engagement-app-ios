//
//  LocalNotificationFactory.swift
//  Engagement
//
//  Created by Microsoft on 18/02/2016.
//  Copyright © 2016 Microsoft. All rights reserved.
//

import Foundation

/**
 *  This factory create UILocalNotification to simulate out of app AzME SDK Notifications
 */
struct LocalNotificationFactory {
  
  static var outOfAppNotification : UILocalNotification {
    get {
      let category = UIMutableUserNotificationCategory()
      
      let shareAction = UIMutableUserNotificationAction()
      shareAction.identifier = Config.Notifications.shareIdentifier
      shareAction.isDestructive = false
      shareAction.title = Config.Notifications.shareActionTitle
      shareAction.activationMode = .foreground
      shareAction.isAuthenticationRequired = false
      
      let feedbackAction = UIMutableUserNotificationAction()
      feedbackAction.identifier = Config.Notifications.feedbackIdentifier
      feedbackAction.isDestructive = false
      feedbackAction.title = Config.Notifications.feedbackActionTitle
      feedbackAction.activationMode = .foreground
      feedbackAction.isAuthenticationRequired = false
      
      let categoryIdentifier = "category.outofapp.action"
      category.identifier = categoryIdentifier
      category.setActions([shareAction, feedbackAction], for: .minimal)
      category.setActions([shareAction, feedbackAction], for: .default)
      
      let categories = Set(arrayLiteral: category)
      let settings = UIUserNotificationSettings(types: [.alert, .sound], categories: categories)
      UIApplication.shared.registerUserNotificationSettings(settings)
      
      let notification = UILocalNotification()
      notification.userInfo = [
        AzMELocalNotification.keyNotificationType : AzMELocalNotification.DeepLink.rawValue,
        AzMELocalNotification.keyNotificationLink : Config.AzMESDK.DeepLink.recentUpdatesLink]
      
      notification.applicationIconBadgeNumber = 0
      notification.category = categoryIdentifier
      notification.alertTitle = L10n.tr("out.of.app.push.notification.content.title")
      notification.alertBody = L10n.tr("out.of.app.push.notification.content.text")
      notification.fireDate = Date().addingTimeInterval(5)
      notification.timeZone = TimeZone.current
      notification.alertAction = "Action Name"
      
      
      return notification
    }
  }
  
  static var outOfAppAnnouncementNotification : UILocalNotification {
    get {
      let category = UIMutableUserNotificationCategory()
      
      let shareAction = UIMutableUserNotificationAction()
      shareAction.identifier = Config.Notifications.shareIdentifier
      shareAction.isDestructive = false
      shareAction.title = Config.Notifications.shareActionTitle
      shareAction.activationMode = .foreground
      shareAction.isAuthenticationRequired = false
      
      let feedbackAction = UIMutableUserNotificationAction()
      feedbackAction.identifier = Config.Notifications.feedbackIdentifier
      feedbackAction.isDestructive = false
      feedbackAction.title = Config.Notifications.feedbackActionTitle
      feedbackAction.activationMode = .foreground
      feedbackAction.isAuthenticationRequired = false
      
      let categoryIdentifier = "category.outofapp.action"
      category.identifier = categoryIdentifier
      category.setActions([shareAction, feedbackAction], for: .minimal)
      category.setActions([shareAction, feedbackAction], for: .default)
      
      let categories = Set(arrayLiteral: category)
      let settings = UIUserNotificationSettings(types: [.alert, .sound], categories: categories)
      UIApplication.shared.registerUserNotificationSettings(settings)
      
      let notification = UILocalNotification()
      notification.userInfo = [
        AzMELocalNotification.keyNotificationType : AzMELocalNotification.WebAnnouncement.rawValue,
        AzMELocalNotification.keyNotificationContent : [
          "title": L10n.tr("out.of.app.push.notification.content.title"),
          "body": L10n.tr("local.rebound.content"),
          "actionButton": L10n.tr("home.recent.updates.view.all"),
          "exitButton": L10n.tr("close.button")
        ],
        AzMELocalNotification.keyNotificationLink : Config.AzMESDK.DeepLink.recentUpdatesLink
      ]
      notification.category = categoryIdentifier
      notification.applicationIconBadgeNumber = 0
      notification.alertTitle = L10n.tr("out.of.app.push.notification.content.title")
      notification.alertBody = L10n.tr("out.of.app.push.notification.content.text")
      notification.fireDate = Date().addingTimeInterval(5)
      notification.timeZone = TimeZone.current
      notification.alertAction = "Action Name"
      return notification
    }
  }
}
