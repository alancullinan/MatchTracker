// KickoutDetailsContent.swift
import SwiftUI
import SwiftData

struct KickoutDetailsContent: View {
    @Bindable var match: Match
    @Bindable var event: Event
    @State private var wonOwnKickout: Bool
    
    init(match: Match, event: Event) {
        self.match = match
        self.event = event
        _wonOwnKickout = State(initialValue: event.wonOwnKickout ?? true)
    }
    
    var body: some View {
        // Side-by-side layout for kickout outcome and player selection
        HStack(alignment: .top, spacing: 16) {
            // Left side: Kickout Outcome
            VStack(alignment: .leading) {
//                Text("Outcome")
//                    .font(.subheadline)
//                    .foregroundColor(.secondary)
                
                KickoutOutcomeSelectionView(event: event, wonOwnKickout: $wonOwnKickout)
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
