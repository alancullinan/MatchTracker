//
//  TeamModel.swift
//  MatchTracker
//
//  Created by Alan Cullinan on 23/02/2025.
//

import SwiftData
import Foundation

@Model
class Team {
    @Attribute(.unique) var id: UUID
    var name: String = ""
    var players: [Player] = []

    init(name: String) {
        self.id = UUID()
        self.name = name
    }
    
    // Add this method to your Team class in TeamModel.swift
    func initializeWithNumberedPlayers() {
        // Clear existing players first (if any)
        players.removeAll()
        
        // Add players with numbers 1-30
        for number in 1...30 {
            let player = Player(
                name: "No.\(number)",
                jerseyNumber: number,
                position: ""
            )
            players.append(player)
        }
    }
}


