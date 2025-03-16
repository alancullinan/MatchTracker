import SwiftUI
import SwiftData

struct EventDetailView: View {
    @Bindable var match: Match
    let team: Team
    let eventType: EventType
    var onSave: () -> Void
    var onCancel: () -> Void
    
    // Fields for different event types
    @State private var shotOutcome: ShotOutcome = .wide
    @State private var shotType: ShotType = .fromPlay
    @State private var foulOutcome: FoulOutcome = .free
    @State private var cardType: CardType = .yellow
    @State private var wonOwnKickout: Bool = true
    @State private var noteText: String = ""
    @State private var player1Selection: Player? = nil
    @State private var player2Selection: Player? = nil
    
    var body: some View {
        Form {
            // Common information
            Section(header: Text("Basic Information")) {
                Text("Team: \(team.name)")
                Text("Time: \(formatTime(match.elapsedTime))")
                Text("Period: \(match.matchPeriod.rawValue)")
            }
            
            // Event-specific fields
            switch eventType {
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
            if eventType != .note {
                Section(header: Text("Additional Notes")) {
                    TextField("Optional notes", text: $noteText, axis: .vertical)
                        .lineLimit(3...5)
                }
            }
        }
        .navigationTitle(eventTitle)
        .navigationBarBackButtonHidden(true)  // Hide the back button
        .toolbar {
            // Only add the Save button on the right
            ToolbarItem(placement: .confirmationAction) {
                Button("Save") {
                    saveEvent()
                    onSave()
                }
            }
            
            // Add a custom Cancel/Back button on the left
            ToolbarItem(placement: .cancellationAction) {
                Button("Back") {
                    onCancel()
                }
            }
        }
    }
    
    private var eventTitle: String {
        switch eventType {
        case .foulConceded: return "Record Foul"
        case .card: return "Record Card"
        case .kickout: return "Record Kickout"
        case .substitution: return "Record Substitution"
        case .note: return "Add Note"
        default: return "Record Event"
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
            }
            .pickerStyle(SegmentedPickerStyle())
            
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
            
            if !team.players.isEmpty {
                Picker("Player", selection: $player1Selection) {
                    Text("Not Specified").tag(nil as Player?)
                    ForEach(team.sortedPlayers, id: \.id) { player in
                        Text("#\(player.jerseyNumber) \(player.name)").tag(player as Player?)
                    }
                }
            }
        }
    }
    
    private var foulSection: some View {
        Section(header: Text("Foul Details")) {
            Picker("Outcome", selection: $foulOutcome) {
                Text("Free").tag(FoulOutcome.free)
                Text("Penalty").tag(FoulOutcome.penalty)
            }
            .pickerStyle(SegmentedPickerStyle())
            
            if !team.players.isEmpty {
                Picker("Player", selection: $player1Selection) {
                    Text("Not Specified").tag(nil as Player?)
                    ForEach(team.sortedPlayers, id: \.id) { player in
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
            
            if !team.players.isEmpty {
                Picker("Player", selection: $player1Selection) {
                    Text("Not Specified").tag(nil as Player?)
                    ForEach(team.sortedPlayers, id: \.id) { player in
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
            if team.players.isEmpty {
                Text("No players available. Add players to team first.")
                    .foregroundColor(.secondary)
            } else {
                Picker("Player Coming Off", selection: $player1Selection) {
                    Text("Select Player").tag(nil as Player?)
                    ForEach(team.sortedPlayers, id: \.id) { player in
                        Text("#\(player.jerseyNumber) \(player.name)").tag(player as Player?)
                    }
                }
                
                Picker("Player Coming On", selection: $player2Selection) {
                    Text("Select Player").tag(nil as Player?)
                    ForEach(team.sortedPlayers, id: \.id) { player in
                        Text("#\(player.jerseyNumber) \(player.name)").tag(player as Player?)
                    }
                }
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
    
    private func saveEvent() {
        let event = Event(
            type: eventType,
            period: match.matchPeriod,
            timeElapsed: match.elapsedTime,
            player1: player1Selection,
            player2: player2Selection,
            team: team,
            shotOutcome: eventType == .shot ? shotOutcome : nil,
            shotType: eventType == .shot ? shotType : nil,
            foulOutcome: eventType == .foulConceded ? foulOutcome : nil,
            cardType: eventType == .card ? cardType : nil,
            wonOwnKickout: eventType == .kickout ? wonOwnKickout : nil,
            noteText: noteText.isEmpty ? nil : noteText
        )
        
        match.events.append(event)
        onSave()
    }
}
