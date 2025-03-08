import SwiftUI
import SwiftData

struct TeamScoringView: View {
    @Bindable var match: Match
    let team: Team
    @State private var showEventTypeSelection = false
    
    var body: some View {
        VStack(spacing: 8) {
            // Team name
            Text(team.name.isEmpty ? "Team" : team.name)
                .font(.headline)
                .fontWeight(.bold)
            
            // Score display
            Text(scoreDisplay)
                .font(.system(size: 32, weight: .bold, design: .rounded))
            
            // Simple scoring buttons row
            HStack(spacing: 10) {
                // Goal button
                Button(action: { recordScore(outcome: .goal) }) {
                    Text("Goal")
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 8)
                        .background(Color.secondary.opacity(0.2))
                        .cornerRadius(8)
                }
                .disabled(!match.matchPeriod.isPlayPeriod)
                
                // Point button
                Button(action: { recordScore(outcome: .point) }) {
                    Text("Point")
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 8)
                        .background(Color.secondary.opacity(0.2))
                        .cornerRadius(8)
                }
                .disabled(!match.matchPeriod.isPlayPeriod)
                
                // Two-point button (only for football)
                if match.matchType == .football {
                    Button(action: { recordScore(outcome: .twoPointer) }) {
                        Text("2 Point")
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 8)
                            .background(Color.secondary.opacity(0.2))
                            .cornerRadius(8)
                    }
                    .disabled(!match.matchPeriod.isPlayPeriod)
                }
            }
            
            Divider()
                .padding(.vertical, 8)
            
            // Other events button
            Button(action: {
                showEventTypeSelection = true
            }) {
                HStack {
                    Image(systemName: "plus.circle")
                    Text("Record Event")
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 12)
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(8)
            }
            .disabled(!match.matchPeriod.isPlayPeriod)
        }
        .padding()
        .background(Color(UIColor.secondarySystemBackground))
        .cornerRadius(12)
        .sheet(isPresented: $showEventTypeSelection) {
            EventTypeSelectionView(match: match, team: team, isPresented: $showEventTypeSelection)
        }
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
        let pointsCount = regularPoints + twoPointScores
        
        // Calculate total score value (goals worth 3 each)
        let totalScore = (goals * 3) + regularPoints + (twoPointScores * 2)
        
        return (goals, pointsCount, totalScore)
    }
}
