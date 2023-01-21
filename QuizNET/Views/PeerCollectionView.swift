//
//  CollectionView.swift
//  GameDemo
//
//  Created by Patrick Alves on 11.10.22.
//

import SwiftUI
import MultipeerConnectivity

struct PeerCollectionView: View {
    @ObservedObject var vm: QuestionVM
    @EnvironmentObject var connectivity: Connectivity
    @State private var startGame = false
    var body: some View {
        NavigationStack {
            ListView(vm: vm, startGame: $startGame)
                .navigationDestination(isPresented: $startGame) {
                    ContentView(vm: vm)
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

struct ListView: View {
    @ObservedObject var vm: QuestionVM
    @EnvironmentObject var connectivity: Connectivity
    @Binding var startGame: Bool
    var body: some View {
        if !connectivity.paired {
            VStack {
                List {
                    Section("Devices") {
                        ForEach(connectivity.availablePeers, id: \.self) { peer in
                            Button {
                                connectivity.getBrowser().invitePeer(peer, to: connectivity.getSession(), withContext: nil, timeout: 10)
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
            }
            .alert("Received an invite from \(connectivity.receivedInviteFrom?.displayName ?? "Error!")!", isPresented: $connectivity.receivedInvite) {
                Button("Accept invite") {
                    if (connectivity.invitationHandler != nil) {
                        connectivity.invitationHandler!(true, connectivity.getSession())
                    }
                    startGame = true
                }
                Button("Reject invite") {
                    if (connectivity.invitationHandler != nil) {
                        connectivity.invitationHandler!(false, nil)
                    }
                }
            }
            .navigationTitle("Peers")
        } else {
            ContentView(vm: vm)
                .environmentObject(connectivity)
        }
    }
}
