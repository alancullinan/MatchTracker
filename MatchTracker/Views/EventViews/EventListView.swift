//
//  EventsTabView.swift
//  MatchTracker
//
//  Created on 05/03/2025.
//

import SwiftUI
import SwiftData

struct EventListView: View {
    @Bindable var match: Match
    @Environment(\.dismiss) private var dismiss
    
    // Add state variables for editing
    @State private var selectedEvent: Event? = nil
    @State private var showingEventEditor = false
    
    var body: some View {
        NavigationView {
            List {
                if match.events.isEmpty {
                    Text("No events recorded yet")
                        .foregroundColor(.secondary)
                        .padding(.vertical)
                } else {
                    ForEach(match.sortedEventsByRecent, id: \.id) { event in
                        EventRow(event: event, match: match)
                            .contentShape(Rectangle()) // Make the entire row tappable
                            .onTapGesture {
                                selectedEvent = event
                                showingEventEditor = true
                            }
                    }
                    .onDelete(perform: deleteEvents)
                }
            }
            .sheet(isPresented: $showingEventEditor, onDismiss: {
                selectedEvent = nil
            }) {
                if let event = selectedEvent {
                    NavigationView {
                        EventEditView(
                            match: match,
                            event: event,
                            onSave: {
                                showingEventEditor = false
                            }
                            // Remove the onCancel parameter here
                        )
                    }
                }
            }
        }
    }
    
    // Function to delete events at specific indices
    private func deleteEvents(at offsets: IndexSet) {
        // Delete the events at the specified offsets using our sorted array
        for index in offsets {
            if let eventIndex = match.events.firstIndex(where: { $0.id == match.sortedEventsByRecent[index].id }) {
                match.events.remove(at: eventIndex)
            }
        }
    }
}

