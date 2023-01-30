//
//  NetworkClerk.swift
//  GameDemo
//
//  Created by Patrick Alves on 19.11.22.
//

import Foundation
import Combine

/// NetworkClerk-Class to to get data from the Server
public class NetworkClerk {
    var cancellables = Set<AnyCancellable>()
    let model = ModelInterface()
    
    /// Function to fetch the serverdata
    /// - Parameters:
    ///   - category: specifies the category for the questions
    ///   - amount: specifiesthe amount of the questions
    ///   - difficulty: specifies the difficulty for the questions
    ///   - type: specifies the type of the questions (boolean, multiple)
    func getData(category: String?, amount: String?, difficulty: String?, type: String?) {
        
        var components = URLComponents()
        components.scheme = "https"
        components.host = "opentdb.com"
        components.path = "/api.php"
        
        
        /// map the current category to the associated number
        var categorytoInt: String? {
            switch category {
            case Category.General_Knowledge.rawValue:
                return "9"
            case Category.Entertainment_Books.rawValue:
                return "10"
            case Category.Entertainment_Film.rawValue:
                return "11"
            case Category.Entertainment_Music.rawValue:
                return "12"
            case Category.Entertainment_Musicals_Theatres.rawValue:
                return "13"
            case Category.Entertainment_Television.rawValue:
                return "14"
            case Category.Entertainment_VideoGames.rawValue:
                return "15"
            case Category.Entertainment_BoardGames.rawValue:
                return "16"
            case Category.Science_Nature.rawValue:
                return "17"
            case Category.Science_Computers.rawValue:
                return "18"
            case Category.Science_Mathematics.rawValue:
                return "19"
            case Category.Mythology.rawValue:
                return "20"
            case Category.Sports.rawValue:
                return "21"
            case Category.Geography.rawValue:
                return "22"
            case Category.History.rawValue:
                return "23"
            case Category.Politics.rawValue:
                return "24"
            case Category.Art.rawValue:
                return "25"
            case Category.Celebrities.rawValue:
                return "26"
            case Category.Animals.rawValue:
                return "27"
            case Category.Vehicles.rawValue:
                return "28"
            case Category.Entertainment_Comics.rawValue:
                return "29"
            case Category.Science_Gadgets.rawValue:
                return "30"
            case Category.Entertainment_Japanese_Anime_Manga.rawValue:
                return "31"
            case Category.Entertainment_Cartoon_Animations.rawValue:
                return "32"
            default:
                return ""
            }
        }
        
        let queryItemCategory = URLQueryItem(name: "category", value: categorytoInt)
        let queryItemLimit = URLQueryItem(name: "amount", value: amount)
        let queryItemDifficulty = URLQueryItem(name: "difficulty", value: difficulty)
        let queryItemType = URLQueryItem(name: "type", value: type)
        let queryItems = [queryItemCategory, queryItemLimit, queryItemDifficulty, queryItemType]
        
        components.queryItems = queryItems
        
        guard let url = components.url else { print("Failure"); return}
        print(url)
        
        URLSession.shared.dataTaskPublisher(for: url)
            .receive(on: RunLoop.main)
            .map{$0.data}
            .decode(type: QuizElement.self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
            .sink { completion in
                switch completion {
                case .failure(let error):
                    print("Error: \(error.localizedDescription)")
                case .finished:
                    print("finished")
                    print(self.model.getModelData())
                    if self.model.getModelData().isEmpty {
                        self.model.errorOccured()
                    }
                }
            } receiveValue: { value in
                for i in value.results {
                    let questionModel = QuestionModel(serverData: i)
                    self.model.append(with: questionModel)
                }
            }
            .store(in: &cancellables)
    }
}
