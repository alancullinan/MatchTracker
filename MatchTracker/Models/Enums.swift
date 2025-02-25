//
//  Enums.swift
//  MatchTracker
//
//  Created by Alan Cullinan on 23/02/2025.
//

import Foundation

enum MatchPeriod: String, Codable {
    case notStarted, firstHalf, halfTime, secondHalf, fullTime
    case extraTimeFirstHalf, extraTimeHalfTime, extraTimeSecondHalf, matchOver
}

enum MatchType: String, Codable, CaseIterable {
    case football, hurling, ladiesFootball, camogie
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
