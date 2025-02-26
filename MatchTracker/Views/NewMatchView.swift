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
                            context.insert(match)
                            isPresented = false
                        }
                    }
                }
        }
    }
}
