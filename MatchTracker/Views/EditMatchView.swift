//
//  EditMatchView.swift
//  MatchTracker
//
//  Created by Alan Cullinan on 26/02/2025.
//

import SwiftUI
import SwiftData

struct EditMatchView: View {
    @Bindable var match: Match
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        MatchFormView(match: match)
            .navigationTitle("Edit Match")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
    }
}
