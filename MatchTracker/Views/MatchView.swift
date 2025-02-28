//
//  MatchView.swift
//  MatchTracker
//
//  Created on 28/02/2025.
//

import SwiftUI
import SwiftData

struct MatchView: View {
    // The match to display
    @Bindable var match: Match
    
    // State to control navigation to edit view
    @State private var navigateToEdit = false
    
    // Used to navigate back programmatically if needed
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        // Simple empty view with navigation title
        VStack {
            Text("Match View")
                .font(.title)
                .padding()
            
            Spacer()
        }
        .navigationTitle("Match")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                NavigationLink(destination: EditMatchView(match: match)) {
                    Text("Edit")
                }
            }
        }
    }
}
