//
//  ContentView.swift
//  GameDemo
//
//  Created by Patrick Alves on 26.09.22.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var vm: QuestionVM
    @State private var showDestination: Bool = false
    @State var colors: [Color] = [.red.opacity(0.8), .blue.opacity(0.8)]
    var body: some View {
        TabView {
            HomeView(colors: colors, vm: vm)
                .tabItem {
                    Label("Home", systemImage: "house")
                }
            
            PersonalData(vm: vm)
                .tabItem {
                    Label("Profile", systemImage: "person.fill")
                }
            /*CollectionView()
                .tabItem {
                    Label("Collection", systemImage: "tray.full.fill")
                }*/
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(vm: QuestionVM())
    }
}
