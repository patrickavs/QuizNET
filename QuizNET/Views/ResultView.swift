//
//  ResultView.swift
//  GameDemo
//
//  Created by Patrick Alves on 01.01.23.
//

import SwiftUI

struct ResultView: View {
    @ObservedObject var vm: QuestionVM
    @EnvironmentObject var connectivity: Connectivity
    @State private var retry = false
    @State private var home = false
    @State private var readyToSend: Bool = false
    @State private var dataFromPeer: String = ""
    var body: some View {
        NavigationStack {
            VStack {
                Spacer()
                
                Text("Congratulations, you have answered all the questions!")
                    .bold()
                    .foregroundColor(.primary)
                    .padding()
                    .font(.title)
                
                Text("Your total score: \(vm.score)")
                    .font(.headline)
                    .padding(.bottom, 30)
                
                Text("Score from Opponnent: \(dataFromPeer)")
                    .font(.headline)
                    .padding(.bottom, 30)
                
                Spacer()
                
                HStack(alignment: .center, spacing: 20) {
                    Button {
                        vm.resetAll()
                        self.retry = true
                    } label: {
                        Text("Retry")
                            .frame(width: 100)
                            .padding()
                            .font(.headline)
                            .foregroundColor(.primary)
                            .background {
                                Rectangle()
                                    .fill(.ultraThinMaterial)
                            }
                            .cornerRadius(12)
                    }
                    
                    Button {
                        vm.resetAll()
                        self.home = true
                        //connectivity.getSession().disconnect()
                    } label: {
                        Text("Home")
                            .frame(width: 100)
                            .padding()
                            .font(.headline)
                            .foregroundColor(.primary)
                            .background {
                                Rectangle()
                                    .fill(.ultraThinMaterial)
                            }
                            .cornerRadius(12)
                    }
                }

                
                Spacer()
            }
            .onAppear {
                readyToSend = true
            }
            .alert(isPresented: $readyToSend) {
                Alert(title: Text("Send your Score"), dismissButton: .default(Text("Send"), action: {
                    dataFromPeer = String(vm.score)
                    connectivity.send(data: dataFromPeer)
                    readyToSend = false
                }))
            }
            .navigationDestination(isPresented: $retry) {
                ContentView(vm: vm)
                    .environmentObject(connectivity)
            }
            .navigationDestination(isPresented: $home) {
                WelcomeView(vm: vm)
                    .environmentObject(connectivity)
            }
            .navigationBarBackButtonHidden()
        }
    }
}

struct ResultView_Previews: PreviewProvider {
    static var previews: some View {
        ResultView(vm: QuestionVM())
    }
}

enum Result {
    case win, loss, tie
}
