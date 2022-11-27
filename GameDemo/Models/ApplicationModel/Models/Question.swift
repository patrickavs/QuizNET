//
//  Question.swift
//  GameDemo
//
//  Created by Patrick Alves on 28.09.22.
//

import Foundation

struct QuestionContainer {
    
    var questionData: QuestionModel
    
    init(questions: QuestionModel) {
        self.questionData = questions
    }
    
    mutating func updateQuestions(newQuestions: QuestionModel) {
        self.questionData = newQuestions
    }
}

struct QuestionModel: Identifiable {
    let id: Int
    let question: String
    let quizDescription: JSONNull?
    let answers: Answers
    let multipleCorrectAnswers: String
    let correctAnswers: CorrectAnswers
    let correctAnswer: CorrectAnswer
    let explanation: JSONNull?
    let tip: JSONNull?
    let tags: [Tag]
    let category: Category
    let difficulty: Difficulty
    
    init(serverData: QuizElement) {
        id = serverData.id
        question = serverData.question
        quizDescription = serverData.quizDescription
        answers = serverData.answers
        multipleCorrectAnswers = serverData.multipleCorrectAnswers
        correctAnswers = serverData.correctAnswers
        correctAnswer = serverData.correctAnswer
        explanation = serverData.explanation
        tags = serverData.tags
        category = serverData.category
        difficulty = serverData.difficulty
        tip = serverData.tip
    }
}
