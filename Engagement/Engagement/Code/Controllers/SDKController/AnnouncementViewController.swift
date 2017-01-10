//
//  AnnouncementViewController.swift
//  Engagement
//
//  Created by Microsoft on 18/02/2016.
//  Copyright © 2016 Microsoft. All rights reserved.
//

import UIKit

protocol AnnouncementIntersticialDelegate{
  func didCloseIntersticial()
  func didOpenIntersticial()
}

/// AnnouncementViewController, for local and AzME SDK
class AnnouncementViewController: AEAnnouncementViewController {
  
  @IBOutlet weak var navBar: UINavigationBar!
  @IBOutlet weak var ibNavItemTitle: UINavigationItem!
  @IBOutlet weak var ibWebView: UIWebView!
  @IBOutlet weak var ibActionButton: UIButton!
  @IBOutlet weak var ibCloseButton: UIButton!
  @IBOutlet weak var ibSeparator: UIView!
  
  @IBOutlet weak var ibNavBarHeight: NSLayoutConstraint!
  fileprivate var isLocal: Bool = false
  
  fileprivate var announcementVM: AnnouncementViewModel?
  
  var intersticialDelegate: AnnouncementIntersticialDelegate?
  
  //MARK: Initialization
  override init!(announcement anAnnouncement: AEReachAnnouncement!) {
    super.init(announcement: anAnnouncement)
  }
  
  init(announcement anAnnouncement: AnnouncementViewModel, isLocal: Bool) {
    self.isLocal = true
    self.announcementVM = anAnnouncement
    super.init(nibName: nil, bundle: nil)
  }
  
  override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(nibName: nil, bundle: nil)
  }
  
  //MARK: View Life Cycle
  override func viewDidLoad() {
    super.viewDidLoad()
    
    ibSeparator.backgroundColor = UIColor(named: UIColor.Name.lightGrey)
    ibActionButton.tintColor = UIColor(named: UIColor.Name.primaryTheme)
    ibCloseButton.tintColor = UIColor(named: UIColor.Name.primaryTheme)
    
    if let announcement = self.announcement{
      self.announcementVM = AnnouncementViewModel(fromAnnouncement: announcement)
    }
    
    //cast here, to improve
    if let _ = parent as? FullscreenInterstitialViewController {
      // Do nothing
    }
    else if isLocal == true {
      self.ibNavBarHeight.constant = 0
    }
    
    if let actionTitle = announcementVM?.actionTitle, actionTitle.isEmpty == false {
      ibActionButton.setTitle(actionTitle, for: UIControlState())
    } else {
      ibActionButton.removeFromSuperview()
    }
    
    if let exitTitle = announcementVM?.exitTitle, exitTitle.isEmpty == false {
      ibCloseButton.setTitle(exitTitle, for: UIControlState())
    } else {
      ibCloseButton.removeFromSuperview()
    }
    
    self.title = announcementVM?.title
    self.ibNavItemTitle.title = announcementVM?.title
    let mainBundle = URL(fileURLWithPath: Bundle.main.bundlePath)
    
    if let HTMLBody = announcementVM?.body{
      if announcementVM?.type == AEAnnouncementType.text{
        let htmlContent = String(HTMLString: HTMLBody)
        ibWebView.loadHTMLString(htmlContent, baseURL: mainBundle)
      }else{
        ibWebView.loadHTMLString(HTMLBody, baseURL: mainBundle)
      }
      
    }
  }
  
  //MARK: Actions
  @IBAction func didTapActionButton(_ sender: AnyObject) {
    AnalyticsMonitor.sendActivityNamed(AnalyticsMonitor.Events.ReboundScreen.viewAll, extras: nil)
    if isLocal == true{
      self.announcementVM?.action?()
    } else {
      if let delegate = self.intersticialDelegate{
        delegate.didOpenIntersticial()
      }else{
        self.action()
      }
      
    }
  }
  
  @IBAction func didTapCloseButton(_ sender: AnyObject) {
    AnalyticsMonitor.sendActivityNamed(AnalyticsMonitor.Events.ReboundScreen.close, extras: nil)
    if isLocal == true{
      self.dismiss(animated: true, completion: nil)
    }
    else{
      
      if let delegate = self.intersticialDelegate{
        delegate.didCloseIntersticial()
      }else{
        self.exit()
      }
      
    }
  }
}
