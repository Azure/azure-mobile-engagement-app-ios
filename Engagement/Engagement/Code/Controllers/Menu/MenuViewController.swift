//
//  MenuViewController.swift
//  Engagement
//
//  Created by Microsoft on 08/02/2016.
//  Copyright © 2016 Microsoft. All rights reserved.
//

import UIKit

private let kTableLeftMargin: CGFloat = 20
private let kTableHeaderHeight: CGFloat = 25
private let kTableExpandableRow = 3

/// Left Side Menu
class MenuViewController: UIViewController {
  
  @IBOutlet weak var ibTableView: UITableView!
  
  var expendedItems = [MenuItem]()
  var expended = false
  var dataSource = [(sectionName: String, items: [MenuItem])]()
  var currentIndexPath = IndexPath(row: 0, section: 0)
  
  //MARK: View Life Cycle
  override func viewDidLoad() {
    super.viewDidLoad()
    
    //because drawer have to be able to push controller, it is embeded into a UINavContr. Fix with top View Xib and header adjustements
    let header = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 25))
    header.backgroundColor = .white
    ibTableView.tableHeaderView = header
    
    ibTableView.register(UINib(nibName: MenuCell.identifier, bundle: nil),
      forCellReuseIdentifier: MenuCell.identifier)
    
    self.dataSource = MenuItem.defaultDataSoruceFromMenuController(self)
    self.expendedItems = MenuItem.helpfulLinksFromMenuController(self)
    self.ibTableView.selectRow(at: IndexPath(row: 0, section: 0),
      animated: false,
      scrollPosition: UITableViewScrollPosition.top)
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
    ibTableView.selectRow(at: self.currentIndexPath, animated: false, scrollPosition: .middle)
  }
  
  //MARK: Events behaviors
  
  /**
  Open an Internet Link via a SafariViewController
  
  - parameter link: the string URL
  */
  func openLink(_ link: String){
    if let URL = URL(string: link) {
      let controller = AzMESafariController(url: URL)
      self.navigationController?.present(controller, animated: true, completion: nil)
    }
  }
  
  /**
   Expand or collapse Helpful links inside the menu
   */
  func toogleLinks() {
    self.expended = !self.expended
    
    if self.expended == true{
      self.dataSource[1].items.insert(contentsOf: expendedItems, at: kTableExpandableRow)
      self.ibTableView.beginUpdates()
      self.ibTableView.insertRows(at: [IndexPath(row: 3, section: 1),
        IndexPath(row: 4, section: 1),
        IndexPath(row: 5, section: 1),
        IndexPath(row: 6, section: 1),
        IndexPath(row: 7, section: 1)],
        with: .fade)
      self.ibTableView.endUpdates()
      
    }else{
      self.dataSource[1].items.removeSubrange((kTableExpandableRow ..< kTableExpandableRow + expendedItems.count))
      self.ibTableView.beginUpdates()
      self.ibTableView.deleteRows(at: [IndexPath(row: 3, section: 1),
        IndexPath(row: 4, section: 1),
        IndexPath(row: 5, section: 1),
        IndexPath(row: 6, section: 1),
        IndexPath(row: 7, section: 1)],
        with: .fade)
      self.ibTableView.endUpdates()
    }
  }
}

// MARK: - UITableViewDelegate
extension MenuViewController : UITableViewDelegate {
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let menuItem = dataSource[indexPath.section].items[indexPath.row]
    
    if (indexPath == self.currentIndexPath) == false || indexPath.row == kTableExpandableRow || menuItem.isChild == false {
      
      if let selectAction = menuItem.selectedCompletion{
        let cell = tableView.dequeueReusableCell(withIdentifier: MenuCell.identifier, for: indexPath) as! MenuCell
        cell.toggleIndicator()
        selectAction()
      }
      else if let controller = menuItem.initViewController?()
      {
        self.currentIndexPath = indexPath
        self.mm_drawerController.setCenterView(UINavigationController(rootViewController: controller),
          withCloseAnimation: true,
          completion: { [weak self] (bool) in
            UIApplication.checkStatusBarForDrawer(self?.mm_drawerController)
          })
      }
    }else{
      self.closeDrawer()
    }
  }
  
  func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    
    let sectionTitle = dataSource[section].sectionName
    
    guard sectionTitle.isEmpty == false else{
      return nil
    }
    
    let headerView =  UIView(frame: CGRect(x: 0, y: 5, width: self.view.frame.size.width, height: kTableHeaderHeight))
    
    headerView.backgroundColor = UIColor(named: UIColor.Name.secondaryText)
    
    let frame = CGRect(x: kTableLeftMargin,
      y: 0,
      width: headerView.frame.width - kTableLeftMargin,
      height: kTableHeaderHeight)
    
    let label = UILabel(frame: frame)
    label.font = UIFont(named: UIFont.AppFont.Medium, size: 15)
    label.text = sectionTitle
    label.textColor = .white
    headerView.addSubview(label)
    
    return headerView
    
  }
  
  func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    return dataSource[section].sectionName.isEmpty ? 0 : kTableHeaderHeight
  }
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 50
  }
}

// MARK: - UITableViewDataSource
extension MenuViewController : UITableViewDataSource {
  
  func numberOfSections(in tableView: UITableView) -> Int {
    return dataSource.count
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return dataSource[section].items.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let menuItem = dataSource[indexPath.section].items[indexPath.row]
    let cell = tableView.dequeueReusableCell(withIdentifier: MenuCell.identifier, for: indexPath) as! MenuCell
    cell.menuItem = menuItem
    
    if menuItem.separator == true {
      cell.separatorInset = UIEdgeInsets.zero
    }else{
      cell.separatorInset = UIEdgeInsets(top: 0, left: cell.bounds.width, bottom: 0, right: 0)
    }
    return cell
  }
  
  
}
