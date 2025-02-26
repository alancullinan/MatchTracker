//
//  MatchModel.swift
//  MatchTracker
//
//  Created by Alan Cullinan on 23/02/2025.
//

import SwiftData
import Foundation

@Model
class Match {
    @Attribute(.unique) var id: UUID
    var date: Date
    var competition: String = ""
    var venue: String = ""
    var team1: Team = Team(name: "")
    var team2: Team = Team(name: "")
    var events: [Event] = []
    var matchPeriod: MatchPeriod = .notStarted
    var elapsedTime: Int = 0
    var isPaused: Bool
    var lastPausedAt: Date?
    var currentPeriodStart: Date?
    var referee: String = ""
    var matchType: MatchType = .ladiesFootball
    var halfLength: Int = 1800
    var extraTimeHalfLength: Int = 600

    init() {}
}
