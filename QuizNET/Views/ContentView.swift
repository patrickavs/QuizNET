//
//  ContentView.swift
//  GameDemo
//
//  Created by Patrick Alves on 26.09.22.
//

import SwiftUI

/// In this view, the user can choose the quiz parameters
struct ContentView: View {
    @ObservedObject var vm: QuestionVM
    @EnvironmentObject var connectivity: Connectivity
    @State var colors: [Color] = [.red.opacity(0.8), .blue.opacity(0.8)]
    var body: some View {
        TabView {
            HomeView(colors: colors, vm: vm)
                .tabItem {
                    Label("Home", systemImage: "house")
                }
            PersonalData(vm: vm)
                .tabItem {
                    Label("Player(s)", systemImage: "person.fill")
                }
            
            PeerCollectionView(vm: vm)
                .tabItem {
                    Label("Devices", systemImage: "tray.full.fill")
                }
        }
        .onAppear {
            connectivity.hideStartButton = true
        }
        .environmentObject(connectivity)
        .navigationTitle("QuizNET")
        .navigationBarTitleDisplayMode(.inline)
        .tint(.black)
        .navigationBarBackButtonHidden()
    }
}

/*struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(vm: QuestionVM())
    }
}*/
