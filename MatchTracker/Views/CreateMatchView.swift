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
    @State private var team1Name: String = ""
    @State private var team2Name: String = ""
    @State private var venue: String = ""
    @State private var matchDate: Date = Date()
    @State private var matchType: MatchType = .ladiesFootball
    @State private var halfLength: Int = 30
    
    var body: some View {
        Form {
            Section(header: Text("Match Details")) {
                TextField("Competition", text: $competition)
                TextField("Team 1 Name", text: $team1Name)
                TextField("Team 2 Name", text: $team2Name)
                TextField("Venue", text: $venue)
                DatePicker("Date", selection: $matchDate, displayedComponents: .date)
                Picker("Match Type", selection: $matchType) {
                    ForEach(MatchType.allCases, id: \.self) { type in
                        Text(type.rawValue.capitalized).tag(type)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                Stepper(value: $halfLength, in: 10...45, step: 5) {
                    Text("Match Length: \(halfLength) min")
                }
                Button("Save Changes") {
                    match.competition = competition
                    match.team1.name = team1Name
                    match.team2.name = team2Name
                    match.venue = venue
                    match.date = matchDate
                    match.matchType = matchType
                    match.halfLength = halfLength * 60
                    
                    
                    // Ensure the match is inserted if it is new
                    if !context.hasChanges {
                        context.insert(match)
                    }

                    do {
                        try context.save() // Save changes
                    } catch {
                        print("Error saving match: \(error)")
                    }
                }
            }
            .navigationTitle("Edit Match")
            .onAppear {
                // Load the match data into local variables when the view appears
                competition = match.competition
                team1Name = match.team1.name
                team2Name = match.team2.name
                venue = match.venue
                matchDate = match.date
                matchType = match.matchType
                halfLength = Int(match.halfLength / 60)
            }
        }
    }
}
