//
//  QuestionVM.swift
//  GameDemo
//
//  Created by Patrick Alves on 28.09.22.
//

import Foundation
import Combine

class QuestionVM: ObservableObject {
    @Published var questions: [QuestionDataVm] = []
    let networkClerk = NetworkClerk()
    fileprivate var subscription : AnyCancellable!
    @Published var category: String = Category.General_Knowledge.rawValue
    @Published var amount: String = "1"
    @Published var difficulty: String = Difficulty.easy.rawValue
    @Published var type: String = TypeEnum.boolean.rawValue
    let model = ModelInterface()
    
    init() {
        subscription = ModelInterface().modelNotifier().sink {
            self.model.getModelData()
        }
    }
    
    func setQuestions() {
        questions = []
        networkClerk.getData(category: category, amount: amount, difficulty: difficulty, type: type)
        var currentQuestion: dataStructure?
        if model.readyToUse() {
            currentQuestion = self.model.getFirst()
        }
        print("VM-DATA: \(String(describing: currentQuestion))")
        while (currentQuestion != nil)
        {
            self.questions.append(QuestionDataVm(with: currentQuestion!))
            currentQuestion = self.model.getNext()
        }
    }
    
    func getQuestion(index: Int) -> String {
        return questions[index].questionVm
    }
    
    func save(player1: String, player2: String) {
        
    }
    
    fileprivate func setUpQuestions()
    {
        questions = []
    }
    
    func saveQuestions() {
        
    }
}


struct QuestionDataVm: Identifiable {
    let id: UUID
    let questionVm: String
    let correctAnswer: String
    let incorrectAnswers: [String]
    
    init(with: QuestionModel) {
        self.id = with.id
        self.questionVm = with.question
        self.correctAnswer = with.correctAnswer
        self.incorrectAnswers = with.incorrectAnswers
    }
}
