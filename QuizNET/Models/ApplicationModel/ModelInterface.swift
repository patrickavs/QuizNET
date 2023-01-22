//
//  ModelInterface.swift
//  GameDemo
//
//  Created by Patrick Alves on 19.11.22.
//

import Foundation
import Combine

typealias dataStructure = QuestionModel?


class ModelInterface {
    fileprivate var modelData = DataBase.sharedInstance
    fileprivate var idx = 0
    
    func modelNotifier() -> ObservableObjectPublisher
    {
        return DataBase.sharedInstance.objectWillChange
    }
    
    func getIndex() -> Int {
        return idx
    }
    
    func modelChanged() -> Bool {
        return DataBase.sharedInstance.modelChanged == true
    }
    
    func getFirst() -> dataStructure!
    {
        idx = 0
        return getGuardedValueFor(index: idx)
    }
    
    func getNext() -> dataStructure!
    {
        idx += 1
        return getGuardedValueFor(index: idx)
    }
    
    func append(with: dataStructure) {
        if with == nil {
            DataBase.sharedInstance.failure = true
        } else {
            DataBase.sharedInstance.allData.append(with)
        }
        DataBase.sharedInstance.modelChanged = true
    }
    
    func getModelData() -> [dataStructure] {
        return DataBase.sharedInstance.allData
    }
    
    func getGuardedValueFor(index: Int) -> dataStructure! {
        if index < DataBase.sharedInstance.allData.count {
            return DataBase.sharedInstance.allData[index]
        }
        else {
            return nil
        }
    }
    
    func removeQuestions() {
        DataBase.sharedInstance.allData.removeAll()
    }
    
    func getQuestion(for index: Int) -> String? {
        if DataBase.sharedInstance.allData == [] {
            errorOccured()
            return nil
        } else if index >= DataBase.sharedInstance.allData.count {
            return nil
        }
        
        return DataBase.sharedInstance.allData[index]?.question
    }
    
    func errorOccured() {
        DataBase.sharedInstance.failure = true
    }
    
    func error() -> Bool {
        if DataBase.sharedInstance.failure == true { return true } else { return false }
    }
    
    func setError(to: Bool) {
        DataBase.sharedInstance.failure = to
    }
    
    func getAnswers(for index: Int) -> [AttributedString] {
        if index < DataBase.sharedInstance.allData.count && !DataBase.sharedInstance.allData.isEmpty {
            return DataBase.sharedInstance.allData[index]!.answers
        }
        return []
    }
}

fileprivate class DataBase: ObservableObject {
    static var sharedInstance = DataBase()
    @Published var modelChanged = false
    @Published var failure = false
    
    private init() {}
    
    /// Data
    var allData: [dataStructure] = []
}
