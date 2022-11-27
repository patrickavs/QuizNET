//
//  ModelInterface.swift
//  GameDemo
//
//  Created by Patrick Alves on 19.11.22.
//

import Foundation
import Combine

typealias dataStructure = QuestionContainer

class ModelInterface {
    fileprivate var modelData = DataBase.sharedInstance
    fileprivate var idx = 0
    
    func modelNotifier() -> ObservableObjectPublisher
    {
      return modelData.objectWillChange
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
    
    func update(with: dataStructure) {
        guard let idx = DataBase.sharedInstance.allData.firstIndex(where: {$0.questionData.id == with.questionData.id}) else { return }
        DataBase.sharedInstance.allData[idx] = with
        readyToUse()
    }
    
    func append(data: dataStructure) {
        DataBase.sharedInstance.allData.append(data)
    }
    
    func getGuardedValueFor(index: Int) -> dataStructure! {
        if index < modelData.allData.count {
            return modelData.allData[index]
        }
        else {
            return nil
        }
    }
    
    func readyToUse() {
        DataBase.sharedInstance.modelChanged = true
    }
}

fileprivate class DataBase: ObservableObject {
    static var sharedInstance = DataBase()
    @Published var modelChanged = false
    
    private init() {}
    
    /// Data
    var allData: [dataStructure] = []
}
