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
                        EventRow(event: event)
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
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack {
                // Display the time in MM:SS format
                Text(formatTime(event.timeElapsed))
                    .font(.headline)
                    .frame(width: 60, alignment: .leading)
                
                // Display the period
                Text(event.period.rawValue)
                    .font(.caption)
                
                Spacer()
                
                // Event description (based on type and outcome)
                Text(displayTextForEvent(event))
                    .font(.subheadline)
            }
            
            // Show team name if available
            if let team = event.team {
                Text(team.name)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            
            // In EventRow in EventListView.swift, add this after the team display
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
