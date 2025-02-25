//
//  CreateMatchView.swift
//  MatchTracker
//
//  Created by Alan Cullinan on 23/02/2025.
//

import SwiftUI
import SwiftData

struct CreateMatchView: View {
    @Environment(\.modelContext) var context
    @Bindable var match: Match
    
    // Local state variables for editing
    @State private var competition: String = ""
    @State private var team1: Team = ""
    @State private var team2: Team = ""
    @State private var venue: String = ""
    @State private var matchDate: Date = Date()
    
    var body: some View {
        Form {
            Section(header: Text("Match Details")) {
                TextField("Competition", text: $competition)
                // Team1
                // Team2
                TextField("Venue", text: $venue)
                DatePicker("Date", selection: $matchDate, displayedComponents: .date)
            }
            Button("Save Changes") {
                match.venue = venue
                match.date = matchDate
                match.competition = competition
                
                do {
                    try context.save()
                } catch {
                    print("Error saving match: \(error)")
                }
            }
        }
        .navigationTitle("Edit Match")
        .onAppear {
            // Load the match data into local variables when the view appears
            venue = match.venue
            matchDate = match.date
            competition = match.competition
        }
    }
}


