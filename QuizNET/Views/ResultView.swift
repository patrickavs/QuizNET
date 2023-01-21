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
                
                /*if connectivity.availablePeers.isEmpty {
                    Text("No Player found")
                        .bold()
                        .padding()
                        .background {
                            Color.red
                        }
                        .cornerRadius(12)
                } else {
                    ForEach(connectivity.availablePeers, id: \.self) { player in
                        VStack(alignment: .center) {
                            Text("Score of \(player.displayName): \(vm.score)")
                        }
                    }
                }*/
                
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
            .navigationDestination(isPresented: $retry) {
                ContentView(vm: vm)
            }
            .navigationDestination(isPresented: $home) {
                WelcomeView(vm: vm)
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
