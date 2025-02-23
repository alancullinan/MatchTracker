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
    var name: String
    var players: [Player] = []

    init(name: String) {
        self.id = UUID()
        self.name = name
    }
}
