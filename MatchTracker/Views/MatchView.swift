import SwiftUI
import SwiftData

struct MatchView: View {
    @Bindable var match: Match
    @State private var showingPlayersList = false
    @State private var showingEventsList = false
    @State private var showingSettings = false
    @State private var selectedTeam: Team?
    
    var body: some View {
        VStack {
            // Match timer and core functionality
            MatchTimerView(match: match)
            
            // Team scoring sections with player buttons
            ScrollView {
                VStack(spacing: 16) {
                    TeamScoringView(match: match, team: match.team1)
                        .overlay(alignment: .topTrailing) {
                            Button(action: {
                                selectedTeam = match.team1
                                showingPlayersList = true
                            }) {
                                Image(systemName: "person.2")
                                    .padding(8)
                                    .background(Color.secondary.opacity(0.2))
                                    .clipShape(Circle())
                            }
                            .padding(8)
                        }
                    
                    TeamScoringView(match: match, team: match.team2)
                        .overlay(alignment: .topTrailing) {
                            Button(action: {
                                selectedTeam = match.team2
                                showingPlayersList = true
                            }) {
                                Image(systemName: "person.2")
                                    .padding(8)
                                    .background(Color.secondary.opacity(0.2))
                                    .clipShape(Circle())
                            }
                            .padding(8)
                        }
                }
                .padding(.horizontal)
            }
            
            // Latest event display with View All button
            VStack {
                Divider()
                
                HStack {
                    if let latestEvent = match.sortedEventsByRecent.first {
                        EventRow(event: latestEvent)
                            .padding(.vertical, 4)
                            .padding(.horizontal, 8)
                    } else {
                        Text("No events recorded")
                            .padding()
                            .foregroundColor(.secondary)
                    }
                    
                    Spacer()
                    
                    Button(action: {
                        showingEventsList = true
                    }) {
                        Image(systemName: "list.bullet")
                            .padding(8)
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .clipShape(Circle())
                    }
                }
                .padding(.horizontal)
                .padding(.vertical, 8)
                .background(Color(UIColor.secondarySystemBackground))
            }
        }
        .navigationTitle(match.competition.isEmpty ? "Match" : match.competition)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {
                    showingSettings = true
                }) {
                    Image(systemName: "gearshape")
                }
            }
        }
        .sheet(isPresented: $showingEventsList) {
            NavigationView {
                EventListView(match: match)
                    .navigationBarItems(trailing: Button("Done") {
                        showingEventsList = false
                    })
            }
        }
        .sheet(isPresented: $showingPlayersList) {
            if let team = selectedTeam {
                NavigationView {
                    PlayerManagementView(team: team)
                        .navigationTitle("\(team.name) Players")
                        .navigationBarItems(trailing: Button("Done") {
                            showingPlayersList = false
                        })
                }
            }
        }
        .sheet(isPresented: $showingSettings) {
            NavigationView {
                MatchSettingsView(match: match)
                    .navigationTitle("Match Settings")
                    .navigationBarItems(trailing: Button("Done") {
                        showingSettings = false
                    })
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
