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
    @Attribute(.unique) var id: UUID = UUID()
    var date: Date = Date()
    var competition: String = ""
    var venue: String = ""
    var team1: Team = Team(name: "")
    var team2: Team = Team(name: "")
    var events: [Event] = []
    var matchPeriod: MatchPeriod = MatchPeriod.notStarted
    var elapsedTime: Int = 0
    var isPaused: Bool = false
    var lastPausedAt: Date? = nil
    var currentPeriodStart: Date? = nil
    var referee: String = ""
    var matchType: MatchType = MatchType.ladiesFootball
    var halfLength: Int = 1800
    var extraTimeHalfLength: Int = 600
    @Transient var isNew: Bool = true

    init() {}
}
