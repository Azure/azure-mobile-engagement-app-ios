//
//  PollViewController.swift
//  Engagement
//
//  Created by Microsoft on 22/02/2016.
//  Copyright © 2016 Microsoft. All rights reserved.
//

import UIKit

/// Poll ViewController for local and AzME SDK
class PollViewController: AEPollViewController {
  
  @IBOutlet weak var ibDismissButton: AzButton!
  @IBOutlet weak var ibActionButton: AzButton!
  @IBOutlet weak var ibTableView: UITableView!
  @IBOutlet weak var ibNavBar: UINavigationBar!
  @IBOutlet weak var ibcNavBarHeight: NSLayoutConstraint!
  @IBOutlet weak var ibNavBarTitleItem: UINavigationItem!
  
  fileprivate var isFake = false
  fileprivate var hasBody = false
  fileprivate var selectedChoices = [String : (choiceId: String, indexPath: IndexPath)]()
  
  var reachPollViewModel : PollViewModel?
  
  //MARK: Initialization
  override init!(poll: AEReachPoll!) {
    super.init(nibName: "PollViewController", bundle: nil)
    self.poll = poll
    self.reachPollViewModel = PollViewModel(fromPoll: poll)
  }
  
  init(pollModel: PollViewModel){
    super.init(nibName: "PollViewController", bundle: nil)
    self.reachPollViewModel = pollModel
    self.isFake = true
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }
  
  //MARK: View Life Cycle
  override func viewDidLoad() {
    super.viewDidLoad()
    if self.isFake == true{
      self.ibcNavBarHeight.constant = 0
      self.title = self.reachPollViewModel?.title
    }
    self.ibNavBarTitleItem.title = self.reachPollViewModel?.title
    self.view.backgroundColor = UIColor(named: UIColor.Name.primaryThemeLight)
    
    self.ibTableView.backgroundColor = UIColor(named: UIColor.Name.primaryThemeLight)
    self.ibTableView.rowHeight = UITableViewAutomaticDimension
    self.ibTableView.estimatedRowHeight = 60
    self.ibTableView.allowsMultipleSelection = true
    let headerView = SimpleHeaderLabel(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 20))
    let attributedString = NSMutableAttributedString()
    if self.isFake == true {
      attributedString.append(NSAttributedString(string: "A sample poll/survey notification\n\n",
        attributes: [NSFontAttributeName : UIFont(named: UIFont.AppFont.Bold, size: 13)]))
    }
    if let body = self.reachPollViewModel?.body{
      attributedString.append(NSAttributedString(string: body,
        attributes: [NSFontAttributeName : UIFont(named: UIFont.AppFont.Regular, size: 22)]))
    }
    headerView.updateAttributed(attributedString, headerType: HeaderViewType.tableHeader)
    self.ibTableView.setAndLayoutTableHeaderView(headerView)
    
    self.ibTableView.register(UINib(nibName: PollChoiceCell.identifier, bundle: nil),
      forCellReuseIdentifier: PollChoiceCell.identifier)
    self.ibTableView.tableFooterView = UIView()
    self.ibTableView.separatorStyle = .none
    
    self.hasBody = self.reachPollViewModel?.body.isEmpty ?? false
    
    if let exitTitle = self.reachPollViewModel?.exitTitle, exitTitle.isEmpty == false {
      ibDismissButton.setTitle(exitTitle.uppercased(), for: UIControlState())
    } else {
      ibDismissButton.removeFromSuperview()
    }
    if let actionTitle = self.reachPollViewModel?.actionTitle, actionTitle.isEmpty == false {
      ibActionButton.setTitle(actionTitle.uppercased(), for: UIControlState())
    } else {
      ibActionButton.removeFromSuperview()
    }
    
    self.ibActionButton.setBackgroundImage(UIColor.imageWithColor(UIColor(named: UIColor.Name.secondaryPurple).withAlphaComponent(0.6)),
      for: UIControlState.disabled)
    self.ibActionButton.setBackgroundImage(UIColor.imageWithColor(UIColor(named: UIColor.Name.secondaryPurple)),
      for: UIControlState())
    self.ibDismissButton.setBackgroundImage(UIColor.imageWithColor(UIColor(named: UIColor.Name.primaryTheme)),
      for: UIControlState())
    
