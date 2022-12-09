//
//  Question.swift
//  GameDemo
//
//  Created by Patrick Alves on 28.09.22.
//

import Foundation

/*struct QuestionContainer {
    let id: UUID
    var questionData: QuestionModel
    
    init(questions: QuestionModel) {
        self.questionData = questions
        self.id = questions.id
    }
    
    mutating func updateQuestions(newQuestions: QuestionModel) {
        self.questionData = newQuestions
    }
}*/

struct QuestionModel: Identifiable {
    let id: UUID
    let category: String
    let difficulty: String
    let type: String
    let question: String
    let correctAnswer: String
    let incorrectAnswers: [String]
    
    init(serverData: QuizElement.Result) {
        self.id = serverData.id
        self.category = serverData.category
        self.difficulty = serverData.difficulty.rawValue
        self.type = serverData.type.rawValue
        self.question = serverData.question
        self.correctAnswer = serverData.correctAnswer
        self.incorrectAnswers = serverData.incorrectAnswers
    }
}

struct Answer {
    let text: AttributedString
    let isCorrect: Bool
}
