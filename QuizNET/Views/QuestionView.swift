//
//  QuestionView.swift
//  GameDemo
//
//  Created by Patrick Alves on 26.09.22.
//

import SwiftUI

struct QuestionView: View {
    @State var colors: [Color] = [.red.opacity(0.8), .blue.opacity(0.8)]
    @ObservedObject var vm: QuestionVM
    @EnvironmentObject var connectivity: Connectivity
    @State private var isSelected = false
    var body: some View {
        NavigationStack {
            DetailQuestionView(vm: vm, colors: $colors, isSelected: $isSelected)
                .navigationBarBackButtonHidden()
                .environmentObject(connectivity)
        }
    }
}

struct QuestionView_Previews: PreviewProvider {
    static var previews: some View {
        QuestionView(vm: QuestionVM())
    }
}

struct DetailQuestionView: View {
    @ObservedObject var vm: QuestionVM
    @EnvironmentObject var connectivity: Connectivity
    @Binding var colors: [Color]
    @Binding var isSelected: Bool
    @State private var singleItemSelected = false
    var body: some View {
        ZStack {
            VStack(spacing: 20) {
                HStack {
                    Text(vm.category)
                        .fontWeight(.medium)
                        .font(.title)
                    
                    Spacer()
                    
                    Text("\(vm.index+1) / \(vm.amount)")
                        .fontWeight(.medium)
                        .font(.title3)
                }
                
                ProgressBar(vm: vm)
                
                Text(vm.getQuestion())
                    .fixedSize(horizontal: false, vertical: true)
                    .foregroundColor(.primary)
                    .font(.system(size: 20))
                    .bold()
                    .padding()
                
                
                ForEach(vm.getAnswers(), id: \.self) { answer in
                    AnswerView(vm: vm, answer: answer, isSelected: $isSelected)
                }
                
                
                if vm.reachedEnd {
                    NavigationLink {
                        ResultView(vm: vm)
                            .environmentObject(connectivity)
                    } label: {
                        Text("See Results")
                            .padding()
                            .foregroundColor(.primary)
                            .background {
                                Rectangle()
                                    .fill(.ultraThinMaterial)
                            }
                            .cornerRadius(12)
                    }
                    .padding(.top)
                } else {
                    Button(action: {
                        singleItemSelected = false
                        vm.getNextQuestion()
                        isSelected = false
                    }, label: {
                        Text("Next Question")
                            .padding()
                            .foregroundColor(.primary)
                            .background {
                                Rectangle()
                                    .fill(.ultraThinMaterial)
                            }
                            .cornerRadius(12)
                    })
                    .padding(.top)
                }
                
                Spacer()
            }
            .padding(.horizontal)
        }
        .background(LinearGradient(colors: colors, startPoint: .topLeading, endPoint: .bottomTrailing))
        .toolbar(.hidden, for: .navigationBar)
    }
}
