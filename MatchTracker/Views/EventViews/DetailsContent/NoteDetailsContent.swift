//
//  NoteDetailsContent.swift
//  MatchTracker
//
//  Created by Alan Cullinan on 22/03/2025.
//

import SwiftUI
import SwiftData

struct NoteDetailsContent: View {
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
            Text("Note Details")
                .font(.headline)
            
        }
    }
}
