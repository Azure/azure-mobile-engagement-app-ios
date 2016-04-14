//
//  NotificationItem.swift
//  Engagement
//
//  Created by Microsoft on 15/02/2016.
//  Copyright © 2016 Microsoft. All rights reserved.
//

import Foundation

private let defaultImageSize = CGSize(width: 60, height: 60)

/**
 Represent a notification action item on notifications controller screens
 */
public struct NotificationScreenItem
{
  var title: String
  var description: String?
  var color: UIColor
  var action: (() -> Void)//Action when tap on the simulate button
}

/* Represent the type of a notification screen
It can have informations like localized titles or related images
*/
public enum ScreenType{
  case OutOfApp, InApp, InAppPopUp, WebAnnouncement, FullScreen, Poll, DataPush
  
  var howTitle: String?
    {
      switch (self){
      case .OutOfApp:
        return L10n.tr("how.to.send.these.notification.out.of.app.title")
      case .InApp:
        return L10n.tr("how.to.send.these.notification.in.app.title")
      case .InAppPopUp:
        return L10n.tr("how.to.send.these.notification.in.app.popup.title")
      case .WebAnnouncement:
        return L10n.tr("how.to.send.these.notification.web.announcement.title")
      case .FullScreen:
        return L10n.tr("how.to.send.these.notification.full.screen.interstitial.title")
      case .Poll:
        return L10n.tr("how.to.send.these.notification.poll.title")
      case .DataPush:
        return L10n.tr("how.to.send.these.notification.data.push.title")
      }
  }
  
  var maintTitle: String?
    {
      switch (self){
      case .OutOfApp:
        return L10n.tr("menu.out.of.app.title")
      case .InApp:
        return L10n.tr("menu.in.app.title")
      case .InAppPopUp:
        return L10n.tr("menu.in.app.pop.up.title")
      case .WebAnnouncement:
        return L10n.tr("menu.web.announcement.title")
      case .FullScreen:
        return L10n.tr("menu.full.screen.title")
      case .Poll:
        return L10n.tr("menu.poll.title")
      case .DataPush:
        return L10n.tr("menu.data.push.title")
      }
  }
  
  var message: String?
    {
      switch (self){
      case .OutOfApp:
        return L10n.tr("out.of.app.push.notifications.message")
      case .InApp:
        return L10n.tr("in.app.notifications.message")
      case .InAppPopUp:
        return L10n.tr("in.app.coupon.notification.message")
      case .WebAnnouncement:
        return L10n.tr("full.screen.interstitial.message")
      case .FullScreen:
        return L10n.tr("full.screen.interstitial.message")
      case .Poll:
        return L10n.tr("poll.message")
      case .DataPush:
        return L10n.tr("data.push.notification.message")
      }
  }
  
  var footerLabelTitle: String?{
    switch self{
    case .OutOfApp, .InApp, .InAppPopUp, .FullScreen, .Poll, .WebAnnouncement:
      return "Displays sample notification text"
    case .DataPush:
      return "Displays fictitious product on the Data push screen"
    }
  }
  
  var image: UIImage?
    {
      switch (self){
      case .OutOfApp:
        return AzIcon.iconMenuOutApp(Int(defaultImageSize.width)).imageWithSize(defaultImageSize)
      case .InApp:
        return AzIcon.iconMenuInApp(Int(defaultImageSize.width)).imageWithSize(defaultImageSize)
      case .InAppPopUp:
        return AzIcon.iconMenuPopUp(Int(defaultImageSize.width)).imageWithSize(defaultImageSize)
      case .WebAnnouncement:
        return AzIcon.iconMenuFullScreen(Int(defaultImageSize.width)).imageWithSize(defaultImageSize)
      case .FullScreen:
        return AzIcon.iconMenuFullScreen(Int(defaultImageSize.width)).imageWithSize(defaultImageSize)
      case .Poll:
        return AzIcon.iconMenuPoll(Int(defaultImageSize.width)).imageWithSize(defaultImageSize)
      case .DataPush:
        return AzIcon.iconMenuDataPush(Int(defaultImageSize.width)).imageWithSize(defaultImageSize)
      }
  }
  
