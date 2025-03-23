// FoulDetailsContent.swift
import SwiftUI
import SwiftData

struct FoulDetailsContent: View {
    @Bindable var match: Match
    @Bindable var event: Event
    @State private var foulOutcome: FoulOutcome
    
    init(match: Match, event: Event) {
        self.match = match
        self.event = event
        _foulOutcome = State(initialValue: event.foulOutcome ?? .free)
    }
    
    var body: some View {
        // Side-by-side layout for foul outcome and player selection
        HStack(alignment: .top, spacing: 16) {
            // Left side: Foul Outcome
            VStack(alignment: .leading) {
//                Text("Outcome")
//                    .font(.subheadline)
//                    .foregroundColor(.secondary)
                
                FoulOutcomeSelectionView(event: event, foulOutcome: $foulOutcome)
                    .frame(maxWidth: .infinity)
            }
            
            // Right side: Player Selection
            if let team = event.team, !team.players.isEmpty {
                VStack(alignment: .leading) {
//                    Text("Player")
//                        .font(.subheadline)
//                        .foregroundColor(.secondary)
                    
                    PlayerSelectionView(event: event, team: team)
                        .frame(maxWidth: .infinity)
                }
            }
        }
    }
}
