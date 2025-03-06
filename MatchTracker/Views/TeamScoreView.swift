//
//  TeamScoreView.swift
//  MatchTracker
//
//  Created by Alan Cullinan on 06/03/2025.

import SwiftUI
import SwiftData

struct TeamScoringView: View {
    @Bindable var match: Match
    let team: Team
    
    var body: some View {
        VStack(spacing: 12) {
            // Team name
            Text(team.name.isEmpty ? "Team" : team.name)
                .font(.headline)
                .fontWeight(.bold)
            
            // Score display
            Text(scoreDisplay)
                .font(.system(size: 32, weight: .bold, design: .rounded))
            
            // Scoring buttons
            HStack(spacing: 8) {
                // Goal button
                Button(action: { recordScore(outcome: .goal) }) {
                    VStack {
                        Text("G")
                            .font(.headline)
                        Text("3 pts")
                            .font(.caption)
                    }
                    .frame(width: 50, height: 50)
                    .background(Color.green)
                    .foregroundColor(.white)
                    .clipShape(Circle())
                }
                .disabled(!isPlayPeriod(match.matchPeriod))
                
                // Point button
                Button(action: { recordScore(outcome: .point) }) {
                    VStack {
                        Text("P")
                            .font(.headline)
                        Text("1 pt")
                            .font(.caption)
                    }
                    .frame(width: 50, height: 50)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .clipShape(Circle())
                }
                .disabled(!isPlayPeriod(match.matchPeriod))
                
                // Two-point button (only for football)
                if match.matchType == .football {
                    Button(action: { recordScore(outcome: .twoPointer) }) {
                        VStack {
                            Text("2P")
                                .font(.headline)
                            Text("2 pts")
                                .font(.caption)
                        }
                        .frame(width: 50, height: 50)
                        .background(Color.purple)
                        .foregroundColor(.white)
                        .clipShape(Circle())
                    }
                    .disabled(!isPlayPeriod(match.matchPeriod))
                }
            }
        }
        .padding()
        .background(Color(UIColor.secondarySystemBackground))
        .cornerRadius(12)
    }
    
    // Traditional GAA score format: goals-points (total)
    private var scoreDisplay: String {
        let scores = calculateTeamScores()
        return "\(scores.goals)-\(scores.points) (\(scores.total))"
    }
    
    private func recordScore(outcome: ShotOutcome) {
        // Create the event
        let event = Event(
            type: .shot,
            period: match.matchPeriod,
            timeElapsed: match.elapsedTime,
            team: team,
            shotOutcome: outcome,
            shotType: .fromPlay
        )
        
        // Add the event
        match.events.append(event)
    }
    
    private func calculateTeamScores() -> (goals: Int, points: Int, total: Int) {
        // Count goals (worth 3 points each)
        let goals = match.events.filter { event in
            event.type == .shot &&
            event.shotOutcome == .goal &&
            event.team?.id == team.id
        }.count
        
        // Count regular points (worth 1 point each)
        let regularPoints = match.events.filter { event in
            event.type == .shot &&
            event.shotOutcome == .point &&
            event.team?.id == team.id
        }.count
        
        // Count two-point scores (worth 2 points each)
        let twoPointScores = match.events.filter { event in
            event.type == .shot &&
            event.shotOutcome == .twoPointer &&
            event.team?.id == team.id
        }.count
        
        // Calculate total points (regular points + two-pointers)
        let totalPoints = regularPoints + (twoPointScores * 2)
        
        // Calculate total score value (goals worth 3 each)
        let totalScore = (goals * 3) + totalPoints
        
        return (goals, regularPoints + twoPointScores, totalScore)
    }
    
    private func isPlayPeriod(_ period: MatchPeriod) -> Bool {
        return period == .firstHalf || period == .secondHalf ||
               period == .extraTimeFirstHalf || period == .extraTimeSecondHalf
    }
}
