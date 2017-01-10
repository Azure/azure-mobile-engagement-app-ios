//
//  EventMonitor.swift
//  Engagement
//
//  Created by Microsoft on 19/02/2016.
//  Copyright © 2016 Microsoft. All rights reserved.
//

import Foundation

/**
 *  Default Analytics monitor to sent events, jobs and activities
 Contains default tags values
 */
struct AnalyticsMonitor{
  
  /**
   Send a AzME Analytics Event
   
   - parameter name:   Tag Name
   - parameter extras: Extras Informations
   */
  static func sendActivityNamed(_ name: String, extras: [AnyHashable: Any]?){
    EngagementAgent.shared().sendEvent(name, extras: extras)
  }
  
  //MARK: Activities Tags
  struct Activities
  {
    //Openning of the screen
    static let Home                       = "home"
    static let Features                   = "features"
    static let Videos                     = "videos"
    static let HelpfulLinks               = "helpful_links"
    static let RecentUpdates              = "recent_updates"
    static let GetDeviceID                = "get_device_id"
    static let OutOfAppNotifications      = "notification_out_of_app"
    static let InAppNotifications         = "notification_in_app"
    static let InAppPopUpNotifications    = "notification_in_app_popup"
    static let ProductCoupon              = "product_coupon"
    static let FullScreenIntersticial     = "notification_full_screen"
    static let Poll                       = "notification_poll"
    static let PollDetail                 = "poll_detail"
    static let DataPushNotification       = "notification_datapush"
    static let About                      = "about"
    static let ProductDiscount            = "product_discount"
    static let ReboundScreen              = "rebound"
    static let HowToSendTheseNotfications = "how_to_send"
    
    struct ActivitiesExtras {
      static let notificationType = "notificationType"
      static func notificationExtraValueForType(_ type: ScreenType) -> String {
        switch type {
        case .outOfApp:
          return "notification_out_of_app"
        case .inApp:
          return "notification_in_app"
        case .inAppPopUp:
          return "notification_in_app_popup"
        case .webAnnouncement:
          return "notification_web_announcement"
        case .fullScreen:
          return "notification_full_screen"
        case.poll:
          return "notification_poll"
        case .dataPush:
          return "notification_datapush"
        }
      }
    }
  }
  
  //MARK: Events Tags
  struct Events
  {
    struct Home {
      static let viewAllUpdates           = "view_all_udpates"
      fileprivate static let clickArticleHome = "click_article_home"
      static func clickArticleHome(_ title: String?, URL: String?){
        if let title = title, let URL = URL{
          AnalyticsMonitor.sendActivityNamed(clickArticleHome, extras:
            [AnalyticsMonitor.Events.EventsExtras.title : title,
              AnalyticsMonitor.Events.EventsExtras.URL : URL
            ])
        }
      }
    }
    
    struct SafariViewController {
      static let twitter            = "menu_twitter"
      static let applicationBackend = "menu_backend_link"
      static let documentation      = "click_documentation_link"
      static let pricing            = "click_pricing_link"
      static let SLA                = "click_sla_link"
      static let MSDNForum          = "click_msdn_link"
      static let clickSuggestFeatures = "click_suggest_product_features_link"
    }
    
    struct RecentUpdates {
      fileprivate static let clickArticle = "click_article"
      static func clickArticle(_ title: String?, URL: String?){
        if let title = title, let URL = URL{
          AnalyticsMonitor.sendActivityNamed(clickArticle, extras:
            [AnalyticsMonitor.Events.EventsExtras.title : title,
              AnalyticsMonitor.Events.EventsExtras.URL : URL
            ])
        }
      }
      
    }
    
    struct GetDeviceID {
      static let share = "share_device_id"
      static let copy  = "copy_device_id"
    }
    
    struct About {
      static let source   = "click_source_link"
      static let licences = "click_3rd_party_notices_link"
    }
    
    struct OutOfAppNotifications {
      static let displayNotification = "display_out_of_app_notification_only"
      static let displayAnnoucement  = "display_out_of_app_announcement"
    }
    
    struct TypeOfNotifications {
      static let notificationOnly = "notification_only_title_message"
    }
    
    struct ReboundScreen {
      static let close   = "close_rebound"
      static let viewAll = "view_all_from_rebound"
    }
    
    struct InAppNotifications {
      static let displayNotification = "display_in_app_notification_only"
      static let displayAnnouncement = "display_in_app_announcement"
    }
    
    struct InAppPopUpNotifications {
      static let displayInAppPopUp = "display_in_app_pop_up"
    }
    
    struct WebAnnouncement {
      static let displayFulLScreenIntersticial = "web_announcement"
    }
    
    struct FullScreenIntersticial {
      static let displayFulLScreenIntersticial = "display_full_interstitial"
    }
    
    struct Poll {
      static let displayPollNotification = "display_poll"
    }
    
    struct PollDetail {
      static let cancel = "cancel_poll_detail"
      static let submit = "submit_poll_answers"
    }
    
    struct PollDetailThanks {
      static let close = "close_poll_thanks"
    }
    
    struct DataPush {
      static let launchDataPush = "launch_data_push"
    }
    
    struct ProductDiscount {
      static let applyDiscount  = "apply_discount"
      static let removeDiscount = "remove_discount"
    }
    
    struct Video {
      static let play = "play_video"
      fileprivate static let stop = "stop_video"
      static func stop(_ seconds: Int){
        
      }
    }
    
    struct EventsExtras {
      static let title = "title"
      static let URL = "URL"
      static let videoLength = "videoLength"
    }
  }
  
  //MARK: Jobs Tags
  struct Jobs
  {
    
    struct Video {
      
      fileprivate static let videoTag = "video"
      
      static func start(_ title: String?, URL: String?) {
        if let title = title, let videoURL = URL {
          EngagementAgent.shared().startJob(videoTag,
            extras: [
              AnalyticsMonitor.Events.EventsExtras.title : title,
              AnalyticsMonitor.Events.EventsExtras.URL : videoURL
            ])
        }
      }
      
      static func end() {
        print("End video job")
        EngagementAgent.shared().endJob(videoTag)
      }
    }
    
  }
  
}
