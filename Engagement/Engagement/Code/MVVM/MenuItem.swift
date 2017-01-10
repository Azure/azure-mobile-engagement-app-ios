//
//  MenuItem.swift
//  Engagement
//
//  Created by Microsoft on 10/02/2016.
//  Copyright © 2016 Microsoft. All rights reserved.
//

import UIKit

let defaultMenuImageWidth = 25

/**
 *  Represent an item to be display on the left side menu controller
 */
struct MenuItem {
  
  var icon: UIImage?
  var title: String?
  var initViewController: (() -> UIViewController?)?
  var selectedCompletion: (() -> Void)?
  var isChild: Bool?
  var isSelectable: Bool?
  var separator: Bool?
  
  //MARK - Initialisations
  init(title: String?, icon: AzIcon, isSelectable: Bool = true){
    self.icon = icon.image(with: CGSize(width: defaultMenuImageWidth, height: defaultMenuImageWidth)).withRenderingMode(.alwaysTemplate)
    self.title = title
    self.isSelectable = isSelectable
  }
  
  init(title: String?, icon: AzIcon, initViewController: (() -> UIViewController?)?) {
    self.init(title: title, icon: icon)
    self.initViewController = initViewController
  }
  
  init(title: String?, icon: AzIcon, selectedCompletion: (() -> Void)?, isChild: Bool = false) {
    self.init(title: title, icon: icon, isSelectable: false)
    self.selectedCompletion = selectedCompletion
    self.isChild = isChild
  }
  
  /**
   Default helpuflinks to collapse into the menu
   
   - parameter controller: The MenuViewController receiver
   
   - returns: Array of MenuItem
   */
  static func helpfulLinksFromMenuController(_ controller: MenuViewController) -> [MenuItem] {
    let documentationItem = MenuItem(title: L10n.tr("helpful.link.documentation"),
      icon: AzIcon.iconDocumentation(),
      selectedCompletion: {
        AnalyticsMonitor.sendActivityNamed(AnalyticsMonitor.Events.SafariViewController.documentation, extras: nil)
        controller.openLink(Config.URLs.helpfulDocumentation)
      },
      isChild: true)
    
    let pricingItem = MenuItem(title: L10n.tr("helpful.link.pricing"),
      icon: AzIcon.iconPricing(),
      selectedCompletion: {
        AnalyticsMonitor.sendActivityNamed(AnalyticsMonitor.Events.SafariViewController.pricing, extras: nil)
        controller.openLink(Config.URLs.helpfulPricing)
      },
      isChild: true)
    
    let SLAItem = MenuItem(title: L10n.tr("helpful.link.sla"),
      icon: AzIcon.iconSLA(),
      selectedCompletion: {
        AnalyticsMonitor.sendActivityNamed(AnalyticsMonitor.Events.SafariViewController.SLA, extras: nil)
        controller.openLink(Config.URLs.helpfulSLA)
      },
      isChild: true)
    
    let MSDNForumItem = MenuItem(title: L10n.tr("helpful.link.msdn.support.forum"),
      icon: AzIcon.iconMSDNForum(),
      selectedCompletion: {
        AnalyticsMonitor.sendActivityNamed(AnalyticsMonitor.Events.SafariViewController.MSDNForum, extras: nil)
        controller.openLink(Config.URLs.helpfulMSDNForum)
      },
      isChild: true)
    
    let userVoiceForumItem = MenuItem(title: L10n.tr("helpful.link.user.voice.forum"),
      icon: AzIcon.iconUserVoiceForum(),
      selectedCompletion: {
        AnalyticsMonitor.sendActivityNamed(AnalyticsMonitor.Events.SafariViewController.clickSuggestFeatures, extras: nil)
        controller.openLink(Config.URLs.helpfulVoiceForum)
      },
      isChild: true)
    
    return [documentationItem, pricingItem, SLAItem, MSDNForumItem, userVoiceForumItem];
  }
  
