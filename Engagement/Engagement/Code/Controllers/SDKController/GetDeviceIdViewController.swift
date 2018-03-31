//
//  GetDeviceIdViewController.swift
//  Engagement
//
//  Created by Microsoft on 11/02/2016.
//  Copyright © 2016 Microsoft. All rights reserved.
//


import UIKit

/// To Share the AzME device ID
class GetDeviceIdViewController: CenterViewController {
  
  @IBOutlet weak var ibIcon: UIImageView!
  @IBOutlet weak var ibShareButton: AzButton!
  
  override func engagementActivityName() -> String! {
    return AnalyticsMonitor.Activities.GetDeviceID
  }
  
  //MARK: View Life Cycle
  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.title = L10n.tr("menu.get.device.id.title")
    
    ibShareButton.setImage(UIImage(named: "share")?.withRenderingMode(.alwaysTemplate), for: UIControlState())
    
    ibIcon.image = AzIcon.iconMenGetDeviceID(60).image(with: CGSize(width: 60, height: 60)).withRenderingMode(.alwaysTemplate)
    ibIcon.tintColor = UIColor(named: UIColor.Name.lightGrey)
  }
  
  //MARK: Actions
  @IBAction func didTapShareButton(_ sender: AnyObject)
  {
    AnalyticsMonitor.sendActivityNamed(AnalyticsMonitor.Events.GetDeviceID.share, extras: nil)
    let azmeDeviceIdentifier = EngagementAgent.shared().deviceId()
    let objectsToShare = [azmeDeviceIdentifier]
    DispatchQueue.global(priority: DispatchQueue.GlobalQueuePriority.default).async
      {
        let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
        if UIDevice.current.userInterfaceIdiom == .pad{
          activityVC.popoverPresentationController?.sourceView = self.ibShareButton
          activityVC.popoverPresentationController?.sourceRect = self.ibShareButton.bounds
        }
        activityVC.completionWithItemsHandler = { (activityTypeString, completed, items, error) in
          if completed == true && error == nil{
            if (activityTypeString == UIActivityType.copyToPasteboard){
              AnalyticsMonitor.sendActivityNamed(AnalyticsMonitor.Events.GetDeviceID.copy, extras: nil)
            }else{
              AnalyticsMonitor.sendActivityNamed(AnalyticsMonitor.Events.GetDeviceID.share, extras: nil)
            }
          }
        }
        DispatchQueue.main.async {
          self.present(activityVC, animated: true, completion: nil)
        }
    }
  }
}
