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
    @State private var numberOfQuestions: [String] = Array(1...30).map { number in
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
    @EnvironmentObject var connectivity: Connectivity
    @State private var startGame = false
    
    var body: some View {
        //NavigationStack {
            ZStack {
                contentHomeView
            }
            .background(LinearGradient(colors: colors, startPoint: .topLeading, endPoint: .bottomTrailing))
            .navigationDestination(isPresented: $startGame) {
                QuestionView(vm: vm)
                    .environmentObject(connectivity)
            }
            .navigationBarBackButtonHidden()
        //}
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
                    }
                    .alert(Text("Couldnt get questions, please try again."), isPresented: $vm.error) {
                        Button(role: .cancel) {
                            vm.resetError()
                            vm.canPlay = false
                        } label: {
                            Text("Cancel")
                        }
                    }
                    .padding(.bottom, 30)
                Spacer()
                Button {
                    if vm.index+1 == Int(vm.amount) {
                        vm.reachedEnd = true
                    }
                    if vm.questions.isEmpty {
                        vm.errorOccured()
                    }
                    startGame = true
                } label: {
                    Text("Play")
                        .startButton()
                        .padding(.bottom, 30)
                }
                .disabled(vm.canPlay == false)

            }
            .padding(.horizontal)
        }
        .environmentObject(connectivity)
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
    }
    
    var contentMainView: some View {
        VStack {
            Text("Choose \(text):")
                .padding()
                .background {
                    Rectangle()
                        .fill(.ultraThinMaterial)
                }
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
