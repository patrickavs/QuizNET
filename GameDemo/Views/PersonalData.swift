//
//  PersonalData.swift
//  GameDemo
//
//  Created by Patrick Alves on 01.10.22.
//

import SwiftUI

struct PersonalData: View {
    @State private var player1: String = ""
    @State private var player2: String = ""
    @ObservedObject var vm: QuestionVM
    
    var body: some View {
        NavigationStack {
            content
                .navigationTitle("Player")
                .navigationBarTitleDisplayMode(.inline)
        }
    }
    
    var content: some View {
        VStack {
            
            /*Rectangle()
                .frame(width: .infinity, height: 1)
                .edgesIgnoringSafeArea(.horizontal)
                .padding(.bottom, 30)
                .foregroundColor(.primary)
             */
            Divider()
            Spacer(minLength: 40)
            
            VStack {
                Image(systemName: "person.2.fill")
                    .font(.system(size: 90))
                    .padding(30)
                    .background {
                        Color.white
                    }
                    .clipShape(Circle())
                    .foregroundColor(.black)
            }
            .padding(20)
            .background {
                Color(.lightGray)
                    .opacity(0.25)
            }
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .padding(.bottom, 30)
            
            Form {
                Section("Player1") {
                    TextField("Player1", text: $player1)
                }
                
                Section("Player2") {
                    TextField("Player2", text: $player2)
                }
            }
            
            Button {
                vm.save(player1: player1, player2: player2)
            } label: {
                Text("Submit")
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 10)
                        .fill(Color.black))
                    .padding(.vertical)
            }

            

        }
        .background(ignoresSafeAreaEdges: .bottom)
    }
}

struct PersonalData_Previews: PreviewProvider {
    static var previews: some View {
        PersonalData(vm: QuestionVM())
    }
}