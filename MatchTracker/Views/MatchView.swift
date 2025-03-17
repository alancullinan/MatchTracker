import SwiftUI
import SwiftData

struct MatchView: View {
    @Bindable var match: Match
    @State private var showingEventsList = false
    @State private var showingSettings = false
    
    // Separate state variables for each team
    @State private var showingTeam1Players = false
    @State private var showingTeam2Players = false
    
    @State private var selectedEvent: Event? = nil
    @State private var showingEventEditor = false
    
    var body: some View {
        VStack {
            // Match timer and core functionality
            MatchTimerView(match: match)
                .padding(.top)
            
            // Team scoring sections with player buttons
            ScrollView {
                VStack(spacing: 16) {
                    TeamScoringView(match: match, team: match.team1)
                        .overlay(alignment: .topTrailing) {
                            Button(action: {
                                showingTeam1Players = true
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
                                showingTeam2Players = true
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
                            .contentShape(Rectangle())
                            .onTapGesture {
                                selectedEvent = latestEvent
                                // Use a slight delay before setting the flag
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                                    showingEventEditor = true
                                }
                            }
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
            }
            .background(Color(UIColor.secondarySystemBackground).opacity(0.7))
            .cornerRadius(12)
            .padding(.horizontal)
            .padding(.bottom, 8)
        }
        .background(
            Image("grass-background")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .opacity(0.3)
                .edgesIgnoringSafeArea(.all)
        )
        .navigationTitle(match.competition.isEmpty ? "Match" : match.competition)
        .navigationBarTitleDisplayMode(.inline) // Add this line to center the title
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {
                    showingSettings = true
                }) {
                    Image(systemName: "gearshape")
                }
            }
        }
        // Separate sheets for each team
        .sheet(isPresented: $showingTeam1Players) {
            NavigationView {
                PlayerManagementView(team: match.team1)
                    .navigationTitle("\(match.team1.name) Players")
                    .navigationBarItems(trailing: Button("Done") {
                        showingTeam1Players = false
                    })
            }
        }
        .sheet(isPresented: $showingTeam2Players) {
            NavigationView {
                PlayerManagementView(team: match.team2)
                    .navigationTitle("\(match.team2.name) Players")
                    .navigationBarItems(trailing: Button("Done") {
                        showingTeam2Players = false
                    })
            }
        }
        .sheet(isPresented: Binding(
            get: { self.showingEventEditor },
            set: { self.showingEventEditor = $0 }
        ), onDismiss: {
            selectedEvent = nil
        }) {
            if let event = selectedEvent {
                NavigationView {
                    EventEditView(match: match, event: event, onSave: {
                        showingEventEditor = false
                    }, onCancel: {
                        showingEventEditor = false
                    })
                }
            }
        }
        .sheet(isPresented: $showingEventsList) {
            NavigationView {
                EventListView(match: match)
                    .navigationTitle("Match Events")
                    .navigationBarItems(trailing: Button("Done") {
                        showingEventsList = false
                    })
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
