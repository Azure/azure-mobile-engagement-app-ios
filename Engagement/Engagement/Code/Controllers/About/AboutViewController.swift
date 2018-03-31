//
//  AboutViewController.swift
//  Engagement
//
//  Created by Microsoft on 19/02/2016.
//  Copyright © 2016 Microsoft. All rights reserved.
//

import UIKit

/*
Credits View Controller
*/
class AboutViewController: CenterViewController {
  
  @IBOutlet weak var ibWebView: UIWebView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.navigationItem.title = L10n.tr("menu.about.title")
    
    self.ibWebView.delegate = self
    if let aboutUrl = Bundle.main.path(forResource: "about", ofType: "html", inDirectory: "html")
    {
      self.ibWebView.loadRequest(URLRequest(url: URL(fileURLWithPath: aboutUrl)))
    }
  }
  
  override func engagementActivityName() -> String! {
    return AnalyticsMonitor.Activities.About
  }
  
  fileprivate func openLink(_ link: String) {
    if let URL = URL(string: link) {
      let controller = AzMESafariController(url: URL)
      self.navigationController?.present(controller, animated: true, completion: nil)
    }
  }
}

//MARK: UIWebViewDelegate
extension AboutViewController : UIWebViewDelegate {
  
  func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool {
    if let url = request.url?.absoluteString {
      if (url.hasSuffix("smartnsoft")) {
        openLink(Config.URLs.smartnsoft)
      }
      else if (url.hasSuffix("github")) {
        openLink(Config.URLs.github)
      }
      else if (url.hasSuffix("application_license")) {
        openLink(Config.URLs.applicationsLicenses)
      }
      else if (url.hasSuffix("third_party_notices")) {
        openLink(Config.URLs.thirdParties)
      }
      else {
        return true
      }
      return false;
    }
    return true;
    
  }
}
