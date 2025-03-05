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
    
    // State to control navigation to edit view and event list
    @State private var showingEventList = false
    
    // Used to navigate back programmatically if needed
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        VStack {
            // Timer view
            MatchTimerView(match: match)
            
            Spacer()
            
            // Event List Button
            Button(action: {
                showingEventList = true
            }) {
                HStack {
                    Image(systemName: "list.bullet")
                    Text("View Events")
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(10)
                .padding(.horizontal)
            }
            .padding(.bottom)
        }
        //.navigationTitle(match.competition.isEmpty ? "Match" : match.competition)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                NavigationLink(destination: EditMatchView(match: match)) {
                    Text("Edit")
                }
            }
        }
        .sheet(isPresented: $showingEventList) {
            EventListView(match: match)
        }
    }
}
