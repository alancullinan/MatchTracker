// ShotDetailsContent.swift
import SwiftUI
import SwiftData

struct ShotDetailsContent: View {
    @Bindable var match: Match
    @Bindable var event: Event
    
    // Local state for optional values
    @State private var shotOutcome: ShotOutcome
    @State private var shotType: ShotType
    
    init(match: Match, event: Event) {
        self.match = match
        self.event = event
        _shotOutcome = State(initialValue: event.shotOutcome ?? .wide)
        _shotType = State(initialValue: event.shotType ?? .fromPlay)
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            
            // Side-by-side layout for shot type, outcome, and player selection
            HStack(alignment: .top, spacing: 16) {
                // Left side: Shot Type and Outcome
                VStack(alignment: .leading, spacing: 16) {
                    // Shot Type selection
                    VStack(alignment: .leading, spacing: 8) {
//                        Text("Shot Type")
//                            .font(.subheadline)
//                            .foregroundColor(.secondary)
                        
                        ShotTypeSelectionView(match: match, event: event, shotType: $shotType)
                            .frame(maxWidth: .infinity)
                    }
                    
                    // Shot Outcome selection
                    VStack(alignment: .leading, spacing: 8) {
//                        Text("Outcome")
//                            .font(.subheadline)
//                            .foregroundColor(.secondary)
                        
                        ShotOutcomeSelectionView(match: match, event: event, shotOutcome: $shotOutcome)
                            .frame(maxWidth: .infinity)
                    }
                }
                .frame(maxWidth: .infinity)
                
                // Right side: Player Selection
                if let team = event.team, !team.players.isEmpty {
                    VStack(alignment: .leading, spacing: 8) {
//                        Text("Player")
//                            .font(.subheadline)
//                            .foregroundColor(.secondary)
                        
                        PlayerSelectionView(event: event, team: team)
                            .frame(maxWidth: .infinity)
                    }
                    .frame(maxWidth: .infinity)
                }
            }
        }
    }
}
