//
//  HomeViewController.swift
//  Engagement
//
//  Created by Microsoft on 10/02/2016.
//  Copyright © 2016 Microsoft. All rights reserved.
//

import UIKit
import SafariServices

//MARK: HomeViewController
class HomeViewController: CenterViewController {
  
  fileprivate let kHeaderHeight = 50
  
  @IBOutlet weak var ibSubTitle: UILabel!
  @IBOutlet weak var ibMainTitle: UILabel!
  @IBOutlet weak var ibTopView: UIView!
  @IBOutlet weak var ibTableView: UITableView!
  @IBOutlet weak var ibLogo: UIImageView!
  
  var dataSource = HomeDataSource()
  
  //MARK: Overriding
  override func engagementActivityName() -> String! {
    return AnalyticsMonitor.Activities.Home
  }
  
  //MARK: View Life Cycle
  override func viewDidLoad()
  {
    super.viewDidLoad()
    
    self.ibMainTitle.text = L10n.tr("application.name")
    self.ibSubTitle.text = L10n.tr("home.subtitle")
    
    ibMainTitle.font = UIFont(named: UIFont.AppFont.Bold, size: 20)
    ibSubTitle.font = UIFont(named: UIFont.AppFont.Medium, size: 14)
    
    let image = AzIcon.iconLogoAzme(85).image(with: CGSize(width: 60, height: 85))
    ibLogo.image = image?.withRenderingMode(.alwaysTemplate)
    ibLogo.tintColor = .white
    
    ibTopView.backgroundColor = UIColor(named: UIColor.Name.primaryTheme)
    ibTableView.alwaysBounceVertical = false
    ibTableView.separatorStyle = .none
    ibTableView.rowHeight = UITableViewAutomaticDimension
    ibTableView.estimatedRowHeight = 60
    ibTableView.register(UINib(nibName: TextFeedCell.identifier, bundle: nil),
      forCellReuseIdentifier: TextFeedCell.identifier)
    ibTableView.register(UINib(nibName: HighlightCell.identifier, bundle: nil),
      forCellReuseIdentifier: HighlightCell.identifier)
    
    self.reloadData()
    self.changeBackgroundAccordingToOffset()
  }
  
  //MARK: Private methods
  
  /**
  Reload current data like recent updates
  Note : _be sure to empty the dataSource if a refreshControl is going to be set_
  */
  fileprivate func reloadData(){
    UIApplication.showHUD()
    AzMEService.fetchAzMERecentUpdates(forHome: true) { (channels, error) -> Void in
      UIApplication.dismissHUD()
      
      let sectionUpdates = HomeSection(title: L10n.tr("home.recent.updates.title"),
        titleColor: UIColor(named: UIColor.Name.primaryTheme),
        bgColor: UIColor(named: UIColor.Name.secondaryGrey),
        buttonTitle: L10n.tr("home.recent.updates.view.all"),
        action: {
          
      })
      
      self.dataSource.sections.insert((sectionUpdates, channels), at: 0)
      self.ibTableView.beginUpdates()
      self.ibTableView.insertSections(IndexSet(integer: 0),
        with: UITableViewRowAnimation.fade)
      self.ibTableView.endUpdates()
    }
  }
  
  /**
   Change the tableview background color according to its offset.
   This enable the behavior to have the tableFooterView with an "infinite" height (same colors)
   */
  fileprivate func changeBackgroundAccordingToOffset(){
    if ibTableView.contentOffset.y < 0{
      self.ibTableView.backgroundColor = UIColor(named: UIColor.Name.secondaryGrey)
    }else{
      self.ibTableView.backgroundColor = UIColor(named: UIColor.Name.secondaryOrange)
    }
  }
}

//MARK: UIScrollViewDelegate
extension HomeViewController: UIScrollViewDelegate{
  func scrollViewDidScroll(_ scrollView: UIScrollView) {
    self.changeBackgroundAccordingToOffset()
  }
}

//MARK: UITableViewDataSource
extension HomeViewController: UITableViewDataSource {
  func numberOfSections(in tableView: UITableView) -> Int {
    return dataSource.sections.count
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return dataSource.sections[section].items.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
    if let channel = dataSource.sections[indexPath.section].items[indexPath.row] as? RecentUpdate{
      let cell = tableView.dequeueReusableCell(withIdentifier: TextFeedCell.identifier, for: indexPath) as! TextFeedCell
      cell.updateWith(channel.title, subTitle: channel.pubDate, description: channel.description)
      
      return cell
    }
    else if let highligthTitle = dataSource.sections[indexPath.section].items[indexPath.row] as? String{
      let cell = tableView.dequeueReusableCell(withIdentifier: HighlightCell.identifier, for: indexPath) as! HighlightCell
      
      cell.updateWith(highligthTitle)
      
      return cell
    }
    return UITableViewCell()
    
  }
}

//MARK: UITableViewDelegate
extension HomeViewController: UITableViewDelegate {
  
  func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
    return indexPath.section != 1
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
    tableView.deselectRow(at: indexPath, animated: true)
    
    //open link
    if let channel = dataSource.sections[indexPath.section].items[indexPath.row] as? RecentUpdate,
      let channelLink = channel.link
    {
      AnalyticsMonitor.Events.Home.clickArticleHome(channel.title, URL: channelLink)
      let webController = AzMESafariController(url: URL(string: channelLink)!)
      webController.delegate = self
      
      self.navigationController?.present(webController, animated: true, completion: { () -> Void in
        UIApplication.setStatusBarStyle(.default)
      })
    }
    
  }
  
  func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
    return 1
  }
  
  func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    let headerView = FeedHeader(frame: CGRect(x: 0, y: 0, width: Int(self.view.frame.size.width), height: kHeaderHeight))
    
    let section =  dataSource.sections[section].section
    
    headerView.updateWith(section.title,
      buttonTitle: section.buttonTitle,
      action: { [weak self] () -> Void in
        AnalyticsMonitor.sendActivityNamed(AnalyticsMonitor.Events.Home.viewAllUpdates, extras: nil)
        self?.navigationController?.pushViewController(RecentUpdatesController(), animated: true)
      },
      bgColor: section.bgColor,
      titleColor: section.titleColor)
    
    return headerView
    
  }
  
  func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    return CGFloat(kHeaderHeight)
  }
  
}

//MARK: SFSafariViewControllerDelegate
extension HomeViewController: SFSafariViewControllerDelegate{
  func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
    UIApplication.setStatusBarStyle(.lightContent)
  }
}
