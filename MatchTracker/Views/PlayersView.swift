//
//  PlayersView.swift
//  MatchTracker
//

import SwiftUI
import SwiftData

// MARK: - Player Row Component
struct PlayerRow: View {
    @Bindable var player: Player
    
    var body: some View {
        HStack {
            Text("\(player.jerseyNumber)")
                .font(.headline)
                .frame(width: 32, height: 32)
                .background(Color.blue.opacity(0.8))
                .foregroundColor(.white)
                .cornerRadius(16)
                
            TextField("Player Name", text: $player.name)
                .textFieldStyle(RoundedBorderTextFieldStyle())
            
            Spacer()
        }
        .padding(.vertical, 4)
    }
}

// MARK: - Player Management View
struct PlayerManagementView: View {
    @Bindable var team: Team
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        List {
            // Use a sorted array of players
            ForEach(sortedPlayers) { player in
                PlayerRow(player: player)
            }
        }
    }
    
    // Computed property to sort players by jersey number
    private var sortedPlayers: [Player] {
        team.players.sorted { $0.jerseyNumber < $1.jerseyNumber }
    }
}

// MARK: - Players View (Team Selection)
struct PlayersView: View {
    @Bindable var match: Match
    @State private var selectedTeamIndex = 0
    
    var body: some View {
        VStack {
            // Team selector
            Picker("Team", selection: $selectedTeamIndex) {
                Text(match.team1.name.isEmpty ? "Team 1" : match.team1.name).tag(0)
                Text(match.team2.name.isEmpty ? "Team 2" : match.team2.name).tag(1)
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding()
            
            // Show players based on selected team
            if selectedTeamIndex == 0 {
                PlayerManagementView(team: match.team1)
            } else {
                PlayerManagementView(team: match.team2)
            }
        }
    }
}
