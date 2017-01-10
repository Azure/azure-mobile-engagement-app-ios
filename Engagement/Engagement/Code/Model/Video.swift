//
//  Video.swift
//  Engagement
//
//  Created by Microsoft on 09/02/2016.
//  Copyright © 2016 Microsoft. All rights reserved.
//

import Foundation
import SwiftyJSON

/**
 *  Video struct model
 */
struct Video {
  
  var title: String?
  var description: String?
  var pictureUrl: String?
  var videoUrl: String?
  var isEmbed = false
  
  static func parseFromJSONElement(_ json: JSON) -> Video
  {
    var video = Video()
    video.title = json["title"].stringValue
    video.pictureUrl = json["pictureUrl"].stringValue
    video.description = json["description"].stringValue
    video.videoUrl = json["videoUrl"].stringValue
    return video
  }
  
  /**
   Default embed video
   
   - returns: a Video model pointing on a local video
   */
  static func defaultVideo() -> Video
  {
    return Video(title: "Azure Mobile Engagement Overview",
      description: "Brief overview of Azure Mobile Engagement service and the benefits it provides to the app publishers/marketers",
      pictureUrl: "mobileengagementoverview_960",
      videoUrl: "mobileengagementoverview_mid",
      isEmbed: true)
  }
}
