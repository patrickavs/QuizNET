//
//  ServerData.swift
//  GameDemo
//
//  Created by Patrick Alves on 19.11.22.
//

import Foundation

// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let quiz = try? newJSONDecoder().decode(Quiz.self, from: jsonData)

import Foundation

// MARK: - QuizElement
struct QuizElement: Codable {
    let id: Int
    let question: String
    let quizDescription: JSONNull?
    let answers: Answers
    let multipleCorrectAnswers: String
    let correctAnswers: CorrectAnswers
    let correctAnswer: CorrectAnswer
    let explanation, tip: JSONNull?
    let tags: [Tag]
    let category: Category
    let difficulty: Difficulty

    enum CodingKeys: String, CodingKey {
        case id, question
        case quizDescription = "description"
        case answers
        case multipleCorrectAnswers = "multiple_correct_answers"
        case correctAnswers = "correct_answers"
        case correctAnswer = "correct_answer"
        case explanation, tip, tags, category, difficulty
    }
}

// MARK: - Answers
struct Answers: Codable {
    let answerA, answerB: String
    let answerC, answerD, answerE, answerF: String?

    enum CodingKeys: String, CodingKey {
        case answerA = "answer_a"
        case answerB = "answer_b"
        case answerC = "answer_c"
        case answerD = "answer_d"
        case answerE = "answer_e"
        case answerF = "answer_f"
    }
}

enum Category: String, Codable, CaseIterable {
    case sql = "SQL"
    case kubernetes = "Kubernetes"
    case bash = "BASH"
    case javascript = "JavaScript"
    case docker = "Docker"
    case laravel = "Laravel"
    case linux = "Linux"
    case php = "PHP"
    case html = "HTML"
    case wordPress = "WordPress"
    case devOps = "DevOps"
}

enum CorrectAnswer: String, Codable {
    case answerA = "answer_a"
}

// MARK: - CorrectAnswers
struct CorrectAnswers: Codable {
    let answerACorrect, answerBCorrect, answerCCorrect, answerDCorrect: String
    let answerECorrect, answerFCorrect: String

    enum CodingKeys: String, CodingKey {
        case answerACorrect = "answer_a_correct"
        case answerBCorrect = "answer_b_correct"
        case answerCCorrect = "answer_c_correct"
        case answerDCorrect = "answer_d_correct"
        case answerECorrect = "answer_e_correct"
        case answerFCorrect = "answer_f_correct"
    }
}

enum Difficulty: String, Codable, CaseIterable {
    case easy = "Easy"
    case medium = "Medium"
    case hard = "Hard"
}

// MARK: - Tag
struct Tag: Codable {
    let name: Name
}

enum Name: String, Codable {
    case mySQL = "MySQL"
}

typealias Quiz = [QuizElement]

// MARK: - Encode/decode helpers

class JSONNull: Codable, Hashable {

    public static func == (lhs: JSONNull, rhs: JSONNull) -> Bool {
        return true
    }

    public var hashValue: Int {
        return 0
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(hashValue)
    }

    public init() {}

    public required init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if !container.decodeNil() {
            throw DecodingError.typeMismatch(JSONNull.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for JSONNull"))
        }
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encodeNil()
    }
}
