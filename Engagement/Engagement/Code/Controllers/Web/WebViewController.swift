//
//  WebViewController.swift
//  Engagement
//
//  Created by Microsoft on 12/02/2016.
//  Copyright © 2016 Microsoft. All rights reserved.
//

import UIKit

/// Simple WebViewController
class WebViewController: CenterViewController {
  
  @IBOutlet weak var ibActivityIndicator: UIActivityIndicatorView!
  @IBOutlet weak var ibWebView: UIWebView!
  
  var URL: Foundation.URL?
  var navTitle: String?
  
  //MARK: Initialization
  convenience init() {
    self.init(title: "", URL: nil)
  }
  
  init(title: String?, URL: Foundation.URL?){
    super.init(nibName: nil, bundle: nil)
    self.URL = URL
    self.navTitle = title
  }
  
  init(howToNotificationType: ScreenType)
  {
    super.init(nibName: nil, bundle: nil)
    
    if let ressourceName = howToNotificationType.howToRessourcePathName,
      let url = Bundle.main.path(forResource: ressourceName,
        ofType: "html",
        inDirectory: Config.defaultHTMLHowToDir)
    {
      self.URL = Foundation.URL(fileURLWithPath: url)
    }
    self.navTitle = howToNotificationType.howTitle
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }
  
  //MARK: View Life Cycle
  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.title = navTitle
    
    if let URL = self.URL{
      self.ibWebView.loadRequest(URLRequest(url: URL))
    }
  }
  
  //MARK: Overriding
  override func engagementActivityName() -> String! {
    if (self.URL?.absoluteString == Config.URLs.features){
      return AnalyticsMonitor.Activities.Features
    }
    else{
      return "WebViewController"
    }
  }
}

//MARK: UIWebViewDelegate
extension WebViewController: UIWebViewDelegate {
  
  func webViewDidStartLoad(_ webView: UIWebView) {
    self.ibActivityIndicator.startAnimating()
  }
  
  func webViewDidFinishLoad(_ webView: UIWebView) {
    self.ibActivityIndicator.stopAnimating()
  }
  
  func webView(_ webView: UIWebView, didFailLoadWithError error: Error) {
    self.ibActivityIndicator.stopAnimating()
  }
  
}
