import SwiftUI
import SwiftData

struct MatchView: View {
    @Bindable var match: Match
    @Environment(\.dismiss) private var dismiss
    
    // Track the selected tab
    @State private var selectedTab: MatchTab = .match
    
    var body: some View {
        VStack(spacing: 0) {
            // Content area - shows different views based on selectedTab
            switch selectedTab {
            case .match:
                MatchTabView(match: match)
            case .events:
                EventsTabView(match: match)
            case .players:
                PlayersTabView(match: match)
            case .settings:
                SettingsTabView(match: match)
            }
            
            // Custom tab bar
            customTabBar
        }
        .navigationTitle("")
        .navigationBarBackButtonHidden(true)
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
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    selectedTab = .match
                } label: {
                    Text("Done")
                }
                .disabled(selectedTab == .match)
            }
        }
    }
}

// Extension for tab bar
extension MatchView {
    var customTabBar: some View {
        HStack(spacing: 0) {
            // Create a button for each tab
            ForEach(MatchTab.allCases, id: \.self) { tab in
                Button {
                    withAnimation {
                        selectedTab = tab
                    }
                } label: {
                    VStack(spacing: 4) {
                        Image(systemName: tab.iconName)
                            .font(.system(size: 22))
                        
                        Text(tab == .players ? "Players" : tab.rawValue)
                            .font(.caption)
                    }
                    .frame(maxWidth: .infinity)
                    .foregroundColor(selectedTab == tab ? .blue : .gray)
                    .padding(.vertical, 8)
                }
            }
        }
        .background(Color(UIColor.systemBackground))
        .overlay(
            Rectangle()
                .frame(height: 0.5)
                .foregroundColor(Color(UIColor.separator)),
            alignment: .top
        )
        .shadow(color: Color.black.opacity(0.15), radius: 3, x: 0, y: -2)
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
