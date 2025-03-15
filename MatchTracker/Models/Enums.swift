//
//  Enums.swift
//  MatchTracker
//
//  Created by Alan Cullinan on 23/02/2025.
//

import Foundation

enum MatchPeriod: String, Codable, CaseIterable {
    case notStarted = "Not Started"
    case firstHalf = "1st Half"
    case halfTime = "Half Time"
    case secondHalf = "2nd Half"
    case fullTime = "Full Time"
    case extraTimeFirstHalf = "Extra Time 1st Half"
    case extraTimeHalfTime = "Extra Time Half Time"
    case extraTimeSecondHalf = "Extra Time 2nd Half"
    case matchOver = "Match Over"
}

// Extension for MatchPeriod functionality
extension MatchPeriod {
    // Returns true if this is an active play period
    var isPlayPeriod: Bool {
        switch self {
        case .firstHalf, .secondHalf, .extraTimeFirstHalf, .extraTimeSecondHalf:
            return true
        default:
            return false
        }
    }
    
    // Other useful properties
    var isHalfTime: Bool {
        return self == .halfTime || self == .extraTimeHalfTime
    }
    
    var isGameOver: Bool {
        return self == .fullTime || self == .matchOver
    }
}

enum MatchType: String, Codable, CaseIterable {
    case football = "Football"
    case hurling = "Hurling"
    case ladiesFootball = "Ladies Football"
    case camogie = "Camogie"
}

enum EventType: String, Codable {
    case shot, substitution, kickout, card, foulConceded, periodStart, periodEnd, note
}

enum ShotOutcome: String, Codable {
    case goal, point, twoPointer, wide, saved, droppedShort, offPost
}

enum ShotType: String, Codable {
    case fromPlay, free, penalty, fortyFive, sixtyFive, sideline, mark
}

enum FoulOutcome: String, Codable {
    case free, penalty
}

enum CardType: String, Codable {
    case yellow, red, black
}

