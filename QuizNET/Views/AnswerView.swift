//
//  AnswerView.swift
//  GameDemo
//
//  Created by Patrick Alves on 27.12.22.
//

import SwiftUI

/// This View defines how one answer is displayed 
struct AnswerView: View {
    @ObservedObject var vm: QuestionVM
    var answer: AttributedString = ""
    @Binding var isSelected: Bool
    @State private var singleItemSelected = false
    
    var body: some View {
        Text(answer)
            .frame(width: 320)
            .padding()
            .foregroundColor(.primary)
            .background {
                !isSelected && !vm.selectedAnswer ? Color.black.opacity(0.12) : (vm.rightAnswer ? .green : .red)
            }
            .onTapGesture {
                isSelected = true
                singleItemSelected = true
                vm.selectAnswer(answer: answer)
            }
            .cornerRadius(12)
    }
}

/*struct AnswerView_Previews: PreviewProvider {
 static var previews: some View {
 AnswerView(vm: QuestionVM())
 }
 }*/
