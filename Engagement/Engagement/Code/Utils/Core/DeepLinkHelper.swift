//
//  DeepLinkHelper.swift
//  Engagement
//
//  Created by Microsoft on 16/02/2016.
//  Copyright © 2016 Microsoft. All rights reserved.
//

import Foundation
import MMDrawerController


private let recentUpdatesDeepLink = Config.AzMESDK.DeepLink.recentUpdatesSubPath
private let videosDeepLink = Config.AzMESDK.DeepLink.videosSubPath
/*
Default local notifications type to simulate across the app
*/
enum AzMELocalNotification: String{
  case DeepLink, WebAnnouncement, Poll, Fullscreen
  
  static let keyNotificationType = "keyNotificationType"
  static let keyNotificationLink = "keyNotificationLink"
  static let keyNotificationContent = "keyNotificationContent"
}

/**
 *  DeepLink Helper for the App. This will manage UILocalNotifications, RemoteNotifications and some controller worflow behaviors
 */
struct DeepLinkHelper{
  
  /**
   Return true and perform related action according to the received DeepLink URLScheme
   
   - parameter url: URL Scheme received
   
   - returns: Return true if any action can be perfomed by the app
   */
  static func canManage(_ url: URL) -> Bool
  {
    if url.scheme == "http"
    {
      let controller = AzMESafariController(url: url)
      self.rootNavigationViewController()?.present(controller, animated: true, completion: nil)
    }
    else if url.path == recentUpdatesDeepLink
    {
      self.pushViewController(RecentUpdatesController())
    }
    else if url.path == videosDeepLink
    {
      self.pushViewController(VideosViewController())
    }
    else if url.path == Config.AzMESDK.DeepLink.productSubPath
    {
      self.pushViewController(ProductViewController())
    }
    
    return false
  }
  
  /**
   Manage a UILocalNotification to simulate Push & DeepLinking management in local
   
   - parameter userInfo: The content of the local notification received
   */
  static func manageLocalNotification(_ userInfo: [AnyHashable: Any]?)
  {
    
    if let userInfo = userInfo,
      let type = userInfo[AzMELocalNotification.keyNotificationType] as? String,
      let notificationType = AzMELocalNotification(rawValue: type)
    {
      switch notificationType
      {
      case .DeepLink:
        if let linkString = userInfo[AzMELocalNotification.keyNotificationLink] as? String,
          let URL = URL(string: linkString)
        {
          DeepLinkHelper.canManage(URL)
        }
        break
      case .WebAnnouncement:
        if let content = userInfo[AzMELocalNotification.keyNotificationContent] as? [AnyHashable: Any]{
          
          var fakeAnnouncement = AnnouncementViewModel()
          fakeAnnouncement.title = content["title"] as? String
          fakeAnnouncement.actionTitle = content["actionButton"] as? String
          fakeAnnouncement.exitTitle = content["exitButton"] as? String
          fakeAnnouncement.body = content["body"] as? String
          fakeAnnouncement.action =
            {
              if let linkString = userInfo[AzMELocalNotification.keyNotificationLink] as? String,
                let URL = URL(string: linkString)
              {
                self.rootNavigationViewController()?.dismiss(animated: true,
                  completion: { () -> Void in
                    DeepLinkHelper.canManage(URL)
                })
              }
          }
          
          let controller = UINavigationController(rootViewController: AnnouncementViewController(announcement: fakeAnnouncement,
            isLocal: true))
          
          self.rootNavigationViewController()?.present(controller,
            animated: true,
            completion: nil)
          
        }
      case .Fullscreen:
        if let content = userInfo[AzMELocalNotification.keyNotificationContent] as? [AnyHashable: Any]{
          
          var fakeAnnouncement = AnnouncementViewModel()
          fakeAnnouncement.title = content["title"] as? String
          fakeAnnouncement.actionTitle = content["actionButton"] as? String
          fakeAnnouncement.exitTitle = content["exitButton"] as? String
          fakeAnnouncement.body = content["body"] as? String
          fakeAnnouncement.action =
            {
              if let linkString = userInfo[AzMELocalNotification.keyNotificationLink] as? String,
                let URL = URL(string: linkString)
              {
                self.rootNavigationViewController()?.dismiss(animated: true,
                  completion: { () -> Void in
                    DeepLinkHelper.canManage(URL)
                })
              }
          }
          
          let controller = FullscreenInterstitialViewController(announcement: fakeAnnouncement, isLocal: true)
          //                    controller.view.backgroundColor = UIColor.clearColor()
          //                    controller.modalPresentationStyle = UIModalPresentationStyle.CurrentContext
          
          
          controller.providesPresentationContextTransitionStyle = true
          controller.definesPresentationContext = true
          controller.modalPresentationStyle = UIModalPresentationStyle.currentContext
          controller.view.backgroundColor = UIColor(named: UIColor.Name.primaryTheme)
          self.rootNavigationViewController()?.present(controller,
            animated: true,
            completion: nil)
        }
        break
      case .Poll: break
      }
      
    }
    
  }
  
  /**
   Analyze the announcement view model object an display a fake in-app AzME notification inside a specific controller
   
   - parameter announcement: The Announcement View Model which contains deep link and notifications informations
   - parameter inController: The controller where the in-app notification view have to be displayed
   */
  static func displayLocalInAppNotification(_ announcement: AnnouncementViewModel, inController: UIViewController){
    
    let notificationView = AzMEInAppNotificationView(announcement: announcement)
    notificationView.alpha = 0
    notificationView.translatesAutoresizingMaskIntoConstraints = false
    inController.view.addSubview(notificationView)
    
    let trailing = "H:|-0-[notificationView]-0-|"
    let vertical = "V:[notificationView(>=55)]-0-|"
    
    let trailingConstraint = NSLayoutConstraint.constraints(
      withVisualFormat: trailing,
      options: [],
      metrics: nil,
      views: ["notificationView" : notificationView])
    
    let toBottomConstraint = NSLayoutConstraint.constraints(
      withVisualFormat: vertical,
      options: [],
      metrics: nil,
      views: ["notificationView" : notificationView])
    
    inController.view.addConstraints(trailingConstraint)
    inController.view.addConstraints(toBottomConstraint)
    
    notificationView.sizeToFit()
    notificationView.setNeedsLayout()
    notificationView.layoutIfNeeded()
    notificationView.applyShadow()
    
    UIView.animate(withDuration: 0.3, animations: { () -> Void in
      notificationView.alpha = 1
    }) 
  }
  
  /**
   Push a ViewController according to the actual view navigation hierarchy
   
   - parameter controller: ViewController to be pushed
   */
  static func pushViewController(_ controller: UIViewController){
    self.rootNavigationViewController()?.pushViewController(controller, animated: true)
  }
  
  /**
   Present a ViewController according to the actual view navigation hierarchy
   
   - parameter controller: ViewController to be modally presented
   */
  static func presentViewController(_ controller: UIViewController, animated: Bool){
    self.rootNavigationViewController()?.present(controller, animated: animated, completion: nil)
  }
  
  /**
   Retrieve and optionnally return the default root UINavigationController
   
   - returns: Default root UINavigationController
   */
  static func rootNavigationViewController() -> UINavigationController?
  {
    if let appDelegate = UIApplication.shared.delegate as? AppDelegate,
      let rootController = appDelegate.window?.rootViewController as? UINavigationController,
      let drawer = rootController.viewControllers.first as? MMDrawerController,
      let rootNav = drawer.centerViewController as? UINavigationController
    {
      return rootNav
    }
    return nil
  }
}
