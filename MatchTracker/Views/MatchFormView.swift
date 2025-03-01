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
            Section(header: Text("Competition")) {
                HStack {
                    TextField("Competition", text: $match.competition, axis: .vertical)
                        .frame(minWidth: 200, maxWidth: .infinity, minHeight: 40) // Ensures enough space
                        .background(Color(UIColor.secondarySystemBackground))
                    
                    Picker("", selection: $match.matchType) {
                        ForEach(MatchType.allCases, id: \.self) { type in
                            Text(type.rawValue).tag(type)
                        }
                    }
                    .pickerStyle(.menu)
                    .fixedSize(horizontal: false, vertical: false) // Makes Picker fit its content
                }
            }
            Section(header: Text("Teams")) {
                TextField("Team 1 Name", text: $match.team1.name)
                    .autocorrectionDisabled()
                TextField("Team 2 Name", text: $match.team2.name)
                    .autocorrectionDisabled()
            }
            Section(header: Text("Date")) {
                DatePicker("Date", selection: $match.date, displayedComponents: .date)
            }
            Section(header: Text("Venue")) {
                TextField("Venue", text: $match.venue)
                    .autocorrectionDisabled()
            }
//            Section(header: Text("Details")) {
//               
//                let halfLengthInMinutes = Binding<Int>(
//                    get: { Int(match.halfLength / 60) },
//                    set: { match.halfLength = $0 * 60 }
//                )
//                
//                Stepper(value: halfLengthInMinutes, in: 10...45, step: 5) {
//                    Text("Half Length: \(halfLengthInMinutes.wrappedValue) min")
//                }
//            }
        }
        .listSectionSpacing(0)
    }
}
