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

// A row to display a single event
struct EventRow: View {
    let event: Event
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack {
                // Display the time in MM:SS format
                Text(formatTime(event.timeElapsed))
                    .font(.headline)
                    .foregroundColor(.primary)
                    .frame(width: 60, alignment: .leading)
                
                // Display the period with a colored capsule background
                Text(event.period.rawValue)
                    .font(.caption)
                    .padding(.horizontal, 6)
                    .padding(.vertical, 2)
                    .background(periodColor(event.period))
                    .foregroundColor(.white)
                    .cornerRadius(8)
                
                Spacer()
                
                // Event type label with appropriate icon
                HStack(spacing: 4) {
                    Image(systemName: iconForEventType(event.type))
                    Text(formatEventType(event.type))
                }
                .font(.subheadline)
                .foregroundColor(colorForEventType(event.type))
            }
            
            // Second row with team and details
            if let team = event.team {
                HStack {
                    Text(team.name)
                        .font(.subheadline)
                        .fontWeight(.medium)
                    
                    if event.type == .shot, let outcome = event.shotOutcome {
                        Spacer()
                        Text(outcome.rawValue)
                            .font(.caption)
                            .padding(.horizontal, 6)
                            .padding(.vertical, 2)
                            .background(colorForShotOutcome(outcome))
                            .foregroundColor(.white)
                            .cornerRadius(8)
                    }
                }
            }
            
            // Shot type if applicable
            if event.type == .shot, let shotType = event.shotType {
                Text(shotType.rawValue)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            // Show notes if available
            if let notes = event.noteText, !notes.isEmpty {
                Text(notes)
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .padding(.top, 2)
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
    
    // Helper to format event type for display
    private func formatEventType(_ type: EventType) -> String {
        switch type {
        case .periodStart:
            return "Period Start"
        case .periodEnd:
            return "Period End"
        case .shot:
            return "Shot"
        case .substitution:
            return "Sub"
        case .kickout:
            return "Kickout"
        case .card:
            return "Card"
        case .foulConceded:
            return "Foul"
        case .note:
            return "Note"
        }
    }
    
    // Helper to get icon for event type
    private func iconForEventType(_ type: EventType) -> String {
        switch type {
        case .periodStart:
            return "play.circle"
        case .periodEnd:
            return "stop.circle"
        case .shot:
            return "target"
        case .substitution:
            return "arrow.left.arrow.right"
        case .kickout:
            return "sportscourt"
        case .card:
            return "rectangle.fill"
        case .foulConceded:
            return "exclamationmark.triangle"
        case .note:
            return "note.text"
        }
    }
    
    // Helper to get color for event type
    private func colorForEventType(_ type: EventType) -> Color {
        switch type {
        case .periodStart:
            return .green
        case .periodEnd:
            return .orange
        case .shot:
            return .blue
        case .substitution:
            return .purple
        case .kickout:
            return .teal
        case .card:
            return .yellow
        case .foulConceded:
            return .red
        case .note:
            return .gray
        }
    }
    
    // Helper to get color for period
    private func periodColor(_ period: MatchPeriod) -> Color {
        switch period {
        case .notStarted:
            return .gray
        case .firstHalf:
            return .blue
        case .halfTime:
            return .orange
        case .secondHalf:
            return .green
        case .fullTime:
            return .purple
        case .extraTimeFirstHalf:
            return .pink
        case .extraTimeHalfTime:
            return .orange
        case .extraTimeSecondHalf:
            return .indigo
        case .matchOver:
            return .gray
        }
    }
    
    // Helper to get color for shot outcome
    private func colorForShotOutcome(_ outcome: ShotOutcome) -> Color {
        switch outcome {
        case .score:
            return .green
        case .wide:
            return .red
        case .saved:
            return .orange
        case .droppedShort:
            return .yellow
        case .offPost:
            return .purple
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
