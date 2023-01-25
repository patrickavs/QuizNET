//
//  WelcomeView.swift
//  GameDemo
//
//  Created by Patrick Alves on 09.01.23.
//

import SwiftUI
import MultipeerConnectivity

/// Start-View to choose wether to play in single- or multiplayer mode
struct WelcomeView: View {
    @StateObject var connectivity = Connectivity(username: UIDevice.current.name)
    @ObservedObject var vm: QuestionVM
    @State private var username: String = ""
    @State private var showPeers = false
    
    var body: some View {
        NavigationStack {
            VStack {
                
                Spacer()
                
                VStack(spacing: 20) {
                    Text("Welcome!")
                        .font(.title)
                        .padding(.bottom, 10)
                    TextField("Enter your name", text: $username)
                        .multilineTextAlignment(.center)
                        .padding(.bottom, 50)
                        .textFieldStyle(.roundedBorder)
                        .padding(.horizontal)
                    
                    Button {
                        connectivity.changeUsername(userName: username)
                    } label: {
                        Text("Save")
                            .padding()
                            .padding(.horizontal, 30)
                            .background {
                                username == "" ? Rectangle()
                                    .fill(.gray)
                                    .cornerRadius(12) :
                                Rectangle()
                                    .fill(.green)
                                    .cornerRadius(12)
                            }
                    }
                    .disabled(username == "")
                    
                }
                .frame(maxWidth: 300, maxHeight: 300)
                .background {
                    Rectangle()
                        .fill(.quaternary)
                }
                .cornerRadius(12)
                
                Spacer()
                
                
                Text("Singleplayer")
                    .font(.title)
                NavigationLink {
                    ContentView(vm: vm)
                        .environmentObject(connectivity)
                } label: {
                    Text("Singleplayer")
                        .padding()
                        .padding(.horizontal, 20)
                        .background {
                            Rectangle()
                                .fill(.ultraThinMaterial)
                                .cornerRadius(12)
                        }
                }
                
                Text("Multiplayer")
                    .font(.title)
                    .padding()
                
                Button {
                    showPeers = true
                } label: {
                    Text("Search for Connections")
                        .padding()
                        .padding(.horizontal, 20)
                        .background {
                            Rectangle()
                                .fill(.ultraThinMaterial)
                                .cornerRadius(12)
                        }
                }
                
                Spacer()
            }
            .navigationDestination(isPresented: $showPeers) {
                PeerCollectionView(vm: vm)
                    .environmentObject(connectivity)
            }
            .navigationBarBackButtonHidden()
            
        }
        
        /*Button {
         connectivity = Connectivity(username: username)
         connectivity.advertise()
         } label: {
         Text("Host a session")
         .padding()
         .padding(.horizontal, 20)
         .background {
         Rectangle()
         .fill(.ultraThinMaterial)
         .cornerRadius(12)
         }
         }
         .disabled(username == "")*/
    }
}

struct WelcomeView_Previews: PreviewProvider {
    static var previews: some View {
        WelcomeView(vm: QuestionVM())
    }
}
