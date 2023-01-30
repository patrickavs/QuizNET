//
//  Question.swift
//  GameDemo
//
//  Created by Patrick Alves on 28.09.22.
//

import Foundation

/// Data-Struct for a question
struct QuestionModel: Identifiable, Equatable {
    let id: UUID
    let category: String
    let difficulty: String
    let type: String
    let question: String
    let correctAnswer: AttributedString
    let incorrectAnswers: [String]
    var answers: [AttributedString]
    
    /// saves the serverdata
    /// - Parameter serverData: Data from the server
    init(serverData: QuizElement.Result) {
        self.id = serverData.id
        self.category = serverData.category
        self.difficulty = serverData.difficulty.rawValue
        self.type = serverData.type.rawValue
        self.question = serverData.question
        self.correctAnswer = serverData.correctFormattedAnswer
        self.incorrectAnswers = serverData.incorrectAnswers
        self.answers = serverData.answers
    }
}
