//
//  MatchTabView.swift
//  MatchTracker
//
//  Created by Alan Cullinan on 11/03/2025.
//

import SwiftUI
import SwiftData

struct MatchTabView: View {
    @Bindable var match: Match
    
    var body: some View {
        VStack {
            // Competition title
            if !match.competition.isEmpty {
                Text(match.competition)
                    .font(.title3)
                    .fontWeight(.bold)
                    .padding(.top, 4)
            }
            
            // Timer view
            MatchTimerView(match: match)
                .padding(.bottom, 10)
            
            ScrollView {
                // Team 1 scoring view
                TeamScoringView(match: match, team: match.team1)
                    .padding(.horizontal)
                    .padding(.bottom, 16)
                
                // Team 2 scoring view
                TeamScoringView(match: match, team: match.team2)
                    .padding(.horizontal)
                    .padding(.bottom, 8)
            }
        }
    }
}
