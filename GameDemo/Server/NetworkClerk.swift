//
//  NetworkClerk.swift
//  GameDemo
//
//  Created by Patrick Alves on 19.11.22.
//

import Foundation
import Combine

public class NetworkClerk {
    var cancellables = Set<AnyCancellable>()
    let model = ModelInterface()
    var category = ""
    var limit = 20
    var difficulty = ""
    
    func getData() {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "quizapi.io"
        components.path = "/api/v1/questions"
        let apiKey = "Hy9Ihl9yPq7oEZoiNr7RaMtdWsBdhfibNzqjfm2p"
        let limit = String(limit)
        let queryItemID = URLQueryItem(name: "apiKey", value: apiKey)
        let queryItemCategory = URLQueryItem(name: "category", value: category)
        let queryItemLimit = URLQueryItem(name: "limit", value: limit)
        let queryItemDifficulty = URLQueryItem(name: "difficulty", value: difficulty)
        let queryItems = [queryItemID, queryItemCategory, queryItemLimit, queryItemDifficulty]
        
        components.queryItems = queryItems
        guard let url = components.url else { return }
        
        URLSession.shared.dataTaskPublisher(for: url)
            .receive(on: RunLoop.main)
            .map(\.data)
            .decode(type: QuizElement.self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
            .sink { completion in
                switch completion {
                case .failure(let error):
                    print("Error: \(error.localizedDescription)")
                case .finished:
                    print("finished")
                }
            } receiveValue: { value in
                let questionModel = QuestionModel(serverData: value)
                let dataStruct = QuestionContainer(questions: questionModel)
                self.model.update(with: dataStruct)
                print(value)
            }
            .store(in: &cancellables)

    }
}
