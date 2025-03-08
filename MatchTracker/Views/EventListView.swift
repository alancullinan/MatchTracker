//
//  EventListView.swift
//  MatchTracker
//
//  Created on 05/03/2025.
//

import SwiftUI
import SwiftData

struct EventListView: View {
    // The match containing events to display
    @Bindable var match: Match
    
    // Used to dismiss the view when presented modally
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            List {
                if match.events.isEmpty {
                    Text("No events recorded yet")
                        .foregroundColor(.secondary)
                        .padding(.vertical)
                } else {
                    ForEach(sortedEvents, id: \.id) { event in
                        EventRow(event: event)
                    }
                    .onDelete(perform: deleteEvents)
                }
            }
            .navigationTitle("Match Events")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
    }
    
    // Computed property to sort events by period and then by time
    private var sortedEvents: [Event] {
        match.events.sorted { (event1, event2) -> Bool in
            // First, sort by period
            let period1Index = MatchPeriod.allCases.firstIndex(of: event1.period) ?? 0
            let period2Index = MatchPeriod.allCases.firstIndex(of: event2.period) ?? 0
            
            if period1Index != period2Index {
                return period1Index < period2Index
            }
            
            // If same period, sort by time elapsed
            return event1.timeElapsed < event2.timeElapsed
        }
    }
    
    // Function to delete events at specific indices
    private func deleteEvents(at offsets: IndexSet) {
        // Delete the events at the specified offsets using our sorted array
        for index in offsets {
            if let eventIndex = match.events.firstIndex(where: { $0.id == sortedEvents[index].id }) {
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
        case .periodStart:
            return "Period Start"
        case .periodEnd:
            return "Period End"
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
