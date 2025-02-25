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
    var competition: String?
    var venue: String?
    var team1: Team
    var team2: Team
    var events: [Event] = []
    var matchPeriod: MatchPeriod
    var elapsedTime: Int
    var isPaused: Bool
    var lastPausedAt: Date?
    var currentPeriodStart: Date?
    var referee: String?
    var matchType: MatchType
    var halfLength: Int
    var extraTimeHalfLength: Int?

    init(date: Date, venue: String? = nil, competition: String, team1: Team, team2: Team, matchType: MatchType, halfLength: Int, extraTimeHalfLength: Int? = nil, referee: String? = nil) {
        self.id = UUID()
        self.date = date
        self.venue = venue
        self.competition = competition
        self.team1 = team1
        self.team2 = team2
        self.matchPeriod = .notStarted
        self.elapsedTime = 0
        self.isPaused = false
        self.matchType = matchType
        self.halfLength = halfLength
        self.extraTimeHalfLength = extraTimeHalfLength
        self.referee = referee
    }
}
