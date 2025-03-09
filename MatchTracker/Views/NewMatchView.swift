//
//  NewMatchView.swift
//  MatchTracker
//
//  Created by Alan Cullinan on 26/02/2025.
//

import SwiftUI
import SwiftData

struct NewMatchView: View {
    @Environment(\.modelContext) var context
    @Binding var isPresented: Bool
    @State private var match = Match()
    
    // Computed property to check if form is valid
    private var isFormValid: Bool {
        !match.competition.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
        !match.team1.name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
        !match.team2.name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
    var body: some View {
        NavigationView {
            MatchFormView(match: match)
                .navigationTitle("New Match")
                .toolbar {
                    ToolbarItem(placement: .cancellationAction) {
                        Button("Cancel") {
                            isPresented = false
                        }
                    }
                    
                    ToolbarItem(placement: .confirmationAction) {
                        Button("Add") {
                            // Initialize numbered players for both teams
                            match.team1.initializeWithNumberedPlayers()
                            match.team2.initializeWithNumberedPlayers()
                            
                            // Insert the match
                            context.insert(match)
                            isPresented = false
                        }
                        .disabled(!isFormValid)
                    }
                }
        }
    }
}
