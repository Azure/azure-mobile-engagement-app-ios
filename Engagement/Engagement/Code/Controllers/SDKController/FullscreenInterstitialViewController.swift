//
//  FullscreenInterstitialViewController.swift
//  Engagement
//
//  Created by Microsoft on 26/02/2016.
//  Copyright © 2016 Microsoft. All rights reserved.
//

import Foundation

/// FullscreenInterstitialViewController, for local and AzME SDK
class FullscreenInterstitialViewController : AEAnnouncementViewController {
  
  @IBOutlet weak var ibAnnoncementView: UIView!
  @IBOutlet weak var ibcTopConstraint: NSLayoutConstraint!
  
  fileprivate var announcementVM: AnnouncementViewModel?
  
  //MARK: Initialization
  override init!(announcement anAnnouncement: AEReachAnnouncement!) {
    super.init(announcement: anAnnouncement)
  }
  
  init(announcement anAnnouncement: AnnouncementViewModel, isLocal: Bool) {
    self.announcementVM = anAnnouncement
    super.init(nibName: nil, bundle: nil)
  }
  
  override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(nibName: nil, bundle: nil)
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    let annoncementViewController: AnnouncementViewController
    if self.announcement != nil {
      annoncementViewController = AnnouncementViewController(announcement: self.announcement)
      annoncementViewController.intersticialDelegate = self
      self.ibcTopConstraint.constant = 10
    } else {
      annoncementViewController = AnnouncementViewController(announcement: announcementVM!, isLocal: true)
    }
    
    self.addChildViewController(annoncementViewController)
    annoncementViewController.view.frame = CGRect(x: 0, y: 0, width: ibAnnoncementView.frame.size.width, height: ibAnnoncementView.frame.size.height);
    self.addChildViewController(annoncementViewController)
    self.ibAnnoncementView.addSubview(annoncementViewController.view)
    annoncementViewController.didMove(toParentViewController: self)
    annoncementViewController.view.layer.cornerRadius = 10
    annoncementViewController.view.layer.masksToBounds = true
    self.ibAnnoncementView.layer.cornerRadius = 10
    self.ibAnnoncementView.layer.masksToBounds = true
    self.ibAnnoncementView.layer.shadowOffset = CGSize(width: 0, height: 0)
    self.ibAnnoncementView.layer.shadowColor = UIColor.black.cgColor
    self.ibAnnoncementView.layer.shadowOpacity = 1
    self.ibAnnoncementView.layer.shadowRadius = 5
    self.ibAnnoncementView.clipsToBounds = false
  }
  
}

extension FullscreenInterstitialViewController: AnnouncementIntersticialDelegate{
  func didOpenIntersticial() {
    self.action()
  }
  
  func didCloseIntersticial() {
    self.exit()
  }
}
