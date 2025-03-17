import SwiftUI
import SwiftData

struct TeamScoringView: View {
    @Bindable var match: Match
    let team: Team
    @State private var showEventTypeSelection = false
    
    var body: some View {
        VStack(spacing: 10) {
            // Team name with Record Event button overlay
            Text(team.name.isEmpty ? "Team" : team.name)
                .font(.title2)
                //.fontWeight(.bold)
            
            // Score and scoring buttons using GeometryReader for consistent proportions
            GeometryReader { geometry in
                HStack(spacing: 0) {
                    // Left section - Goal button (30% of width)
                    ZStack {
                        // Goal button (green flag)
                        Button(action: { recordScore(outcome: .goal) }) {
                            Image(systemName: "flag.fill")
                                .foregroundColor(.green)
                                .font(.system(size: 22))
                                .padding(.vertical, 12)
                                .padding(.horizontal, 12)
                                .background(Color.secondary.opacity(0.2))
                                .clipShape(Circle())
                        }
                        .disabled(!match.matchPeriod.isPlayPeriod || match.isPaused)
                    }
                    .frame(width: geometry.size.width * 0.3)
                    
                    // Center section - Score display (40% of width)
                    ZStack {
                        VStack(spacing: 0) {
                            // Slightly smaller score
                            Text(formattedMainScore)
                                .font(.system(size: 40))
                            Text("(\(formattedTotalScore))")
                                .font(.system(size: 14))
                                .foregroundColor(.secondary)
                        }
                    }
                    .frame(width: geometry.size.width * 0.4)
                    
                    // Right section - Point/2-Point buttons (30% of width)
                    ZStack {
                        HStack(spacing: 8) {
                            // Two-point button (orange flag - only for football)
                            if match.matchType == .football {
                                Button(action: { recordScore(outcome: .twoPointer) }) {
                                    Image(systemName: "flag.fill")
                                        .foregroundColor(.orange)
                                        .font(.system(size: 22))
                                        .padding(.vertical, 12)
                                        .padding(.horizontal, 12)
                                        .background(Color.secondary.opacity(0.2))
                                        .clipShape(Circle())
                                }
                                .disabled(!match.matchPeriod.isPlayPeriod || match.isPaused)
                            }
                            
                            // Point button (white flag with border for visibility)
                            Button(action: { recordScore(outcome: .point) }) {
                                Image(systemName: "flag.fill")
                                    .foregroundColor(.white)
                                    .font(.system(size: 22))
                                    .padding(.vertical, 12)
                                    .padding(.horizontal, 12)
                                    .background(Color.secondary.opacity(0.2))
                                    .clipShape(Circle())
                            }
                            .disabled(!match.matchPeriod.isPlayPeriod || match.isPaused)
                        }
                        .frame(maxWidth: .infinity)
                    }
                    .frame(width: geometry.size.width * 0.3)
                }
            }
            .frame(height: 70) // Set a fixed height for the GeometryReader
        }
        .padding()
        .background(Color(UIColor.secondarySystemBackground))
        .cornerRadius(12)
        .overlay(alignment: .topLeading) {
            Button(action: {
                showEventTypeSelection = true
            }) {
                HStack(spacing: 4) {
                    Image(systemName: "plus.circle")
                    Text("Event")
                        .font(.caption)
                        .fontWeight(.medium)
                }
                .padding(8)
                .background(Color.secondary.opacity(0.2))
                .cornerRadius(12)
            }
            .disabled(!match.matchPeriod.isPlayPeriod || match.isPaused)
            .padding(8)
        }
        .sheet(isPresented: $showEventTypeSelection) {
            EventTypeSelectionView(match: match, team: team, isPresented: $showEventTypeSelection)
        }
    }
    
    // Compute the scores once
    private var teamScores: (goals: Int, points: Int, total: Int) {
        calculateTeamScores()
    }
    
    // Format main score as goals-points
    private var formattedMainScore: String {
        "\(teamScores.goals)-\(teamScores.points)"
    }
    
    // Format total score
    private var formattedTotalScore: String {
        "\(teamScores.total)"
    }
    
    // Your existing methods remain unchanged
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
        let pointsCount = regularPoints + twoPointScores
        
        // Calculate total score value (goals worth 3 each)
        let totalScore = (goals * 3) + regularPoints + (twoPointScores * 2)
        
        return (goals, pointsCount, totalScore)
    }
}