  /**
   Default data source fot the drawer menu
   
   - parameter controller: The MenuViewController receiver
   
   - returns: An array of section|items tuple
   */
  static func defaultDataSoruceFromMenuController(_ controller: MenuViewController) -> [(sectionName: String, items: [MenuItem])]{
    
    var dataSource = [(sectionName: String, items: [MenuItem])]()
    // Home section
    let homeItem = MenuItem(title: L10n.tr("menu.home.title"),
      icon: AzIcon.iconMenuHome(),
      initViewController: {return HomeViewController()})
    
    dataSource.append(("", [homeItem]))
    
    // Resources section
    let featuresItem = MenuItem(title: L10n.tr("menu.features.title"),
      icon: AzIcon.iconMenuFeatures(defaultMenuImageWidth),
      initViewController: {return WebViewController(title: L10n.tr("menu.features.title"),
        URL: URL(string: Config.URLs.features))})
    
    let videosItem = MenuItem(title: L10n.tr("menu.videos.title"),
      icon: AzIcon.iconMenuVideos(defaultMenuImageWidth),
      initViewController: {return VideosViewController()})
    
    let helpfulLinksItem = MenuItem(title: L10n.tr("menu.helpful.links.title"),
      icon: AzIcon.iconMenuHelpfulLinks(defaultMenuImageWidth),
      selectedCompletion: {
        controller.toogleLinks()
    })
    
    let recentUpdatesItem = MenuItem(title: L10n.tr("menu.recent.product.updates.title"),
      icon: AzIcon.iconMenuRecentUpdates(defaultMenuImageWidth),
      initViewController: {return RecentUpdatesController()})
    
    var twitterItem = MenuItem(title: L10n.tr("menu.twitter.title"),
      icon: AzIcon.iconMenuTwitter(defaultMenuImageWidth),
      initViewController: nil)
    twitterItem.selectedCompletion = {
      AnalyticsMonitor.sendActivityNamed(AnalyticsMonitor.Events.SafariViewController.twitter, extras: nil)
      controller.openLink(Config.URLs.twitterAccount)
    }
    
    var demoAppBackendItem = MenuItem(title: L10n.tr("menu.application.backend.title"),
      icon: AzIcon.iconMenuDemoAppBackend(defaultMenuImageWidth),
      initViewController: nil)
    demoAppBackendItem.separator = true
    demoAppBackendItem.selectedCompletion = {
      AnalyticsMonitor.sendActivityNamed(AnalyticsMonitor.Events.SafariViewController.applicationBackend, extras: nil)
      controller.openLink(Config.URLs.backendDemo)
    }
    
    let getDeviceIdItem = MenuItem(title: L10n.tr("menu.get.device.id.title"),
      
      icon: AzIcon.iconMenGetDeviceID(defaultMenuImageWidth),
      initViewController: {return GetDeviceIdViewController()})
    
    dataSource.append((L10n.tr("menu.section.resources"),
      [featuresItem, videosItem, helpfulLinksItem, recentUpdatesItem, twitterItem, demoAppBackendItem, getDeviceIdItem]))
    
    // Notification scenarios section
    let outOfAppItem = MenuItem(title: L10n.tr("menu.out.of.app.title"),
      icon: AzIcon.iconMenuOutApp(defaultMenuImageWidth),
      initViewController: {return NotificationsViewController(notifScreen: ScreenType.outOfApp)})
    
    let inAppItem = MenuItem(title: L10n.tr("menu.in.app.title"),
      icon: AzIcon.iconMenuInApp(defaultMenuImageWidth),
      initViewController: {return NotificationsViewController(notifScreen: ScreenType.inApp)})
    
    let inAppPopUpItem = MenuItem(title: L10n.tr("menu.in.app.pop.up.title"),
      icon: AzIcon.iconMenuPopUp(defaultMenuImageWidth),
      initViewController: {return NotificationsViewController(notifScreen: ScreenType.inAppPopUp)})
    
    let webAnnouncementItem = MenuItem(title: L10n.tr("menu.web.announcement.title"),
      icon: AzIcon.iconMenuFullScreen(defaultMenuImageWidth),
      initViewController: {return NotificationsViewController(notifScreen: ScreenType.webAnnouncement)})
    
    let fullscreenItem = MenuItem(title: L10n.tr("menu.full.screen.title"),
      icon: AzIcon.iconMenuFullScreen(defaultMenuImageWidth),
      initViewController: {return NotificationsViewController(notifScreen: ScreenType.fullScreen)})
    
    let pollItem = MenuItem(title: L10n.tr("menu.poll.title"),
      icon: AzIcon.iconMenuPoll(defaultMenuImageWidth),
      initViewController: {return NotificationsViewController(notifScreen: ScreenType.poll)})
    
    var dataPushItem = MenuItem(title: L10n.tr("menu.data.push.title"),
      icon: AzIcon.iconMenuDataPush(defaultMenuImageWidth),
      initViewController: {return NotificationsViewController(notifScreen: ScreenType.dataPush)})
    dataPushItem.separator = true
    
    var aboutItem = MenuItem(title: L10n.tr("menu.about.title"),
      icon: AzIcon.iconMenuAbout(defaultMenuImageWidth),
      initViewController: {return AboutViewController()})
    aboutItem.separator = true
    
    dataSource.append((L10n.tr("menu.section.notification.scenarios"),
      [outOfAppItem, inAppItem, inAppPopUpItem, webAnnouncementItem, fullscreenItem, pollItem, dataPushItem, aboutItem]))
    
    return dataSource
  }
  
}
