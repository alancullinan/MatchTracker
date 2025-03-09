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
    var name: String = ""
    var jerseyNumber: Int = 0
    var position: String = ""

    init(name: String, jerseyNumber: Int, position: String) {
        self.id = UUID()
        self.name = name
        self.jerseyNumber = jerseyNumber
        self.position = position
    }
}
