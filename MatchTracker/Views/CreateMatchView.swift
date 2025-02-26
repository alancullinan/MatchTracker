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
    @Environment(\.dismiss) var dismiss
    @Bindable var match: Match
    @State private var isNewMatch: Bool = false
    
    var body: some View {
        Form {
            Section(header: Text("Match Details")) {
                TextField("Competition", text: $match.competition)
                TextField("Team 1 Name", text: $match.team1.name)
                TextField("Team 2 Name", text: $match.team2.name)
                TextField("Venue", text: $match.venue)
                DatePicker("Date", selection: $match.date, displayedComponents: .date)
                Picker("Match Type", selection: $match.matchType) {
                    ForEach(MatchType.allCases, id: \.self) { type in
                        Text(type.rawValue.capitalized).tag(type)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                
                let halfLengthInMinutes = Binding<Int>(
                    get: { Int(match.halfLength / 60) },
                    set: { match.halfLength = $0 * 60 }
                )
                
                Stepper(value: halfLengthInMinutes, in: 10...45, step: 5) {
                    Text("Match Length: \(halfLengthInMinutes.wrappedValue) min")
                }
               
            }
            .navigationTitle(isNewMatch ? "New Match" : "Edit Match")
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") {
                        // Only insert if this is a new match
                        if isNewMatch {
                            context.insert(match)
                        }
                        // Changes are already tracked by SwiftData
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
        }
        .onAppear {
            // Check if this is a new match that hasn't been inserted yet
            isNewMatch = context.model(for: match) == nil
        }
    }
}
