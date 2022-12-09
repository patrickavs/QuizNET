// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let quizElement = try? newJSONDecoder().decode(QuizElement.self, from: jsonData)

import Foundation

// MARK: - QuizElement
struct QuizElement: Codable {
    var results: [Result]
    
    // MARK: - Result
    struct Result: Codable, Identifiable {
        var id = UUID()
        let category: String
        let type: TypeEnum
        let difficulty: Difficulty
        let question, correctAnswer: String
        let incorrectAnswers: [String]
        
        var formattedquestion: AttributedString {
            do {
                return try AttributedString(markdown: question)
            } catch {
                print("Error with formatted question: \(error)")
                return ""
            }
        }
        
        var answers: [Answer] {
            do {
                let correct = [Answer(text: try AttributedString(markdown: correctAnswer), isCorrect: true)]
                let incorrectAnswers = try incorrectAnswers.map { answer in
                    Answer(text: try AttributedString(markdown: answer), isCorrect: false)
                }
                let allAnswers = correct + incorrectAnswers
                return allAnswers.shuffled()
            } catch {
                print("Error setting answers: \(error)")
                return []
            }
        }
        
        enum CodingKeys: String, CodingKey {
               case category, type, difficulty, question
               case correctAnswer = "correct_answer"
               case incorrectAnswers = "incorrect_answers"
           }
    }
}

// MARK: - Difficulty
enum Difficulty: String, Codable, CaseIterable {
    case easy = "easy"
    case medium = "medium"
    case hard = "hard"
}

// MARK: - Type
enum TypeEnum: String, Codable, CaseIterable {
    case boolean = "boolean"
    case multiple = "multiple"
}

// MARK: - Category
enum Category: String, Codable, CaseIterable {
    case General_Knowledge = "General Knowledge"
    case Entertainment_Books = "Entertainment: Books"
    case Entertainment_Film = "Entertainment: Film"
    case Entertainment_Music = "Entertainment: Music"
    case Entertainment_Musicals_Theatres = "Entertainment: Musicals & Theatres"
    case Entertainment_Television = "Entertainment: Television"
    case Entertainment_VideoGames = "Entertainment: Video Games"
    case Entertainment_BoardGames = "Entertainment: Board Games"
    case Science_Nature = "Science & Nature"
    case Science_Computers = "Science: Computers"
    case Science_Mathematics = "Science: Mathematics"
    case Mythology = "Mythology"
    case Sports = "Sports"
    case Geography = "Geography"
    case History = "History"
    case Politics = "Politics"
    case Art = "Art"
    case Celebrities = "Celebrities"
    case Animals = "Animals"
    case Vehicles = "Vehicles"
    case Entertainment_Comics = "Entertainment: Comics"
    case Science_Gadgets = "Science: Gadgets"
    case Entertainment_Japanese_Anime_Manga = "Entertainment: Japanese Anime & Manga"
    case Entertainment_Cartoon_Animations = "Entertainment: Cartoon & Animations"
}

