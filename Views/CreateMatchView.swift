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
//            Button("Create Match") {
//                // For simplicity, we create two dummy teams.
//                let team1 = Team(name: "Team A")
//                let team2 = Team(name: "Team B")
//                // Create a new match using your model initializer.
//                let newMatch = Match(date: matchDate,
//                                     venue: venue,
//                                     competition: "",
//                                     team1: team1,
//                                     team2: team2,
//                                     matchType: .football,
//                                     halfLength: 1800)
//                // Insert the new objects into the SwiftData context.
//                context.insert(team1)
//                context.insert(team2)
//                context.insert(newMatch)
//                
//                do {
//                    try context.save()
//                } catch {
//                    print("Error saving match: \(error)")
//                }
            }
        }
        .navigationTitle("New Match")
    }
}
