//
//  QuestionView.swift
//  GameDemo
//
//  Created by Patrick Alves on 26.09.22.
//

import SwiftUI

struct QuestionView: View {
    @State var colors: [Color] = [.red.opacity(0.8), .blue.opacity(0.8)]
    @State private var currentQuestion = 0
    @ObservedObject private var vm = QuestionVM()
    var body: some View {
        NavigationStack {
            ZStack {
                VStack {
                    Spacer()
                    HStack {
                        Text("\(String(describing: vm.category))".uppercased())
                            .fontWeight(.medium)
                            .font(.title)
                        
                        Spacer()
                        
                        Text("\(currentQuestion) / \(vm.amount)")
                            .fontWeight(.medium)
                            .font(.title3)
                    }
                    
                    ProgressBar(vm: vm)
                    
                    VStack(alignment: .leading, spacing: 20) {
                        Text(vm.getQuestion(index: currentQuestion))
                            .foregroundColor(.primary)
                            .font(.system(size: 20))
                            .bold()
                            .padding()
                    }
                    
                    ForEach(0..<6) { _ in
                        Spacer()
                    }
                }
                .padding(.horizontal)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(LinearGradient(colors: colors, startPoint: .topLeading, endPoint: .bottomTrailing))
            .ignoresSafeArea()
            //.navigationBarBackButtonHidden(true)
        }
    }
}

struct QuestionView_Previews: PreviewProvider {
    static var previews: some View {
        QuestionView()
    }
}
