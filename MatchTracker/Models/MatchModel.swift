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

extension Match {
    // Returns events sorted with newest at the top
    var sortedEventsByRecent: [Event] {
        events.sorted { (event1, event2) -> Bool in
            // First, sort by period (descending)
            let period1Index = MatchPeriod.allCases.firstIndex(of: event1.period) ?? 0
            let period2Index = MatchPeriod.allCases.firstIndex(of: event2.period) ?? 0
            
            if period1Index != period2Index {
                return period1Index > period2Index
            }
            
            // If same period, sort by time elapsed (descending)
            return event1.timeElapsed > event2.timeElapsed
        }
    }
    
    // Returns events sorted chronologically (oldest first)
    var sortedEventsChronologically: [Event] {
        events.sorted { (event1, event2) -> Bool in
            // First, sort by period
            let period1Index = MatchPeriod.allCases.firstIndex(of: event1.period) ?? 0
            let period2Index = MatchPeriod.allCases.firstIndex(of: event2.period) ?? 0
            
            if period1Index != period2Index {
                return period1Index < period2Index
            }
            
            // If same period, sort by time elapsed
            return event1.timeElapsed < event2.timeElapsed
        }
    }
}
