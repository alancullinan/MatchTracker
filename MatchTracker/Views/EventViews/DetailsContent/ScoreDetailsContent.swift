//
//  ScoreDetailsContent.swift
//  MatchTracker
//
// GoalDetailsContent.swift

import SwiftUI
import SwiftData

struct GoalDetailsContent: View {
    @Bindable var match: Match
    @Bindable var event: Event
    @State private var shotType: ShotType
    
    init(match: Match, event: Event) {
        self.match = match
        self.event = event
        _shotType = State(initialValue: event.shotType ?? .fromPlay)
    }
    
    var body: some View {
        
        // Side-by-side layout for shot type and player selection
        HStack(alignment: .top, spacing: 16) {
            // Left side: Shot Type
            ShotTypeSelectionView(match: match, event: event, shotType: $shotType)
            
            // Right side: Player Selection
            if let team = event.team, !team.players.isEmpty {
                PlayerSelectionView(event: event, team: team)
                    .frame(maxWidth: .infinity)
            }
            
        }
    }
}

// PointDetailsContent.swift

struct PointDetailsContent: View {
    @Bindable var match: Match
    @Bindable var event: Event
    @State private var shotType: ShotType
    
    init(match: Match, event: Event) {
        self.match = match
        self.event = event
        _shotType = State(initialValue: event.shotType ?? .fromPlay)
    }
    
    var body: some View {
        
        // Side-by-side layout for shot type and player selection
        HStack(alignment: .top, spacing: 16) {
            // Left side: Shot Type
            ShotTypeSelectionView(match: match, event: event, shotType: $shotType)
            
            // Right side: Player Selection
            if let team = event.team, !team.players.isEmpty {
                PlayerSelectionView(event: event, team: team)
                    .frame(maxWidth: .infinity)
            }
            
        }
    }
}

struct TwoPointerDetailsContent: View {
    @Bindable var match: Match
    @Bindable var event: Event
    @State private var shotType: ShotType
    
    init(match: Match, event: Event) {
        self.match = match
        self.event = event
        _shotType = State(initialValue: event.shotType ?? .fromPlay)
    }
    
    var body: some View {
        
        // Side-by-side layout for shot type and player selection
        HStack(alignment: .top, spacing: 16) {
            // Left side: Shot Type
            ShotTypeSelectionView(match: match, event: event, shotType: $shotType)
            
            // Right side: Player Selection
            if let team = event.team, !team.players.isEmpty {
                PlayerSelectionView(event: event, team: team)
                    .frame(maxWidth: .infinity)
            }
            
        }
    }
}
