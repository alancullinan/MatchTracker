//
//  EventTypeSelectionView.swift
//  MatchTracker
//
//  Created by Alan Cullinan on 08/03/2025.
//

import SwiftUI
import SwiftData

struct EventTypeSelectionView: View {
    @Bindable var match: Match
    let team: Team
    @Binding var isPresented: Bool
    
    // For navigating to the detail view
    @State private var selectedEventType: EventType? = nil
    @State private var showEventDetail = false
    
    var body: some View {
        NavigationView {
            List {
                Section(header: Text("Select Event Type")) {
                    // Score events already have dedicated buttons, so exclude them
                    Button(action: { selectEventType(.foulConceded) }) {
                        HStack {
                            Image(systemName: "exclamationmark.triangle")
                            Text("Foul")
                        }
                    }
                    
                    Button(action: { selectEventType(.card) }) {
                        HStack {
                            Image(systemName: "rectangle.fill")
                                .foregroundColor(.yellow)
                            Text("Card")
                        }
                    }
                    
                    Button(action: { selectEventType(.kickout) }) {
                        HStack {
                            Image(systemName: "arrow.up.forward")
                            Text("Kickout")
                        }
                    }
                    
                    Button(action: { selectEventType(.substitution) }) {
                        HStack {
                            Image(systemName: "arrow.left.arrow.right")
                            Text("Substitution")
                        }
                    }
                    
                    Button(action: { selectEventType(.note) }) {
                        HStack {
                            Image(systemName: "note.text")
                            Text("General Note")
                        }
                    }
                }
            }
            .navigationTitle("Record Event")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        isPresented = false
                    }
                }
            }
        }
        .sheet(isPresented: $showEventDetail) {
            if let type = selectedEventType {
                EventDetailView(
                    match: match,
                    team: team,
                    eventType: type,
                    isPresented: $showEventDetail,
                    onDismiss: { isPresented = false }
                )
            }
        }
    }
    
    private func selectEventType(_ type: EventType) {
        selectedEventType = type
        showEventDetail = true
    }
}
