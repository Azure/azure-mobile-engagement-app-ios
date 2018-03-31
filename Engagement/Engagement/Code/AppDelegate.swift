//
//  AppDelegate.swift
//  Engagement
//
//  Created by Microsoft on 08/02/2016.
//  Copyright © 2016 Microsoft. All rights reserved.
//

import UIKit
import MMDrawerController
import AdSupport //Just to print your device advertisingIdentifier
import SwiftyJSON
import MessageUI

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
  
  var window: UIWindow?
    fileprivate var popOver: UIPopoverPresentationController?
  
  //MARK: UIApplicationDelegate
  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
    
    configureAzMESDK()
    
    Theme.prepareThemeAppearance()
    
    //Prepare drawer root navigation
    let screenBounds = UIScreen.main.bounds
    
    let leftController = MenuViewController()
    let centerController = UINavigationController(rootViewController: HomeViewController())
    let drawer = MMDrawerController(center: centerController, leftDrawerViewController: leftController)
    drawer?.shouldStretchDrawer = false
    drawer?.maximumLeftDrawerWidth = min(screenBounds.width - 50, 310)//For iPad, not be too large
    drawer?.openDrawerGestureModeMask = .panningCenterView
    drawer?.closeDrawerGestureModeMask = .all
    drawer?.setDrawerVisualStateBlock(MMDrawerVisualState.parallaxVisualStateBlock(withParallaxFactor: 2.0))
    drawer?.setGestureCompletionBlock { (drawer, gesture) -> Void in
      UIApplication.checkStatusBarForDrawer(drawer)
    }
    self.window = UIWindow(frame: screenBounds)
    self.window?.backgroundColor = UIColor.black
    
    let drawerNav = UINavigationController(rootViewController: drawer!)
    drawerNav.isNavigationBarHidden = true
    self.window?.rootViewController = drawerNav
    
    self.window?.makeKeyAndVisible()
    
    return true
  }
  
  func application(_ application: UIApplication,
    didReceiveRemoteNotification userInfo: [AnyHashable: Any],
    fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void)
  {
    EngagementAgent.shared().applicationDidReceiveRemoteNotification(userInfo,
      fetchCompletionHandler: completionHandler)
  }
  
  func application(_ application: UIApplication, didReceive notification: UILocalNotification) {
    //Only from background
    if application.applicationState != .active {
      DeepLinkHelper.manageLocalNotification(notification.userInfo)
    }
  }
  
  func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
    EngagementAgent.shared().registerDeviceToken(deviceToken)
  }
  
  func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {

    let notificationAlert = UIAlertController(title: "Notifications",
      message: L10n.tr("permission.message"),
      preferredStyle: UIAlertControllerStyle.alert)
    
    notificationAlert.addAction(UIAlertAction(title: "Go to settings",
      style: .default,
      handler:
      { (action: UIAlertAction!) in
        let settingsUrl = URL(string: UIApplicationOpenSettingsURLString)
        if let url = settingsUrl {
          UIApplication.shared.openURL(url)
        }
    }))
    notificationAlert.addAction(UIAlertAction(title: "Cancel",
      style: .cancel,
      handler: { (action: UIAlertAction!) in
      notificationAlert.dismiss(animated: true, completion: nil)
    }))
    self.window?.rootViewController?.present(notificationAlert, animated: true, completion: nil)
  }
  
  func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any]) -> Bool {
    return DeepLinkHelper.canManage(url)
  }
  
  func application(_ application: UIApplication, handleActionWithIdentifier identifier: String?, for notification: UILocalNotification, completionHandler: @escaping () -> Void) {
    
    if identifier == Config.Notifications.shareIdentifier {
      let textToShare = "Product feedback"
      let objectsToShare = [textToShare]
      let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
      activityVC.popoverPresentationController?.sourceView = self.window?.rootViewController?.view
      self.window?.rootViewController?.present(activityVC, animated: true, completion: nil)
    }
    else if identifier == Config.Notifications.feedbackIdentifier {
      let mailComposerVC = MFMailComposeViewController()
      mailComposerVC.mailComposeDelegate = self
      mailComposerVC.setToRecipients([""])
      mailComposerVC.setSubject("Feedback about the recent update")
      mailComposerVC.setMessageBody("Say something", isHTML: false)
      mailComposerVC.navigationBar.tintColor = UIColor.white
      
      // TODO: Need to updates this part.
      self.window?.rootViewController?.present(mailComposerVC, animated: true, completion: {
        UIApplication.setStatusBarStyle(.lightContent)
      })
    }
  }
  
  /**
   Configure default AzME SDK implemntation
   */
  func configureAzMESDK()
  {
    if let reachModule = AEReachModule.module(withNotificationIcon: UIImage(named: "")) as? AEReachModule {
      //Poll Notifications
      reachModule.registerPollController(PollViewController.classForCoder(), forCategory: kAEReachDefaultCategory)

      reachModule.register(AzMENotifier(), forCategory: kAEReachDefaultCategory)
      reachModule.register(AzMENotifier(), forCategory: Config.AzMESDK.popUpCategory)
      
      reachModule.registerAnnouncementController(AnnouncementViewController.classForCoder(),
        forCategory: kAEReachDefaultCategory)
      reachModule.registerAnnouncementController(FullscreenInterstitialViewController.classForCoder(),
        forCategory: Config.AzMESDK.interstitialCategory)
      reachModule.registerAnnouncementController(FullscreenInterstitialViewController.classForCoder(),
        forCategory: Config.AzMESDK.webAnnouncementCategory)
      
      reachModule.setAutoBadgeEnabled(true)
      reachModule.dataPushDelegate = self
      
      EngagementAgent.init(Config.AzMESDK.endPoint, modulesArray: [reachModule])
    }
  }
  
}

//MARK: AEReachDataPushDelegate
extension AppDelegate: AEReachDataPushDelegate{
  
  func didReceiveStringDataPush(withCategory category: String!, body: String!) -> Bool {
    if let dataFromString = body.data(using: String.Encoding.utf8, allowLossyConversion: false) {
      let json = JSON(data: dataFromString)
      
      let isDiscountAvailable = json[Config.Product.DataPush.isDiscountAvailable].boolValue
      let discountRateInPercent = json[Config.Product.DataPush.discountRateInPercent].intValue
      
      let defaults = UserDefaults.standard
      defaults.set(isDiscountAvailable, forKey: Config.Product.DataPush.isDiscountAvailable)
      defaults.set(discountRateInPercent, forKey: Config.Product.DataPush.discountRateInPercent)
      defaults.synchronize()
      NotificationCenter.default.post(name: Notification.Name(rawValue: Config.Notifications.dataPushValuesUpdated), object: nil)
    }
    return true
  }
}

//MARK: MFMailComposeViewControllerDelegate
extension AppDelegate: MFMailComposeViewControllerDelegate{
  func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
    controller.dismiss(animated: true, completion: nil)
  }
}


