import SwiftUI
import SwiftData

struct MatchView: View {
    // The match to display
    @Bindable var match: Match
    
    // State to control navigation to edit view and event list
    @State private var showingEventList = false
    @State private var showingTeam1Players = false
    @State private var showingTeam2Players = false
    
    // Used to navigate back programmatically if needed
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        VStack {
            // Timer view
            MatchTimerView(match: match)
                .padding(.bottom, 10)
            
            ScrollView {
                // Team 1 scoring view and manage button
                VStack(spacing: 0) {
                    TeamScoringView(match: match, team: match.team1)
                    
                    Button("Manage \(match.team1.name) Players") {
                        showingTeam1Players = true
                    }
                    .padding(.horizontal)
                    .padding(.vertical, 8)
                    .frame(maxWidth: .infinity)
                    .background(Color.secondary.opacity(0.1))
                    .cornerRadius(8)
                }
                .padding(.horizontal)
                .padding(.bottom, 16)
                
                // Team 2 scoring view and manage button
                VStack(spacing: 0) {
                    TeamScoringView(match: match, team: match.team2)
                    
                    Button("Manage \(match.team2.name) Players") {
                        showingTeam2Players = true
                    }
                    .padding(.horizontal)
                    .padding(.vertical, 8)
                    .frame(maxWidth: .infinity)
                    .background(Color.secondary.opacity(0.1))
                    .cornerRadius(8)
                }
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
            
            ToolbarItem(placement: .navigationBarLeading) {
                Menu {
                    NavigationLink(destination: PlayerManagementView(team: match.team1)) {
                        Text("Manage \(match.team1.name) Players")
                    }
                    
                    NavigationLink(destination: PlayerManagementView(team: match.team2)) {
                        Text("Manage \(match.team2.name) Players")
                    }
                } label: {
                    Label("Manage Players", systemImage: "person.2")
                }
            }
        }
        .sheet(isPresented: $showingEventList) {
            EventListView(match: match)
        }
        .sheet(isPresented: $showingTeam1Players) {
            PlayerManagementView(team: match.team1)
        }
        .sheet(isPresented: $showingTeam2Players) {
            PlayerManagementView(team: match.team2)
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
