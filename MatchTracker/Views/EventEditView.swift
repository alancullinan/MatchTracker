//
//  EventEditView
//  MatchTracker
//
//  Created by Alan Cullinan on 15/03/2025.
//
// Create a new file called EventEditView.swift
import SwiftUI
import SwiftData

struct EventEditView: View {
    @Bindable var match: Match
    let event: Event
    var onSave: () -> Void
    var onCancel: () -> Void
    
    // State variables for editing event properties
    @State private var shotOutcome: ShotOutcome
    @State private var shotType: ShotType
    @State private var foulOutcome: FoulOutcome
    @State private var cardType: CardType
    @State private var wonOwnKickout: Bool
    @State private var noteText: String
    @State private var player1Selection: Player?
    @State private var player2Selection: Player?
    
    // Initialize state from the event being edited
    init(match: Match, event: Event, onSave: @escaping () -> Void, onCancel: @escaping () -> Void) {
        self.match = match
        self.event = event
        self.onSave = onSave
        self.onCancel = onCancel
        
        // Initialize state values from the event
        _shotOutcome = State(initialValue: event.shotOutcome ?? .wide)
        _shotType = State(initialValue: event.shotType ?? .fromPlay)
        _foulOutcome = State(initialValue: event.foulOutcome ?? .free)
        _cardType = State(initialValue: event.cardType ?? .yellow)
        _wonOwnKickout = State(initialValue: event.wonOwnKickout ?? true)
        _noteText = State(initialValue: event.noteText ?? "")
        _player1Selection = State(initialValue: event.player1)
        _player2Selection = State(initialValue: event.player2)
    }
    
    var body: some View {
        Form {
            // Common information (non-editable)
            Section(header: Text("Basic Information")) {
                Text("Team: \(event.team?.name ?? "Unknown")")
                Text("Time: \(formatTime(event.timeElapsed))")
                Text("Period: \(event.period.rawValue)")
            }
            
            // Event-specific editable fields
            switch event.type {
            case .shot:
                shotSection
            case .foulConceded:
                foulSection
            case .card:
                cardSection
            case .kickout:
                kickoutSection
            case .substitution:
                substitutionSection
            case .note:
                noteSection
            default:
                EmptyView()
            }
            
            // Notes section available for all event types
            if event.type != .note {
                Section(header: Text("Additional Notes")) {
                    TextField("Optional notes", text: $noteText, axis: .vertical)
                        .lineLimit(3...5)
                }
            }
            
            // Save button
            Section {
                Button("Update Event") {
                    updateEvent()
                }
                .frame(maxWidth: .infinity)
                .foregroundColor(.blue)
            }
            
            // Delete button
            Section {
                Button("Delete Event") {
                    deleteEvent()
                }
                .frame(maxWidth: .infinity)
                .foregroundColor(.red)
            }
        }
        .toolbar {
            ToolbarItem(placement: .cancellationAction) {
                Button("Cancel") {
                    onCancel()
                }
            }
        }
    }
    
    private var eventTitle: String {
        switch event.type {
        case .foulConceded: return "Edit Foul"
        case .card: return "Edit Card"
        case .kickout: return "Edit Kickout"
        case .substitution: return "Edit Substitution"
        case .note: return "Edit Note"
        case .shot: return "Edit Shot"
        default: return "Edit Event"
        }
    }
    
    // MARK: - Event Type Sections
    
    private var shotSection: some View {
        Section(header: Text("Shot Details")) {
            Picker("Outcome", selection: $shotOutcome) {
                Text("Wide").tag(ShotOutcome.wide)
                Text("Saved").tag(ShotOutcome.saved)
                Text("Dropped Short").tag(ShotOutcome.droppedShort)
                Text("Hit Post").tag(ShotOutcome.offPost)
                Text("Goal").tag(ShotOutcome.goal)
                Text("Point").tag(ShotOutcome.point)
                if match.matchType == .football {
                    Text("Two-Pointer").tag(ShotOutcome.twoPointer)
                }
            }
            
            Picker("Shot Type", selection: $shotType) {
                Text("From Play").tag(ShotType.fromPlay)
                Text("Free").tag(ShotType.free)
                Text("Penalty").tag(ShotType.penalty)
                Text("45m/65m").tag(ShotType.fortyFive)
                Text("Sideline").tag(ShotType.sideline)
                if match.matchType == .football || match.matchType == .ladiesFootball {
                    Text("Mark").tag(ShotType.mark)
                }
            }
            
            // Only show player picker if the team has players and a team is associated with the event
            if let team = event.team, !team.players.isEmpty {
                Picker("Player", selection: $player1Selection) {
                    Text("Not Specified").tag(nil as Player?)
                    ForEach(team.players.sorted(by: { $0.jerseyNumber < $1.jerseyNumber }), id: \.id) { player in
                        Text("#\(player.jerseyNumber) \(player.name)").tag(player as Player?)
                    }
                }
            }
        }
    }
    
