// SubstitutionDetailsContent.swift
import SwiftUI
import SwiftData

struct SubstitutionDetailsContent: View {
    @Bindable var match: Match
    @Bindable var event: Event
    
    init(match: Match, event: Event) {
        self.match = match
        self.event = event
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
//            Text("Substitution Details")
//                .font(.headline)
            
            // Side-by-side layout for player selection
            HStack(alignment: .top, spacing: 16) {
                // Left side: Player coming off
                if let team = event.team, !team.players.isEmpty {
                    VStack(alignment: .leading) {
                        Text("Player Off")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                            
                        // For player coming off (player1)
                        PlayerSelectionView(event: event, team: team)
                            .frame(maxWidth: .infinity)
                    }
                }
                
                // Right side: Player coming on
                if let team = event.team, !team.players.isEmpty {
                    VStack(alignment: .leading) {
                        Text("Player On")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                            
                        // For player coming on (player2)
                        PlayerSelectionView(event: event, team: team, isPlayer2: true)
                            .frame(maxWidth: .infinity)
                    }
                }
            }
        }
    }
}