  var howToRessourcePathName: String?{
    switch self
    {
    case .DataPush:
      return "data_push_notification"
    case .WebAnnouncement:
      return "web_announcement"
    case .FullScreen:
      return "full_screen_interstitial"
    case .InApp:
      return "in_app"
    case .InAppPopUp:
      return "in_app_popup"
    case .OutOfApp:
      return "out_of_app"
    case .Poll:
      return "poll"
    }
  }
}

/**
 Represent the data to display on a notification controller screen
 This simulate the AzME SDK Behavior in local / without Internet connection or withtout Azure Mobile engagement endpoints
 - note: By this way, you can easely add or remove any other NotificationScreenItem in the data source that will be display on attached screen
 */
struct NotificationScreen {
  
  var screenType: ScreenType
  var dataSource: [NotificationScreenItem]?
  var rootController: UIViewController
  
  init(rootController: UIViewController, screenType: ScreenType)
  {
    self.rootController = rootController
    self.screenType = screenType
    self.dataSource = buildDataSource()
  }
  
  /**
   Build the related notifications item an related actions to simulate AzME notification behaviors
   
   - returns: an optionnal array of NotificationItem
   */
  private func buildDataSource() -> [NotificationScreenItem]?
  {
    switch (self.screenType)
    {
    case .OutOfApp:
      let notifOnly = NotificationScreenItem(title: L10n.tr("out.of.app.push.notifications.notification.only.title"),
        description: L10n.tr("out.of.app.push.notifications.notification.only.message"),
        color: UIColor(named: UIColor.Name.SecondaryPurple),
        action: { () -> Void in
          AnalyticsMonitor.sendActivityNamed(AnalyticsMonitor.Events.OutOfAppNotifications.displayNotification, extras: nil)
          self.rootController.presentViewController(UIAlertController.alertControllerPreventNotification
            {
              UIApplication.sharedApplication().scheduleLocalNotification(LocalNotificationFactory.outOfAppNotification)
            },
            animated: true,
            completion: nil)
      })
      
      let announcement = NotificationScreenItem(title: L10n.tr("out.of.app.push.notifications.announcement.title"),
        description: L10n.tr("out.of.app.push.notifications.announcement.message"),
        color: UIColor(named: UIColor.Name.SecondaryOrange),
        action: { () -> Void in
          AnalyticsMonitor.sendActivityNamed(AnalyticsMonitor.Events.OutOfAppNotifications.displayAnnoucement, extras: nil)
          self.rootController.presentViewController(UIAlertController.alertControllerPreventNotification
            {
              UIApplication.sharedApplication().scheduleLocalNotification(LocalNotificationFactory.outOfAppAnnouncementNotification)
            },
            animated: true,
            completion: nil)
      })
      return [notifOnly, announcement]
      
    case .InApp:
      let notifOnly = NotificationScreenItem(title: L10n.tr("out.of.app.push.notifications.notification.only.title"),
        description: L10n.tr("in.app.notifications.notification.only.message"),
        color: UIColor(named: UIColor.Name.SecondaryPurple),
        action: { () -> Void in
          AnalyticsMonitor.sendActivityNamed(AnalyticsMonitor.Events.InAppNotifications.displayNotification, extras: nil)
          var announcement = AnnouncementViewModel()
          announcement.title = L10n.tr("in.app.notifications.notification.title")
          announcement.body = L10n.tr("in.app.notifications.notification.message")
          announcement.action = {
            DeepLinkHelper.canManage(NSURL(string: Config.AzMESDK.DeepLink.recentUpdatesLink)!)
          }
          DeepLinkHelper.displayLocalInAppNotification(announcement, inController: self.rootController)
      })
      
      let announcement = NotificationScreenItem(title: L10n.tr("out.of.app.push.notifications.announcement.title"),
        description: L10n.tr("in.app.notifications.announcement.message"),
        color: UIColor(named: UIColor.Name.SecondaryOrange),
        action: { () -> Void in
          AnalyticsMonitor.sendActivityNamed(AnalyticsMonitor.Events.InAppNotifications.displayAnnouncement,
            extras: nil)
          var announcement = AnnouncementViewModel()
          announcement.title = L10n.tr("in.app.notifications.notification.title")
          announcement.body = L10n.tr("in.app.notifications.notification.message")
          announcement.actionTitle = L10n.tr("home.recent.updates.view.all")
          announcement.exitTitle = L10n.tr("close.button")
          announcement.action = {
            let userInfo = [
              AzMELocalNotification.keyNotificationType : AzMELocalNotification.WebAnnouncement.rawValue,
              AzMELocalNotification.keyNotificationContent : [
                "title": L10n.tr("in.app.notifications.notification.title"),
                "body": L10n.tr("local.rebound.content"),
                "actionButton": L10n.tr("home.recent.updates.view.all"),
                "exitButton": L10n.tr("close.button")
              ],
              AzMELocalNotification.keyNotificationLink : Config.AzMESDK.DeepLink.recentUpdatesLink
            ]
            
            DeepLinkHelper.manageLocalNotification(userInfo as [NSObject : AnyObject])
            
          }
          DeepLinkHelper.displayLocalInAppNotification(announcement, inController: self.rootController)
      })
      return [notifOnly, announcement]
    case .InAppPopUp:
      let popUpNotif = NotificationScreenItem(title: L10n.tr("in.app.coupon.notification.display.title"),
        description: "",
        color: UIColor(named: UIColor.Name.SecondaryPurple),
        action: { () -> Void in
          AnalyticsMonitor.sendActivityNamed(AnalyticsMonitor.Events.InAppPopUpNotifications.displayInAppPopUp,
            extras: nil)
          let t =  L10n.tr("in.app.coupon.notification.dialog.title")
          let alertController = UIAlertController(title: t,
            message: L10n.tr("in.app.coupon.notification.dialog.description"),
            preferredStyle: UIAlertControllerStyle.Alert)
          let okAction = UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: {
            action in
            
            DeepLinkHelper.canManage(NSURL(string: Config.AzMESDK.DeepLink.productLink)!)
            
          })
          let cancel = UIAlertAction(title: L10n.tr("close.button"), style: UIAlertActionStyle.Cancel, handler: nil)
          alertController.addAction(okAction)
          alertController.addAction(cancel)
          alertController.view.tintColor = UIColor(named: UIColor.Name.PrimaryTheme)
          self.rootController.presentViewController(alertController,
            animated: true,
            completion: nil)
      })
      return [popUpNotif]
    case .WebAnnouncement:
      let fullScreenNotif = NotificationScreenItem(title: L10n.tr("web.announcement.title"),
        description: "",
        color: UIColor(named: UIColor.Name.SecondaryPurple),
        action: { () -> Void in
          AnalyticsMonitor.sendActivityNamed(AnalyticsMonitor.Events.FullScreenIntersticial.displayFulLScreenIntersticial,
            extras: nil)
          
          var announcement = AnnouncementViewModel()
          announcement.title = L10n.tr("full.screen.interstitial.dialog.announcement.title")
          announcement.body = L10n.tr("full.screen.interstitial.dialog.announcement.message")
          announcement.actionTitle = L10n.tr("home.recent.updates.view.all")
          announcement.exitTitle = L10n.tr("close.button")
          announcement.action = {
            let userInfo = [
              AzMELocalNotification.keyNotificationType : AzMELocalNotification.Fullscreen.rawValue,
              AzMELocalNotification.keyNotificationContent : [
                "title" : L10n.tr("full.screen.interstitial.dialog.announcement.title"),
                "body" : L10n.tr("full.screen.interstitial.dialog.announcement.body"),
                "actionButton" : L10n.tr("home.recent.updates.view.all"),
                "exitButton" : L10n.tr("close.button")
              ],
              AzMELocalNotification.keyNotificationLink : Config.URLs.features
            ]
            
            DeepLinkHelper.manageLocalNotification(userInfo as [NSObject : AnyObject])
            
          }
          DeepLinkHelper.displayLocalInAppNotification(announcement, inController: self.rootController)
      })
      return [fullScreenNotif]
    case .FullScreen:
      let fullScreenNotif = NotificationScreenItem(title: L10n.tr("full.screen.interstitial.display.title"),
        description: "",
        color: UIColor(named: UIColor.Name.SecondaryPurple),
        action: { () -> Void in
          AnalyticsMonitor.sendActivityNamed(AnalyticsMonitor.Events.WebAnnouncement.displayFulLScreenIntersticial,
            extras: nil)
          let userInfo = [
            AzMELocalNotification.keyNotificationType : AzMELocalNotification.Fullscreen.rawValue,
            AzMELocalNotification.keyNotificationContent : [
              "title" : L10n.tr("full.screen.interstitial.dialog.announcement.title"),
              "body" : L10n.tr("full.screen.interstitial.dialog.announcement.body"),
              "actionButton" : L10n.tr("home.recent.updates.view.all"),
              "exitButton" : L10n.tr("close.button")
            ],
            AzMELocalNotification.keyNotificationLink : Config.URLs.features
          ]
          DeepLinkHelper.manageLocalNotification(userInfo as [NSObject : AnyObject])
      })
      return [fullScreenNotif]
    case .Poll:
      let poll = NotificationScreenItem(title: L10n.tr("poll.display.title"),
        description: "",
        color: UIColor(named: UIColor.Name.SecondaryPurple),
        action: { () -> Void in
          AnalyticsMonitor.sendActivityNamed(AnalyticsMonitor.Events.Poll.displayPollNotification,
            extras: nil)
          var announcement = AnnouncementViewModel()
          announcement.title = L10n.tr("poll.notification.title")
          announcement.body = L10n.tr("poll.notification.message")
          announcement.actionTitle = L10n.tr("new.poll.submit.title")
          announcement.exitTitle = L10n.tr("negative.button")
          announcement.action = {
            var pollModel = PollViewModel()
            pollModel.title = L10n.tr("new.poll.title")
            pollModel.body = L10n.tr("new.poll.description")
            pollModel.actionTitle = L10n.tr("new.poll.submit.title")
            pollModel.exitTitle = L10n.tr("negative.button")
            let firstQuestion = PollQuestionViewModel(questionId: "1",
              title: L10n.tr("new.poll.question.title.1"),
              choices: [
                PollChoiceViewModel(choiceId: "1", title:  L10n.tr("new.poll.question.yes")),
                PollChoiceViewModel(choiceId: "2", title:  L10n.tr("new.poll.question.no"))
              ])
            
            let sndQuestion = PollQuestionViewModel(questionId: "2",
              title: L10n.tr("new.poll.question.title.2"),
              choices: [
                PollChoiceViewModel(choiceId: "3", title:  L10n.tr("new.poll.question.yes")),
                PollChoiceViewModel(choiceId: "4", title:  L10n.tr("new.poll.question.no"))
              ])
            pollModel.questions = [firstQuestion, sndQuestion]
            let navController = UINavigationController()
            pollModel.action = {
              navController.pushViewController(SuccessPollViewController(), animated: true)
            }
            let pollController = PollViewController(pollModel: pollModel)
            
            navController.setViewControllers([pollController], animated: false)
            self.rootController.presentViewController(navController, animated: true, completion: nil)
            
          }
          DeepLinkHelper.displayLocalInAppNotification(announcement, inController: self.rootController)
          
      })
      return [poll]
    case .DataPush:
      let silentDataPush = NotificationScreenItem(title: L10n.tr("data.push.notification.display.title"),
        description: "",
        color: UIColor(named: UIColor.Name.SecondaryPurple),
        action: { () -> Void in
          AnalyticsMonitor.sendActivityNamed(AnalyticsMonitor.Events.DataPush.launchDataPush,
            extras: nil)
          DeepLinkHelper.pushViewController(ProductViewController(productViewType: .DataPush))
      })
      return [silentDataPush]
    }
  }
}