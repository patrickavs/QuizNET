//
//  ContentView.swift
//  GameDemo
//
//  Created by Patrick Alves on 26.09.22.
//

import SwiftUI

struct ContentView: View {
    @StateObject var connectivity: Connectivity
    @ObservedObject var vm: QuestionVM
    @State private var showDestination: Bool = false
    @State var colors: [Color] = [.red.opacity(0.8), .blue.opacity(0.8)]
    var body: some View {
        TabView {
            HomeView(colors: colors, vm: vm)
                .tabItem {
                    Image(systemName: "house")
                }
            
            PersonalData(vm: vm)
                .tabItem {
                    Image(systemName: "person.fill")
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
        ContentView(connectivity: Connectivity(), vm: QuestionVM())
    }
}