// EventRow in EventListView.swift
struct EventRow: View {
    let event: Event
    let match: Match // We need match to calculate running score
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            // Top line: Team name, time and period
            HStack {
                // Team name on the left
                if let team = event.team {
                    Text(team.name)
                        .font(.headline)
                }
                
                Spacer()
                
                // Time and period in smaller text on the right
                Text(formatTime(event.timeElapsed))
                    .font(.caption)
                
//                Text("•")
//                    .font(.caption)
//                    .foregroundColor(.secondary)
                
                Text(event.period.rawValue)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            // Second line: Event description
            Text(displayTextForEvent(event))
                .font(.subheadline)
                .foregroundColor(.primary)
            
            // Show running score if this was a scoring event or period end
            if event.type == .shot,
               let outcome = event.shotOutcome,
               [.goal, .point, .twoPointer].contains(outcome) {
                Text(formatRunningScore())
                    .font(.subheadline)
                    .foregroundColor(.blue)
                    .padding(.top, 2)
                    .lineLimit(2)
            } else if event.type == .periodEnd {
                Text(formatRunningScore())
                    .font(.subheadline)
                    .foregroundColor(.blue)
                    .padding(.top, 2)
                    .lineLimit(2)
            }
            
            // Show player 1 if available
            if let player = event.player1 {
                Text("#\(player.jerseyNumber) \(player.name)")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }

            // Show player 2 if available (for substitutions)
            if let player = event.player2 {
                Text("for #\(player.jerseyNumber) \(player.name)")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            // Show shot type if applicable
            if let shotType = event.shotType, event.type == .shot {
                Text(formatShotType(shotType))
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            // Show notes if available
            if let notes = event.noteText, !notes.isEmpty {
                Text(notes)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
        .padding(.vertical, 6)
    }
    
    // Helper to format time as MM:SS
    private func formatTime(_ seconds: Int) -> String {
        let minutes = seconds / 60
        let remainingSeconds = seconds % 60
        return String(format: "%02d:%02d", minutes, remainingSeconds)
    }
    
    // Helper to get the display text for an event
    private func displayTextForEvent(_ event: Event) -> String {
        // For shot events, display based on outcome
        if event.type == .shot, let outcome = event.shotOutcome {
            switch outcome {
            case .goal:
                return "Goal"
            case .point:
                return "Point"
            case .twoPointer:
                return "2 Point"
            case .wide:
                return "Wide"
            case .saved:
                return "Saved"
            case .droppedShort:
                return "Short"
            case .offPost:
                return "Off Post"
            }
        }
        
        // For other event types
        switch event.type {
        case .periodEnd:
                // You might want to customize how period ends are displayed
                switch event.period {
                case .firstHalf:
                    return "Half Time"
                case .secondHalf:
                    return "Full Time"
                case .extraTimeFirstHalf:
                    return "Half Time (ET)"
                case .extraTimeSecondHalf:
                    return "Full Time (ET)"
                default:
                    return "Period End"
                }
        case .substitution:
            return "Substitution"
        case .kickout:
            return "Kickout"
        case .card:
            if let cardType = event.cardType {
                return "\(cardType.rawValue.capitalized) Card"
            }
            return "Card"
        case .foulConceded:
            return "Foul"
        case .note:
            return "Note"
        default:
            return event.type.rawValue.capitalized
        }
    }
    
    // Helper to format shot type
    private func formatShotType(_ type: ShotType) -> String {
        switch type {
        case .fromPlay:
            return "From Play"
        case .free:
            return "Free"
        case .penalty:
            return "Penalty"
        case .fortyFive:
            return "45m"
        case .sixtyFive:
            return "65m"
        case .sideline:
            return "Sideline"
        case .mark:
            return "Mark"
        }
    }
    
    // Calculate and format the running score up to and including this event
    private func formatRunningScore() -> String {
        // Get all events up to and including the current event
        let eventsUpToThis = match.events.filter { matchEvent in
            // First filter by period
            let periodIndex = MatchPeriod.allCases.firstIndex(of: matchEvent.period) ?? 0
            let thisEventPeriodIndex = MatchPeriod.allCases.firstIndex(of: event.period) ?? 0
            
            if periodIndex < thisEventPeriodIndex {
                // Include all events from earlier periods
                return true
            } else if periodIndex > thisEventPeriodIndex {
                // Exclude events from later periods
                return false
            } else {
                // For events in the same period, include only those with elapsed time <= this event
                return matchEvent.timeElapsed <= event.timeElapsed
            }
        }
        
        // Calculate scores for both teams based on filtered events
        var team1Goals = 0
        var team1Points = 0
        var team2Goals = 0
        var team2Points = 0
        
        for matchEvent in eventsUpToThis {
            if matchEvent.type == .shot,
               let outcome = matchEvent.shotOutcome,
               let team = matchEvent.team {
                
                if team.id == match.team1.id {
                    if outcome == .goal {
                        team1Goals += 1
                    } else if outcome == .point {
                        team1Points += 1
                    } else if outcome == .twoPointer {
                        team1Points += 2
                    }
                } else if team.id == match.team2.id {
                    if outcome == .goal {
                        team2Goals += 1
                    } else if outcome == .point {
                        team2Points += 1
                    } else if outcome == .twoPointer {
                        team2Points += 2
                    }
                }
            }
        }
        
        // Format each team's score on a separate line
        return "\(match.team1.name): \(team1Goals)-\(team1Points)\n\(match.team2.name): \(team2Goals)-\(team2Points)"
    }
}

// Preview provider for SwiftUI canvas
#Preview {
    // Create a sample match with events for preview
    let match = Match()
    let team1 = Team(name: "Home Team")
    
    // Add sample events
    let periodStartEvent = Event(
        type: .periodStart,
        period: .firstHalf,
        timeElapsed: 0
    )
    
    let periodEndEvent = Event(
        type: .periodEnd,
        period: .firstHalf,
        timeElapsed: 1800
    )
    
    match.events = [periodStartEvent, periodEndEvent]
    
    return EventListView(match: match)
}
