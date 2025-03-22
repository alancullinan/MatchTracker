import SwiftUI
import SwiftData

// Shot details section
struct ShotDetailsSection: View {
    @Bindable var match: Match
    @Bindable var event: Event
    
    // Local state to handle optionals with defaults
    @State private var shotOutcome: ShotOutcome = .wide
    @State private var shotType: ShotType = .fromPlay
    
    init(match: Match, event: Event) {
        self.match = match
        self.event = event
        
        // Initialize state with current values or defaults
        _shotOutcome = State(initialValue: event.shotOutcome ?? .wide)
        _shotType = State(initialValue: event.shotType ?? .fromPlay)
    }
    
    var body: some View {
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
            .pickerStyle(SegmentedPickerStyle())
            .onChange(of: shotOutcome) { _, newValue in
                event.shotOutcome = newValue
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
            .onChange(of: shotType) { _, newValue in
                event.shotType = newValue
            }
            
            if let team = event.team, !team.players.isEmpty {
                let playerBinding = Binding<Player?>(
                    get: { self.event.player1 },
                    set: { self.event.player1 = $0 }
                )
                
                Picker("Player", selection: playerBinding) {
                    Text("Not Specified").tag(nil as Player?)
                    ForEach(team.sortedPlayers, id: \.id) { player in
                        Text("#\(player.jerseyNumber) \(player.name)").tag(player as Player?)
                    }
                }
            } else {
                Text("No players available")
                    .foregroundColor(.secondary)
            }
        }
    }
}

// Foul details section
struct FoulDetailsSection: View {
    @Bindable var match: Match
    @Bindable var event: Event
    
    // Local state for optional values
    @State private var foulOutcome: FoulOutcome = .free
    
    init(match: Match, event: Event) {
        self.match = match
        self.event = event
        _foulOutcome = State(initialValue: event.foulOutcome ?? .free)
    }
    
    var body: some View {
        Section(header: Text("Foul Details")) {
            Picker("Outcome", selection: $foulOutcome) {
                Text("Free").tag(FoulOutcome.free)
                Text("Penalty").tag(FoulOutcome.penalty)
            }
            .pickerStyle(SegmentedPickerStyle())
            .onChange(of: foulOutcome) { _, newValue in
                event.foulOutcome = newValue
            }
            
            if let team = event.team, !team.players.isEmpty {
                let playerBinding = Binding<Player?>(
                    get: { self.event.player1 },
                    set: { self.event.player1 = $0 }
                )
                
                Picker("Player", selection: playerBinding) {
                    Text("Not Specified").tag(nil as Player?)
                    ForEach(team.sortedPlayers, id: \.id) { player in
                        Text("#\(player.jerseyNumber) \(player.name)").tag(player as Player?)
                    }
                }
            } else {
                Text("No players available")
                    .foregroundColor(.secondary)
            }
        }
    }
}

// Card details section
struct CardDetailsSection: View {
    @Bindable var match: Match
    @Bindable var event: Event
    
    // Local state for optional values
    @State private var cardType: CardType = .yellow
    
    init(match: Match, event: Event) {
        self.match = match
        self.event = event
        _cardType = State(initialValue: event.cardType ?? .yellow)
    }
    
    var body: some View {
        Section(header: Text("Card Details")) {
            Picker("Card Type", selection: $cardType) {
                Text("Yellow").tag(CardType.yellow)
                Text("Red").tag(CardType.red)
                Text("Black").tag(CardType.black)
            }
            .pickerStyle(SegmentedPickerStyle())
            .onChange(of: cardType) { _, newValue in
                event.cardType = newValue
            }
            
            if let team = event.team, !team.players.isEmpty {
                let playerBinding = Binding<Player?>(
                    get: { self.event.player1 },
                    set: { self.event.player1 = $0 }
                )
                
                Picker("Player", selection: playerBinding) {
                    Text("Not Specified").tag(nil as Player?)
                    ForEach(team.sortedPlayers, id: \.id) { player in
                        Text("#\(player.jerseyNumber) \(player.name)").tag(player as Player?)
                    }
                }
            } else {
                Text("No players available")
                    .foregroundColor(.secondary)
            }
        }
    }
}

// Kickout details section
struct KickoutDetailsSection: View {
    @Bindable var match: Match
    @Bindable var event: Event
    
    // Local state for optional values
    @State private var wonOwnKickout: Bool = true
    
    init(match: Match, event: Event) {
        self.match = match
        self.event = event
        _wonOwnKickout = State(initialValue: event.wonOwnKickout ?? true)
    }
    
    var body: some View {
        Section(header: Text("Kickout Details")) {
            Picker("Outcome", selection: $wonOwnKickout) {
                Text("Won Own Kickout").tag(true)
                Text("Lost Own Kickout").tag(false)
            }
            .pickerStyle(SegmentedPickerStyle())
            .onChange(of: wonOwnKickout) { _, newValue in
                event.wonOwnKickout = newValue
            }
        }
    }
}

// Substitution details section
struct SubstitutionDetailsSection: View {
    @Bindable var match: Match
    @Bindable var event: Event
    
    var body: some View {
        Section(header: Text("Substitution Details")) {
            if let team = event.team, !team.players.isEmpty {
                let player1Binding = Binding<Player?>(
                    get: { self.event.player1 },
                    set: { self.event.player1 = $0 }
                )
                
                let player2Binding = Binding<Player?>(
                    get: { self.event.player2 },
                    set: { self.event.player2 = $0 }
                )
                
                Picker("Player Coming Off", selection: player1Binding) {
                    Text("Select Player").tag(nil as Player?)
                    ForEach(team.sortedPlayers, id: \.id) { player in
                        Text("#\(player.jerseyNumber) \(player.name)").tag(player as Player?)
                    }
                }
                
                Picker("Player Coming On", selection: player2Binding) {
                    Text("Select Player").tag(nil as Player?)
                    ForEach(team.sortedPlayers, id: \.id) { player in
                        Text("#\(player.jerseyNumber) \(player.name)").tag(player as Player?)
                    }
                }
            } else {
                Text("No players available. Add players to team first.")
                    .foregroundColor(.secondary)
            }
        }
    }
}

// Note details section
struct NoteDetailsSection: View {
    @Bindable var event: Event
    
    var body: some View {
        Section(header: Text("Notes")) {
            let noteBinding = Binding<String>(
                get: { self.event.noteText ?? "" },
                set: { self.event.noteText = $0.isEmpty ? nil : $0 }
            )
            
            TextField("Enter note details", text: noteBinding, axis: .vertical)
                .lineLimit(5...10)
        }
    }
}
