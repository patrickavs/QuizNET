//
//  PersonalData.swift
//  GameDemo
//
//  Created by Patrick Alves on 01.10.22.
//

import SwiftUI
import MultipeerConnectivity

/// This view shows his and the connected peers' name when the user choose multiplayer mode
struct PersonalData: View {
    @State private var player1: String = ""
    @State private var player2: String = ""
    @ObservedObject var vm: QuestionVM
    @EnvironmentObject var connectivity: Connectivity
    
    var body: some View {
        NavigationStack {
            content
                .navigationTitle("Player(s)")
                .navigationBarTitleDisplayMode(.inline)
        }
    }
    
    var content: some View {
        VStack {
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
                    Text("Player1: \(UIDevice.current.name)")
                }
                
                if connectivity.getSession().connectedPeers != [] {
                    Section("Player2") {
                        Text("Player2: \(connectivity.getSession().connectedPeers.first?.displayName ?? "")")
                    }
                }
            }
        }
        .environmentObject(connectivity)
    }
}

struct PersonalData_Previews: PreviewProvider {
    static var previews: some View {
        PersonalData(vm: QuestionVM())
    }
}
