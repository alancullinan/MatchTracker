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
    
    // Custom description function for match types
        private func descriptionFor(_ type: MatchType) -> String {
            switch type {
            case .football:
                return "Football"
            case .hurling:
                return "Hurling"
            case .ladiesFootball:
                return "Ladies Football"
            case .camogie:
                return "Camogie"
            }
        }
    
    var body: some View {
        Form {
            Section(header: Text("Competition")) {
                TextField("Competition", text: $match.competition)
                    .autocorrectionDisabled()
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
            Section(header: Text("Referee")) {
                TextField("Referee", text: $match.referee)
                    .autocorrectionDisabled()
            }
            Section(header: Text("Details")) {
                
                Menu {
                    ForEach(MatchType.allCases, id: \.self) { type in
                    Button(descriptionFor(type)) {
                    match.matchType = type
                    }
                }
                } label: {
                    HStack {
                        Text("Match Type")
                            .foregroundColor(.primary)
                        Spacer()
                        Text(descriptionFor(match.matchType))
                            .foregroundColor(.secondary)
                        Image(systemName: "chevron.down")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    .foregroundStyle(.primary)
                }
                .menuStyle(BorderlessButtonMenuStyle())
                .buttonStyle(PlainButtonStyle())
                .tint(.primary)
                
                let halfLengthInMinutes = Binding<Int>(
                    get: { Int(match.halfLength / 60) },
                    set: { match.halfLength = $0 * 60 }
                )
                
                Stepper(value: halfLengthInMinutes, in: 10...45, step: 5) {
                    Text("Half Length: \(halfLengthInMinutes.wrappedValue) min")
                }
            }
        }
        .listSectionSpacing(0)
    }
}
