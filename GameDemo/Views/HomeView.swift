//
//  HomeView.swift
//  GameDemo
//
//  Created by Patrick Alves on 28.09.22.
//

import SwiftUI

struct HomeView: View {
    @State private var categories: [String] = Category.allCases.map { category in
        return category.rawValue
    }
    
    @State private var difficulties: [String] = Difficulty.allCases.map { difficulty in
        return difficulty.rawValue
    }
    @State private var numberOfQuestions: [String] = Array(1...50).map { number in
        return String(number)
    }
    @State private var type: [String] = TypeEnum.allCases.map { type in
        return type.rawValue
    }
    
    @State private var idxCategories = 0
    @State private var idxDifficulties = 0
    @State private var idxNumberOfQuestions = 0
    @State private var idxType = 0
    @State var colors: [Color] = [.red.opacity(0.8), .blue.opacity(0.8)]
    @State private var text = ["Category", "Difficulty", "Questions", "Type"]
    @ObservedObject var vm: QuestionVM
    @State private var startGame = false
    @State private var dataFetched = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                contentHomeView
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(LinearGradient(colors: colors, startPoint: .topLeading, endPoint: .bottomTrailing))
            .navigationTitle(Text("QuizNET"))
            .navigationBarTitleDisplayMode(.inline)
            .navigationDestination(isPresented: $startGame) {
                QuestionView()
            }
        }
    }
    
    var contentHomeView: some View {
        VStack {
            Spacer(minLength: 30)
            MainView(idx: $idxCategories, array: $categories, text: $text[0], data: $vm.category)
            MainView(idx: $idxDifficulties, array: $difficulties, text: $text[1], data: $vm.difficulty)
            MainView(idx: $idxNumberOfQuestions, array: $numberOfQuestions, text: $text[2], data: $vm.amount)
            MainView(idx: $idxType, array: $type, text: $text[3], data: $vm.type)
            
            HStack {
                Text("Load Data")
                    .startButton()
                    .onTapGesture {
                        vm.setQuestions()
                        dataFetched = true
                    }
                    .padding(.bottom, 30)
                Spacer()
                Text("Play")
                    .startButton()
                    .padding(.bottom, 30)
                    .onTapGesture {
                        startGame = true
                    }
                    .disabled(dataFetched == false)
            }
            .padding(.horizontal)
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView(vm: QuestionVM())
    }
}

struct MainView: View {
    @Binding var idx: Int
    @Binding var array: [String]
    @Binding var text: String
    @Binding var data: String
    
    var body: some View {
        contentMainView
        /*HStack {
         Spacer()
         
         Button {
         if idx < 1 {
         idx = (array.endIndex - 1)
         } else {
         idx -= 1
         }
         } label: {
         Image(systemName: "arrow.left.circle")
         .bold()
         .foregroundColor(.primary)
         .font(.system(size: 40))
         }
         //.disabled(idx == 0)
         
         
         Spacer()
         
         Text("\(text):" + "\n" + "\(array[idx])")
         .lineLimit(2)
         .font(.title2)
         .foregroundColor(.init(uiColor: .systemMint))
         .bold()
         .frame(width: 200, height: 60)
         .padding(.horizontal, -20)
         .padding(.vertical, 10)
         .background {
         RoundedRectangle(cornerRadius: 8, style: .continuous)
         .foregroundColor(.white)
         }
         
         Spacer()
         
         Button {
         if idx > array.count-2 {
         idx = array.startIndex
         } else {
         idx += 1
         }
         } label: {
         Image(systemName: "arrow.right.circle")
         .bold()
         .foregroundColor(.primary)
         .font(.system(size: 40))
         }
         //.disabled(idx == array.count-1)
         
         
         Spacer()
         }*/
    }
    
    var contentMainView: some View {
        VStack {
            Text("Choose \(text):")
                .padding()
                .background(Color.black.opacity(0.05))
                .cornerRadius(12)
                .foregroundColor(.black)
                .padding(.top, 3)
                .padding(.bottom, -20)
            Picker("", selection: $idx) {
                ForEach(array.indices, id: \.self) { index in
                    Text(array[index])
                        .foregroundColor(.black)
                }
                .onChange(of: idx) { newValue in
                    data = array[newValue]
                }
            }
            .pickerStyle(.wheel)
            //.padding(-20)
        }
    }
}
