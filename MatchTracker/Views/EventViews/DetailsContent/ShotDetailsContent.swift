//
//  ShotDetailsContent.swift
//  MatchTracker
//
//  Created by Alan Cullinan on 22/03/2025.
//


// ShotDetailsContent.swift
import SwiftUI
import SwiftData

struct ShotDetailsContent: View {
    @Bindable var match: Match
    @Bindable var event: Event
    
    // Local state for optional values
    @State private var shotOutcome: ShotOutcome
    @State private var shotType: ShotType
    
    init(match: Match, event: Event) {
        self.match = match
        self.event = event
        _shotOutcome = State(initialValue: event.shotOutcome ?? .wide)
        _shotType = State(initialValue: event.shotType ?? .fromPlay)
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Shot Details")
                .font(.headline)
            
            VStack(alignment: .leading, spacing: 10) {
                Text("Outcome")
                    .font(.subheadline)
                Picker("", selection: $shotOutcome) {
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
            }
            
            VStack(alignment: .leading, spacing: 10) {
                Text("Shot Type")
                    .font(.subheadline)
                Picker("", selection: $shotType) {
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
            }
            
            if let team = event.team, !team.players.isEmpty {
                VStack(alignment: .leading, spacing: 10) {
                    Text("Player")
                        .font(.subheadline)
                    
                    Menu {
                        Button("Not Specified") {
                            event.player1 = nil
                        }
                        ForEach(team.sortedPlayers, id: \.id) { player in
                            Button("#\(player.jerseyNumber) \(player.name)") {
                                event.player1 = player
                            }
                        }
                    } label: {
                        HStack {
                            Text(event.player1?.name ?? "Not Specified")
                            Spacer()
                            Image(systemName: "chevron.down")
                        }
                        .padding()
                        .background(Color(UIColor.tertiarySystemGroupedBackground))
                        .cornerRadius(8)
                    }
                }
            }
        }
    }
}
