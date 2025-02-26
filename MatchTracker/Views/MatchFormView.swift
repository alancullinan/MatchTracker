//
//  MatchFormView.swift
//  MatchTracker
//
//  Created by Alan Cullinan on 26/02/2025.
//

import SwiftUI
import SwiftData

struct MatchFormView: View {
    @Bindable var match: Match
    
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
        }
    }
}
