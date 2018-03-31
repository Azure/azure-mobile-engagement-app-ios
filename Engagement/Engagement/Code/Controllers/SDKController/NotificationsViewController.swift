//
//  NotificationsViewController.swift
//  Engagement
//
//  Created by Microsoft on 15/02/2016.
//  Copyright © 2016 Microsoft. All rights reserved.
//

import UIKit

/*
This View Controller class is used for all Notifications demonstration scenarios.
*/
class NotificationsViewController: CenterViewController {
  
  @IBOutlet weak var ibTableView: UITableView!
  @IBOutlet weak var ibHowToButton: UIButton!
  
  var notificationScreen: NotificationScreen?
  var screenType: ScreenType?
  
  //MARK: Initialization
  init(notifScreen: ScreenType){
    self.screenType = notifScreen
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }
  
  //MARK: Overriding
  override func engagementActivityName() -> String! {
    if let screenType = self.screenType{
      return AnalyticsMonitor.Activities.ActivitiesExtras.notificationExtraValueForType(screenType)
    }
    return "NotificationsViewController"
  }
  
  //MARK: View Life Cycle
  override func viewDidLoad() {
    super.viewDidLoad()
    
    if hasPushEnabled() == false {
      let settings = UIUserNotificationSettings(types: [UIUserNotificationType.alert,
        UIUserNotificationType.badge,
        UIUserNotificationType.sound],
        categories: nil)
      UIApplication.shared.registerUserNotificationSettings(settings)
      UIApplication.shared.registerForRemoteNotifications()
      self.dismiss(animated: true, completion: {});
    }
    
    self.view.backgroundColor = UIColor(named: UIColor.Name.primaryTheme)
    
    self.ibHowToButton.backgroundColor = UIColor(named: UIColor.Name.primaryThemeLight)
    self.ibHowToButton.titleLabel?.font = UIFont(named: UIFont.AppFont.Regular, size: 15)
    self.ibHowToButton.setTitle(L10n.tr("out.of.app.push.notifications.footer.text"), for: UIControlState())
    self.ibHowToButton.titleLabel?.numberOfLines = 0
    self.ibHowToButton.titleLabel?.textAlignment = .center
    
    self.ibTableView.separatorStyle = .singleLine
    self.ibTableView.separatorColor = UIColor.white.withAlphaComponent(0.4)
    self.ibTableView.separatorInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
    self.ibTableView.backgroundColor = UIColor(named: UIColor.Name.primaryThemeLight)
    self.ibTableView.allowsSelection = false
    self.ibTableView.rowHeight = UITableViewAutomaticDimension
    self.ibTableView.estimatedRowHeight = 100
    self.ibTableView.register(UINib(nibName: NotifiActionCell.identifier, bundle: nil),
      forCellReuseIdentifier: NotifiActionCell.identifier)
    
    let footerView = SimpleHeaderLabel(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 20))
    footerView.update(UIFont(named: UIFont.AppFont.Bold, size: 13),
      mainTitle: self.screenType?.footerLabelTitle,
      headerType: HeaderViewType.tableHeader)
    self.ibTableView.setAndLayoutTableFooterView(footerView)
    
    if let screenType = self.screenType{
      self.notificationScreen = NotificationScreen(rootController: self, screenType: screenType)
      self.title = self.screenType?.maintTitle
    }
    
    let headerView = NotifTableHeader()
    headerView.update(self.notificationScreen?.screenType.image,
      mainTitle: self.notificationScreen?.screenType.message)
    self.ibTableView.setAndLayoutTableHeaderView(headerView)
    self.ibTableView.reloadData()
  }
  
  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    
    self.ibTableView.layoutTableHeaderView()
    self.ibTableView.layoutTableFooterView()
  }
  
  @IBAction func didHowToButtonTap(_ sender: AnyObject) {
    if let screenType = self.screenType {
      let webController = WebViewController(howToNotificationType: screenType)
      self.navigationController?.pushViewController(webController, animated: true)
    }
  }
  
  func hasPushEnabled() -> Bool {
    if UIApplication.shared.responds(to: #selector(getter: UIApplication.currentUserNotificationSettings)) == true {
      let settings = UIApplication.shared.currentUserNotificationSettings
      if (settings?.types.contains(.alert) == true){
        return true
      }
    }
    return false;
  }
  
}

//MARK: UITableViewDataSource
extension NotificationsViewController: UITableViewDataSource{
  func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    if let nbItems = self.notificationScreen?.dataSource?.count{
      return nbItems
    }
    return 0
  }
  
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
    let cell = tableView.dequeueReusableCell(withIdentifier: NotifiActionCell.identifier, for: indexPath) as! NotifiActionCell
    
    if let notificationItem = self.notificationScreen?.dataSource?[indexPath.row]{
      cell.update(notificationItem, index: indexPath, delegate: self)
    }
    if let count = self.notificationScreen?.dataSource?.count{
      if (indexPath.row == count - 1) {
        cell.separatorInset = UIEdgeInsetsMake(0, cell.bounds.size.width, 0, 0);
      }
    }
    cell.backgroundColor = .clear
    return cell
  }
}

//MARK: NotifActionDelegate
extension NotificationsViewController: NotifActionDelegate {
  
  func didTapButton(_ atIndex: IndexPath?) {
    if let index = atIndex, let notificationItem = self.notificationScreen?.dataSource?[index.row]{
      notificationItem.action()
    }
  }
  
}
