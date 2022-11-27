//
//  CollectionView.swift
//  GameDemo
//
//  Created by Patrick Alves on 11.10.22.
//

import SwiftUI

struct CollectionView: View {
    @ObservedObject private var vm = QuestionVM()
    var body: some View {
        NavigationStack {
            ListView()
        }
    }
}

struct CollectionView_Previews: PreviewProvider {
    static var previews: some View {
        CollectionView()
    }
}

struct ListView: View {
    @ObservedObject private var vm = QuestionVM()
    var body: some View {
        VStack {
            List {
                ForEach(vm.questions.indices, id: \.self) { question in
                    Text("Category: \(vm.category)")
                        .padding(.vertical)
                    Text("Question: \(question)")
                        .padding(.vertical)
                    Text("Answer: ")
                        .padding(.vertical)
                }
            }
        }
        .navigationTitle("Collection")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                NavigationLink {
                    Text("hi")
                } label: {
                    Image(systemName: "plus.circle")
                }
                
            }
        }
    }
}
