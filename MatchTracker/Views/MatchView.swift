// Updated MatchView.swift
import SwiftUI
import SwiftData

struct MatchView: View {
    // The match to display
    @Bindable var match: Match
    
    // State to control navigation to edit view and event list
    @State private var showingEventList = false
    
    // Used to navigate back programmatically if needed
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        VStack {
            // Timer view
            MatchTimerView(match: match)
                .padding(.bottom, 10)
            
            ScrollView {
                // Team 1 scoring view
                TeamScoringView(match: match, team: match.team1)
                    .padding(.horizontal)
                    .padding(.bottom, 8)
                
                // Team 2 scoring view
                TeamScoringView(match: match, team: match.team2)
                    .padding(.horizontal)
                    .padding(.bottom, 8)
            }
            
            Spacer()
            
            // Event List Button
            Button(action: {
                showingEventList = true
            }) {
                HStack {
                    Image(systemName: "list.bullet")
                    Text("View Events")
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(10)
                .padding(.horizontal)
            }
            .padding(.bottom)
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                NavigationLink(destination: EditMatchView(match: match)) {
                    Text("Edit")
                }
            }
        }
        .sheet(isPresented: $showingEventList) {
            EventListView(match: match)
        }
    }
}


// Add this at the bottom of MatchView.swift
#Preview {
    // Create a sample match with teams and some events for preview
    let match = Match()
    match.competition = "County Championship"
    match.matchPeriod = .firstHalf
    match.currentPeriodStart = Date()
    
    // Create teams
    let homeTeam = Team(name: "Dublin")
    let awayTeam = Team(name: "Kerry")
    match.team1 = homeTeam
    match.team2 = awayTeam
    
    // Add some sample events
    let periodStartEvent = Event(
        type: .periodStart,
        period: .firstHalf,
        timeElapsed: 0
    )
    
    let homeGoal = Event(
        type: .shot,
        period: .firstHalf,
        timeElapsed: 180,
        team: homeTeam,
        shotOutcome: .goal,
        shotType: .fromPlay
    )
    
    let homePoint = Event(
        type: .shot,
        period: .firstHalf,
        timeElapsed: 360,
        team: homeTeam,
        shotOutcome: .point,
        shotType: .fromPlay
    )
    
    let awayPoint = Event(
        type: .shot,
        period: .firstHalf,
        timeElapsed: 540,
        team: awayTeam,
        shotOutcome: .point,
        shotType: .fromPlay
    )
    
    match.events = [periodStartEvent, homeGoal, homePoint, awayPoint]
    
    // Return the view with the sample match
    return NavigationView {
        MatchView(match: match)
    }
}
