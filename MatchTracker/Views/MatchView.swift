import SwiftUI
import SwiftData

struct MatchView: View {
    @Bindable var match: Match
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        TabView {
            // Tab 1: Main match screen (using current content)
            mainMatchContent
                .tabItem {
                    Label("Match", systemImage: "stopwatch")
                }
            
            // Tab 2: Events list
            EventListView(match: match)
                .tabItem {
                    Label("Events", systemImage: "list.bullet")
                }
            
            // Tab 3: Team 1 Players
            PlayerManagementView(team: match.team1)
                .tabItem {
                    Label(match.team1.name, systemImage: "person.3")
                }
            
            // Tab 4: Team 2 Players
            PlayerManagementView(team: match.team2)
                .tabItem {
                    Label(match.team2.name, systemImage: "person.3")
                }
            
            // Tab 5: Match Settings
            MatchFormView(match: match)
                .tabItem {
                    Label("Settings", systemImage: "gearshape")
                }
        }
        .navigationTitle("")
        .navigationBarTitleDisplayMode(.inline) // This makes the title centered and smaller
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button {
                    dismiss()
                } label: {
                    HStack {
                        Image(systemName: "list.bullet")
                        Text("Matches")
                    }
                }
            }
        }
    }
    
    
    // Move your current MatchView content into this computed property
    private var mainMatchContent: some View {
        VStack {
            // Competition title
            if !match.competition.isEmpty {
                Text(match.competition)
                    .font(.title3)
                    .fontWeight(.bold)
                    .padding(.top, 4)
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
