//
//  Config.swift
//  Engagement
//
//  Created by Microsoft on 16/02/2016.
//  Copyright © 2016 Microsoft. All rights reserved.
//

import Foundation

/**
 *  Contain all default data configurations like URLs or default prices
 */
struct Config {
  
  static let defaultHTMLHowToDir = "html/how_to_send_notification"
  
  /**
   *  Services Configuration URLs
   */
  struct Services{
    static let azmeMoviesFeed = "https://aka.ms/azmevideosfile"
    static let recentUpdates = "https://aka.ms/azmerssfeed"
  }
  
  /**
   *  AzME default Web Links
   */
  struct URLs {
    static let helpfulDocumentation = "http://aka.ms/azmedoclanding"
    static let helpfulPricing = "http://aka.ms/azmepricing"
    static let helpfulSLA = "http://aka.ms/azmesla"
    static let helpfulMSDNForum = "http://aka.ms/azmemsdnforum"
    static let helpfulVoiceForum = "http://aka.ms/azmeuservoice"
    static let twitterAccount = "https://twitter.com/AzureMobileEng"
    static let backendDemo = "http://aka.ms/azmeiosdemoapp"
    static let features = "http://aka.ms/azmefeatures"
    static let applicationsLicenses = "http://aka.ms/azmedemoapplicense"
    static let thirdParties = "http://aka.ms/azmedemoappiosnotices"
    static let smartnsoft = "http://www.smartnsoft.com"
    static let github = "http://aka.ms/azmeiosdemoappsource"
  }
  
  /**
   *  AzMESDK endPoints configurations
   */
  struct AzMESDK {
    #if DEBUG
    static let endPoint =  ""//Your_Development_EndPoint_Here
    #else
    static let endPoint =  ""//Your_Release_EndPoint_Here
    #endif
    
    struct DeepLink {
      static let recentUpdatesSubPath = "/recent_updates"
      static let recentUpdatesLink = "engagement://demo/recent_updates"
      static let videosSubPath = "/videos"
      static let videosLink = "engagement://demo/videos"
      static let productSubPath = "/product"
      static let productLink = "engagement://demo/product"
    }
    
    static let interstitialCategory = "INTERSTITIAL"
    static let webAnnouncementCategory = "WEB_ANNOUNCEMENT"
    static let popUpCategory = "POP-UP"
  }
  
  struct Notifications {
    static let dataPushValuesUpdated = "dataPushValuesUpdated"
    
    static let shareActionTitle = "Share"
    static let shareIdentifier = "share"
    
    static let feedbackActionTitle = "Feedback"
    static let feedbackIdentifier = "feedback"
  }
  
  /**
   *  Default data about Product Coupon features
   */
  struct Product {
    struct DataPush {
      static let isDiscountAvailable = "isDiscountAvailable"
      static let discountRateInPercent = "discountRateInPercent"
    }
    static func defaultReductionRatio() -> Int{
      return 15
    }
    static let defaultPrice = 899
  }
}
