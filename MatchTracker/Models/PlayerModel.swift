//
//  PlayerModel.swift
//  MatchTracker
//
//  Created by Alan Cullinan on 23/02/2025.
//

import SwiftData
import Foundation

@Model
class Player {
    @Attribute(.unique) var id: UUID
    var name: String
    var jerseyNumber: Int

    init(name: String, jerseyNumber: Int) {
        self.id = UUID()
        self.name = name
        self.jerseyNumber = jerseyNumber
    }
}
