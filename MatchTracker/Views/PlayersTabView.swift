//
//  PlayersTabView.swift
//  MatchTracker
//
//  Created by Alan Cullinan on 11/03/2025.
//

import SwiftUI
import SwiftData

struct PlayersTabView: View {
    @Bindable var match: Match
    @State private var selectedTeamIndex = 0
    
    var body: some View {
        VStack {
            Text("Players").font(.title)
            // Team selector
            Picker("Team", selection: $selectedTeamIndex) {
                Text(match.team1.name.isEmpty ? "Team 1" : match.team1.name).tag(0)
                Text(match.team2.name.isEmpty ? "Team 2" : match.team2.name).tag(1)
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding(.top)
            
            // Show players based on selected team
            if selectedTeamIndex == 0 {
                PlayerManagementView(team: match.team1)
            } else {
                PlayerManagementView(team: match.team2)
            }
        }
    }
}
