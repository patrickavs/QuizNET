//
//  Player.swift
//  GameDemo
//
//  Created by Patrick Alves on 13.01.23.
//

import Foundation

struct Player: Identifiable {
    let id: UUID
    let name: String
}

struct PeerDatabase {
    static var sharedInstance = PeerDatabase()
    
    var data: [Player] = []
}
