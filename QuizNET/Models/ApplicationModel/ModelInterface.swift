//
//  ModelInterface.swift
//  GameDemo
//
//  Created by Patrick Alves on 19.11.22.
//

import Foundation
import Combine

typealias dataStructure = QuestionModel?


/// The viewmodel gets the data through this Class
class ModelInterface {
    fileprivate var modelData = DataBase.sharedInstance
    fileprivate var idx = 0
    
    /// This function notifies the viewmodel if the model received the data from the server
    /// - Returns: ObservableObjectPublisher
    func modelNotifier() -> ObservableObjectPublisher
    {
        return DataBase.sharedInstance.objectWillChange
    }
    
    /// This function returns the current index from the array in the model
    /// - Returns: Returns an Integer
    func getIndex() -> Int {
        return idx
    }
    
    /// Notifies if the `@Published` modelChanged-variable in the model changed
    /// - Returns: Returns a boolean
    func modelChanged() -> Bool {
        return DataBase.sharedInstance.modelChanged == true
    }
    
    /// This function returns the first element from the array in the model
    /// - Returns: Returns a QuestionModel-structure
    func getFirst() -> dataStructure!
    {
        idx = 0
        return getGuardedValueFor(index: idx)
    }
    
    /// This function return the next element in the allData-array based on the current index
    /// - Returns: Returns a QuestionModel-structure
    func getNext() -> dataStructure!
    {
        idx += 1
        return getGuardedValueFor(index: idx)
    }
    
    /// This function appends a datastructure-element to the model-array and checks if an error occured as well as inform the others that the model has changed
    /// - Parameter with: quiz-element
    func append(with: dataStructure) {
        if with == nil {
            DataBase.sharedInstance.failure = true
        } else {
            DataBase.sharedInstance.allData.append(with)
        }
        DataBase.sharedInstance.modelChanged = true
    }
    
    /// This function returns the whole data stored in the model-array
    /// - Returns: Returns a datastructure-array
    func getModelData() -> [dataStructure] {
        return DataBase.sharedInstance.allData
    }
    
    /// This function returns a datastructure element provided the given index doesnt exceed the array range
    /// - Parameter index: use the current index
    /// - Returns: Returns a quiz-element
    func getGuardedValueFor(index: Int) -> dataStructure! {
        if index < DataBase.sharedInstance.allData.count {
            return DataBase.sharedInstance.allData[index]
        }
        else {
            return nil
        }
    }
    
    /// This function remove all the data from the model-array
    func removeQuestions() {
        DataBase.sharedInstance.allData.removeAll()
    }
    
    /// Returns the question based on the current index
    /// - Parameter index: index from the model-array
    /// - Returns: Returns an optional String
    func getQuestion(for index: Int) -> String? {
        if DataBase.sharedInstance.allData == [] {
            errorOccured()
            return nil
        } else if index >= DataBase.sharedInstance.allData.count {
            return nil
        }
        
        return DataBase.sharedInstance.allData[index]?.question
    }
    
    /// Sets the `@Published` failure-variable in the model to true that everyone who access this variable knows that an error occured 
    func errorOccured() {
        DataBase.sharedInstance.failure = true
    }
    
    /// The function checks if an error occured
    /// - Returns: Returns a boolean
    func error() -> Bool {
        if DataBase.sharedInstance.failure == true { return true } else { return false }
    }
    
    /// Set the failure-variable in the model to the given parameter value
    /// - Parameter to: The parameter assigned to the failure-variable in the model
    func setError(to: Bool) {
        DataBase.sharedInstance.failure = to
    }
    
    /// Returns the answers based on the current index
    /// - Parameter index: Current index from the model-array
    /// - Returns: Returns an array of AttributedString
    func getAnswers(for index: Int) -> [AttributedString] {
        if index < DataBase.sharedInstance.allData.count && !DataBase.sharedInstance.allData.isEmpty {
            return DataBase.sharedInstance.allData[index]!.answers
        }
        return []
    }
}

/// This Database is the Single Source of Truth
fileprivate class DataBase: ObservableObject {
    static var sharedInstance = DataBase()
    @Published var modelChanged = false
    @Published var failure = false
    
    private init() {}
    
    /// stores the data
    var allData: [dataStructure] = []
}
