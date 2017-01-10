//
//  RecentUpdatesController.swift
//  Engagement
//
//  Created by Microsoft on 12/02/2016.
//  Copyright © 2016 Microsoft. All rights reserved.
//

import UIKit

/// Recent Updates Controller will display last Azure Mobile Engagement news
class RecentUpdatesController: CenterViewController {
  
  @IBOutlet weak var ibTableView: UITableView!
  
  var dataSource = [RecentUpdate]()
  
  //MARK: Overriding
  override func engagementActivityName() -> String! {
    return AnalyticsMonitor.Activities.RecentUpdates
  }
  
  //MARK: View Life Cycle
  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.title = L10n.tr("menu.recent.product.updates.title")
    
    ibTableView.backgroundColor = UIColor(named: UIColor.Name.secondaryGrey)
    self.ibTableView.separatorStyle = .none
    self.ibTableView.contentInset = UIEdgeInsetsMake(15, 0, 0, 0)
    self.ibTableView.estimatedRowHeight = 100
    self.ibTableView.rowHeight = UITableViewAutomaticDimension
    self.ibTableView.register(UINib(nibName: TextFeedCell.identifier, bundle: nil),
      forCellReuseIdentifier: TextFeedCell.identifier)
    
    UIApplication.showHUD()
    AzMEService.fetchAzMERecentUpdates(forHome: false) { (recentUpdates, error) -> Void in
      UIApplication.dismissHUD()
      self.dataSource = recentUpdates
      self.ibTableView.reloadData()
    }
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
    if let selectedIndex = self.ibTableView.indexPathsForSelectedRows?.first{
      self.ibTableView.deselectRow(at: selectedIndex, animated: true)
    }
    
    UIApplication.setStatusBarStyle(UIStatusBarStyle.lightContent)
  }
}

//MARK: UITableViewDelegate
extension RecentUpdatesController: UITableViewDelegate{
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let updateItem = self.dataSource[indexPath.row]
    
    if let link = updateItem.link, let linkURL = URL(string: link){
      AnalyticsMonitor.Events.RecentUpdates.clickArticle(updateItem.title, URL: link)
      let safariController = AzMESafariController(url: linkURL)
      self.navigationController?.present(safariController,
        animated: true,
        completion: { () -> Void in
          UIApplication.setStatusBarStyle(UIStatusBarStyle.default)
      })
    }
  }
}

//MARK: UITableViewDataSource
extension RecentUpdatesController: UITableViewDataSource{
  func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return self.dataSource.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: TextFeedCell.identifier, for: indexPath) as! TextFeedCell
    
    let updateItem = self.dataSource[indexPath.row]
    
    cell.updateWith(updateItem.title, subTitle: updateItem.pubDate, description: updateItem.description)
    
    return cell
  }
  
}
