//
//  QuestionVM.swift
//  GameDemo
//
//  Created by Patrick Alves on 28.09.22.
//

import Foundation
import Combine
import MultipeerConnectivity

class QuestionVM: ObservableObject {
    @Published var questions: [QuestionDataVm] = []
    let networkClerk = NetworkClerk()
    fileprivate var subscription : AnyCancellable!
    @Published var category: String = ""
    @Published var limit = ""
    @Published var difficulty: String = ""
    let model = ModelInterface()
    
    init() {
        subscription = ModelInterface().modelNotifier().sink {
            self.setQuestions()
        }
    }
    
    func setQuestions() {
        var currentQuestion = model.getFirst()
        while (currentQuestion != nil) {
            networkClerk.category = self.category
            networkClerk.limit = Int(self.limit) ?? 20
            networkClerk.difficulty = self.difficulty
            networkClerk.getData()
            questions.append(QuestionDataVm(with: currentQuestion!))
            currentQuestion = model.getNext()
        }
    }
    
    func save(player1: String, player2: String) {
        
    }
}


struct QuestionDataVm {
    let categoryVM: Category
    let questionVM: String
    let answerVM: Answers
    
    init(with: QuestionContainer) {
        categoryVM = with.questionData.category
        questionVM = with.questionData.question
        answerVM = with.questionData.answers
    }
}
