//
//  ModelInterface.swift
//  GameDemo
//
//  Created by Patrick Alves on 19.11.22.
//

import Foundation
import Combine

typealias dataStructure = QuestionModel

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
        if modelData.modelChanged == true {
            return getGuardedValueFor(index: idx)
        }
        return nil
    }
    
    func getNext() -> dataStructure!
    {
        idx += 1
        return getGuardedValueFor(index: idx)
    }
    
    func append(with: dataStructure) {
        DataBase.sharedInstance.allData.append(with)
        DataBase.sharedInstance.modelChanged = true
    }
    
    func getModelData() -> [dataStructure] {
        return DataBase.sharedInstance.allData
    }
    
    func append(data: dataStructure) {
        guard let idx = DataBase.sharedInstance.allData.firstIndex(where: { $0.id == data.id }) else { return }
        DataBase.sharedInstance.allData[idx] = data
        DataBase.sharedInstance.modelChanged = true
    }
    
    func getGuardedValueFor(index: Int) -> dataStructure! {
        if index < modelData.allData.count {
            return modelData.allData[index]
        }
        else {
            return nil
        }
    }
    
    func readyToUse() -> Bool {
        return modelData.modelChanged == true
    }
    
    func modelChanged() {
        modelData.modelChanged = true
    }
}

fileprivate class DataBase: ObservableObject {
    static var sharedInstance = DataBase()
    @Published var modelChanged = false
    
    private init() {}
    
    /// Data
    var allData: [dataStructure] = []
}