    updateActionButtonState()
    // Do any additional setup after loading the view.
  }
  
  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    
    self.ibTableView.layoutTableHeaderView()
  }
  
  //MARK: Actions
  @IBAction func didTapExitButton(_ sender: AnyObject) {
    if isFake == true{
      self.dismiss(animated: true, completion: nil)
    }
    else{
      self.exitButtonClicked(sender)
    }
  }
  
  @IBAction func didTapActionButton(_ sender: AnyObject) {
    if self.isFake == true{
      self.reachPollViewModel?.action?()
      
    }
    else{
      var answers = [String : String]()
      
      for (key, tupleChoice) in self.selectedChoices{
        answers[key] = tupleChoice.choiceId
      }
      self.submitAnswers(answers)
      DeepLinkHelper.presentViewController(SuccessPollViewController(), animated: false)
    }
  }
  
  /**
   Update the state of the action button.
   Button is disable when not all question have a choice
   */
  func updateActionButtonState(){
    self.ibActionButton.isEnabled = (self.selectedChoices.count == self.reachPollViewModel?.questions.count && self.selectedChoices.count > 0)
  }
  
  /**
   Retrieve the correct choice ViewModel at index
   
   - parameter fromIndex: the data source index path
   
   - returns: a PollChoiceViewModel
   */
  func choice(_ fromIndex: IndexPath) -> PollChoiceViewModel?{
    
    if let question = self.question(fromIndex){
      return question.choices[fromIndex.row]
    }
    return nil
  }
  
  /**
   Retrieve the correct question ViewModel at index
   
   - parameter fromIndex: the data source index path
   
   - returns: a PollQuestionViewModel
   */
  func question(_ fromIndex: IndexPath) -> PollQuestionViewModel?{
    return self.reachPollViewModel?.questions[fromIndex.section]
  }
  
}

//MARK: UITableViewDataSource
extension PollViewController: UITableViewDataSource{
  func numberOfSections(in tableView: UITableView) -> Int {
    return self.reachPollViewModel?.questions.count ?? 0
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    if let question = self.reachPollViewModel?.questions[section]{
      return question.choices.count
    }
    return 0
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: PollChoiceCell.identifier, for: indexPath) as! PollChoiceCell
    
    //retrieve choice, update title
    if let choice = self.choice(indexPath){
      cell.update(choice.title)
    }
    
    return cell
  }
}

//MARK: UITableViewDelegate
extension PollViewController: UITableViewDelegate{
  
  func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
    cell.backgroundColor = .clear
  }
  
  func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    
    let headerView = SimpleHeaderLabel(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 30))
    
    if let question = self.question(IndexPath(row: 0, section: section)){
      headerView.update(UIFont(named: UIFont.AppFont.Bold, size: 18),
        mainTitle: question.title,
        headerType: HeaderViewType.sectionHeader)
    }
    
    return headerView
  }
  
  func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    if let question = self.question(IndexPath(row: 0, section: section)){
      return SimpleHeaderLabel.headerHeight(UIFont(named: UIFont.AppFont.Bold, size: 18),
        forTitle: question.title,
        insideWidth: self.view.frame.size.width,
        headerType: HeaderViewType.sectionHeader)
    }
    
    return 0.1
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    if let question = self.question(indexPath), let choice = self.choice(indexPath){
      
      if let choiceTuple = (self.selectedChoices[question.questionId]){
        
        if choiceTuple.indexPath != indexPath{
          tableView.deselectRow(at: choiceTuple.indexPath, animated: true)
          self.selectedChoices[question.questionId] = (choice.choiceId, indexPath)
        }
        
      }else{
        self.selectedChoices[question.questionId] = (choice.choiceId, indexPath)
      }
    }
    updateActionButtonState()
  }
}