    // Include other section views (foulSection, cardSection, etc.) similar to EventDetailView
    // but adapted for editing
    
    private var foulSection: some View {
        Section(header: Text("Foul Details")) {
            Picker("Outcome", selection: $foulOutcome) {
                Text("Free").tag(FoulOutcome.free)
                Text("Penalty").tag(FoulOutcome.penalty)
            }
            .pickerStyle(SegmentedPickerStyle())
            
            // Only show player picker if the team has players and a team is associated with the event
            if let team = event.team, !team.players.isEmpty {
                Picker("Player", selection: $player1Selection) {
                    Text("Not Specified").tag(nil as Player?)
                    ForEach(team.players, id: \.id) { player in
                        Text("#\(player.jerseyNumber) \(player.name)").tag(player as Player?)
                    }
                }
            }
        }
    }
    
    private var cardSection: some View {
        Section(header: Text("Card Details")) {
            Picker("Card Type", selection: $cardType) {
                Text("Yellow").tag(CardType.yellow)
                Text("Red").tag(CardType.red)
                Text("Black").tag(CardType.black)
            }
            .pickerStyle(SegmentedPickerStyle())
            
            // Only show player picker if the team has players and a team is associated with the event
            if let team = event.team, !team.players.isEmpty {
                Picker("Player", selection: $player1Selection) {
                    Text("Not Specified").tag(nil as Player?)
                    ForEach(team.players, id: \.id) { player in
                        Text("#\(player.jerseyNumber) \(player.name)").tag(player as Player?)
                    }
                }
            }
        }
    }
    
    private var kickoutSection: some View {
        Section(header: Text("Kickout Details")) {
            Picker("Outcome", selection: $wonOwnKickout) {
                Text("Won Own Kickout").tag(true)
                Text("Lost Own Kickout").tag(false)
            }
            .pickerStyle(SegmentedPickerStyle())
        }
    }
    
    private var substitutionSection: some View {
        Section(header: Text("Substitution Details")) {
            if let team = event.team, !team.players.isEmpty {
                Picker("Player Coming Off", selection: $player1Selection) {
                    Text("Select Player").tag(nil as Player?)
                    ForEach(team.players, id: \.id) { player in
                        Text("#\(player.jerseyNumber) \(player.name)").tag(player as Player?)
                    }
                }
                
                Picker("Player Coming On", selection: $player2Selection) {
                    Text("Select Player").tag(nil as Player?)
                    ForEach(team.players, id: \.id) { player in
                        Text("#\(player.jerseyNumber) \(player.name)").tag(player as Player?)
                    }
                }
            } else {
                Text("No players available")
                    .foregroundColor(.secondary)
            }
        }
    }
    
    private var noteSection: some View {
        Section(header: Text("Notes")) {
            TextField("Enter note details", text: $noteText, axis: .vertical)
                .lineLimit(5...10)
        }
    }
    
    // MARK: - Helper Methods
    
    private func formatTime(_ seconds: Int) -> String {
        let minutes = seconds / 60
        let remainingSeconds = seconds % 60
        return String(format: "%02d:%02d", minutes, remainingSeconds)
    }
    
    private func updateEvent() {
        // Update event properties based on event type
        switch event.type {
        case .shot:
            event.shotOutcome = shotOutcome
            event.shotType = shotType
        case .foulConceded:
            event.foulOutcome = foulOutcome
        case .card:
            event.cardType = cardType
        case .kickout:
            event.wonOwnKickout = wonOwnKickout
        case .substitution:
            // For substitution, we only update player references
            break
        case .note:
            // For notes, we only update text
            break
        default:
            // For other event types, we don't need to update type-specific fields
            break
        }
        
        // Update common fields
        event.player1 = player1Selection
        event.player2 = player2Selection
        event.noteText = noteText.isEmpty ? nil : noteText
        
        // Notify that the event was saved
        onSave()
    }
    
    private func deleteEvent() {
        // Find and remove the event from the match's events array
        if let index = match.events.firstIndex(where: { $0.id == event.id }) {
            match.events.remove(at: index)
        }
        
        // Close the editor
        onSave()
    }
}
