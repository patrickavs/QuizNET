//
//  CollectionView.swift
//  GameDemo
//
//  Created by Patrick Alves on 11.10.22.
//

import SwiftUI
import MultipeerConnectivity
import os

/// Displays the PeerOverview, embeded in a NavigationStack to move on to the ContentView when the Start-Button was pressed
struct PeerCollectionView: View {
    @ObservedObject var vm: QuestionVM
    @EnvironmentObject var connectivity: Connectivity
    @State private var startGame = false
    var body: some View {
        NavigationStack {
            PeerOverview(startGame: $startGame)
                .navigationDestination(isPresented: $startGame) {
                    ContentView(vm: vm)
                        .environmentObject(connectivity)
                }
                .environmentObject(connectivity)
        }
    }
}

struct CollectionView_Previews: PreviewProvider {
    static var previews: some View {
        PeerCollectionView(vm: QuestionVM())
    }
}

/// This view shows all the available and connected devices in a List
struct PeerOverview: View {
    @EnvironmentObject var connectivity: Connectivity
    @Binding var startGame: Bool
    var body: some View {
        VStack {
            List {
                Section("Devices") {
                    ForEach(connectivity.availablePeers, id: \.self) { peer in
                        Button {
                            connectivity.getBrowser().invitePeer(peer, to: connectivity.getSession(), withContext: nil, timeout: 40)
                        } label: {
                            Text(peer.displayName)
                        }
                    }
                }
                
                Section("Connected Devices") {
                    ForEach(connectivity.getSession().connectedPeers, id: \.self) { connectedPeers in
                        Text(connectedPeers.displayName)
                    }
                }
            }
            .frame(height: 300)
            .cornerRadius(12)
            
            if connectivity.paired && !startGame && !connectivity.hideStartButton {
                Button {
                    startGame = true
                } label: {
                    Text("Start Game")
                        .startButton()
                        .padding(.top, 40)
                }
            }
            
            Spacer()
        }
        .alert("Received an invite from \(connectivity.receivedInviteFrom?.displayName ?? "Error!")!", isPresented: $connectivity.receivedInvite) {
            Button("Accept invite") {
                if (connectivity.invitationHandler != nil) {
                    connectivity.invitationHandler!(true, connectivity.getSession())
                }
            }
            Button("Reject invite") {
                if (connectivity.invitationHandler != nil) {
                    connectivity.invitationHandler!(false, nil)
                }
            }
        }
        .navigationTitle("Peers")
    }
}
