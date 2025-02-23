//
//  EventModel.swift
//  MatchTracker
//
//  Created by Alan Cullinan on 23/02/2025.
//

import SwiftData
import Foundation

@Model
class Event {
    @Attribute(.unique) var id: UUID
    var type: EventType
    var player1: Player?
    var player2: Player?
    var team: Team?
    var period: MatchPeriod
    var timeElapsed: Int
    var shotOutcome: ShotOutcome?
    var shotType: ShotType?
    var foulOutcome: FoulOutcome?
    var cardType: CardType?
    var wonOwnKickout: Bool?
    var noteText: String?

    init(type: EventType,
         period: MatchPeriod,
         timeElapsed: Int,
         player1: Player? = nil,
         player2: Player? = nil,
         team: Team? = nil,
         shotOutcome: ShotOutcome? = nil,
         shotType: ShotType? = nil,
         foulOutcome: FoulOutcome? = nil,
         cardType: CardType? = nil,
         wonOwnKickout: Bool? = nil,
         noteText: String? = nil) {
        self.id = UUID()
        self.type = type
        self.period = period
        self.timeElapsed = timeElapsed
        self.player1 = player1
        self.player2 = player2
        self.team = team
        self.shotOutcome = shotOutcome
        self.shotType = shotType
        self.foulOutcome = foulOutcome
        self.cardType = cardType
        self.wonOwnKickout = wonOwnKickout
        self.noteText = noteText
    }
}
