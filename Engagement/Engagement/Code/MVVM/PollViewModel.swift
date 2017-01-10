//
//  PollViewModel.swift
//  Engagement
//
//  Created by Microsoft on 23/02/2016.
//  Copyright © 2016 Microsoft. All rights reserved.
//

import Foundation

/**
 *  Poll Choice ViewModel abstraction
 */
struct PollChoiceViewModel{
  
  var choiceId: String
  var title: String
  
  /**
   Create an array of Choice ViewModels from a AZReachPollQuestion object
   
   - parameter fromQuestion: AEReachPollQuestion object
   
   - returns: PollChoice View Model
   */
  static func choices(_ fromQuestion: AEReachPollQuestion) -> [PollChoiceViewModel]{
    var choices = [PollChoiceViewModel]()
    
    for choice in fromQuestion.choices {
      if let choicePoll = choice as? AEReachPollChoice {
        choices.append(PollChoiceViewModel(choiceId: choicePoll.choiceId, title: choicePoll.title))
      }
    }
    return choices
  }
}

/**
 *  Poll Question ViewModel abstraction
 */
struct PollQuestionViewModel{
  var questionId: String
  var title: String
  var choices = [PollChoiceViewModel]()
  
  init(questionId: String, title: String, choices: [PollChoiceViewModel]){
    self.questionId = questionId
    self.title = title
    self.choices = choices
  }
  
  /**
   Create a poll question View model from an AzME AEReachPollQuestion object
   
   - parameter fromPollQuestion: the AEReachPollQuestion element
   
   - returns: PollQuestionViewModel object
   */
  init(fromPollQuestion: AEReachPollQuestion){
    self.questionId = fromPollQuestion.questionId
    self.title = fromPollQuestion.title
    self.choices = PollChoiceViewModel.choices(fromPollQuestion)
  }
}

/**
 *  Represent a ReachPoll abstraction
 */
struct PollViewModel {
  
  var title = ""
  var actionTitle = ""
  var exitTitle = ""
  var body = ""
  var questions = [PollQuestionViewModel]()
  
  var action: (() -> Void)?
  
  init(){}
  
  init(fromPoll reachPoll: AEReachPoll){
    if let titleValue = reachPoll.title {
      self.title = titleValue
    }
    if let actionValue = reachPoll.actionLabel {
      self.actionTitle = actionValue
    }
    if let exitValue = reachPoll.exitLabel {
      self.exitTitle = exitValue
    }
    if let bodyValue = reachPoll.body {
      self.body = bodyValue
    }
    
    for question in reachPoll.questions {
      if let questionPoll = question as? AEReachPollQuestion {
        self.questions.append(PollQuestionViewModel(fromPollQuestion: questionPoll))
      }
    }
  }
}
