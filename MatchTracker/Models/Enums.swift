//
//  Enums.swift
//  MatchTracker
//
//  Created by Alan Cullinan on 23/02/2025.
//

import Foundation

enum MatchPeriod: String, Codable, CaseIterable {
    case notStarted = "Not Started"
    case firstHalf = "First Half"
    case halfTime = "Half Time"
    case secondHalf = "Second Half"
    case fullTime = "Full Time"
    case extraTimeFirstHalf = "Extra Time First Half"
    case extraTimeHalfTime = "Extra Time Half Time"
    case extraTimeSecondHalf = "Extra Time Second Half"
    case matchOver = "Match Over"
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
    case score, wide, saved, droppedShort, offPost
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
