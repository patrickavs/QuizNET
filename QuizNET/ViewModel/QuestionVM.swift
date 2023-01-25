//
//  QuestionVM.swift
//  GameDemo
//
//  Created by Patrick Alves on 28.09.22.
//

import Foundation
import Combine

/// Observed-Class for handling the questions
class QuestionVM: ObservableObject {
    @Published var questions: [QuestionDataVm] = []
    let networkClerk = NetworkClerk()
    fileprivate var subscription : AnyCancellable!
    @Published var category: String = Category.General_Knowledge.rawValue
    @Published var amount: String = "1"
    @Published var difficulty: String = Difficulty.easy.rawValue
    @Published var type: String = TypeEnum.boolean.rawValue
    @Published var canPlay = false
    @Published var index = 0
    @Published var selectedAnswer = false
    @Published var error = false
    @Published var reachedEnd = false
    @Published var progress: CGFloat = 0
    @Published var score = 0
    @Published var rightAnswer = false
    @Published var wrongAnswer = false
    
    let model = ModelInterface()
    
    init() {
        model.removeQuestions()
        subscription = self.model.modelNotifier().sink {
            print("model changed")
            
            if (!self.model.getModelData().isEmpty && self.questions.isEmpty) {
                var currentQuestion: dataStructure?
                currentQuestion = self.model.getFirst()
                print("VM-DATA: \(String(describing: currentQuestion))")
                while (currentQuestion != nil)
                {
                    self.questions.append(QuestionDataVm(with: currentQuestion!!))
                    currentQuestion = self.model.getNext()
                }
                
                if self.model.error() {
                    self.canPlay = false
                    return
                } else {
                    self.canPlay = true
                    return
                }
            } else {
                if self.model.getModelData().isEmpty {
                    self.errorOccured()
                    self.canPlay = false
                    return
                }
                self.canPlay = true
                return
            }
        }
    }
    
    /// remove all the data at first and then start fetching the next questions from the server. This data will be saved in the database.
    func setQuestions() {
        model.removeQuestions()
        questions.removeAll()
        networkClerk.getData(category: category, amount: amount, difficulty: difficulty, type: type)
    }
    
    /// get the current formatted question
    func getQuestion() -> AttributedString {
        do {
            return try AttributedString(markdown: model.getQuestion(for: index) ?? "Error")
        } catch {
            return AttributedString(stringLiteral: "Couldnt load question")
        }
    }
    
    /// get the next formatted question
    func getNextQuestion() {
        selectedAnswer = false
        if index+1 >= model.getModelData().count-1 {
            reachedEnd = true
            index = model.getModelData().count-1
        } else {
            index += 1
        }
        progress = CGFloat(Double(index+1) / Double(amount)! * 350)
        wrongAnswer = false
        rightAnswer = false
    }
    
    /// get all the answers of a single question
    func getAnswers() -> [AttributedString] {
        if model.getAnswers(for: index) == [] {
            return []
        }
        return model.getAnswers(for: index)
    }
    
    func save(player1: String, player2: String) {
        
    }
    
    /// set the viewmodel´s error property to true
    func errorOccured() {
        self.error = true
    }
    
    /// set error property both in the viewmodel and in the model to false
    func resetError() {
        self.error = false
        model.setError(to: false)
    }
    
    /// select the tapped Answer and check if the selected answer is correct or incorrect
    func selectAnswer(answer: AttributedString) {
        if answer == model.getModelData()[index]?.correctAnswer {
            selectedAnswer = true
            score += 1
            rightAnswer = true
        } else {
            selectedAnswer = true
            rightAnswer = false
        }
    }
    
    /// reset all of the viewmodel´s properties
    func resetAll() {
        canPlay = false
        reachedEnd = false
        index = 0
        progress = 0
        selectedAnswer = false
        score = 0
        rightAnswer = false
        wrongAnswer = false
        category = Category.General_Knowledge.rawValue
        amount = "1"
        difficulty = Difficulty.easy.rawValue
        type = TypeEnum.boolean.rawValue
    }
}

/// Viewmodel's datastructure
struct QuestionDataVm: Identifiable, Hashable {
    let id: UUID
    let questionVm: String
    let correctAnswer: AttributedString
    let incorrectAnswers: [String]
    let answers: [AttributedString]
    
    init(with: QuestionModel) {
        self.id = with.id
        self.questionVm = with.question
        self.correctAnswer = with.correctAnswer
        self.incorrectAnswers = with.incorrectAnswers
        self.answers = with.answers
    }
}
