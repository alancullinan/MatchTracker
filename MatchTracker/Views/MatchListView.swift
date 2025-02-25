//
//  MatchListView.swift
//  MatchTracker
//
//  Created by Alan Cullinan on 23/02/2025.
//

import SwiftUI
import SwiftData

struct MatchListView: View {
    // Use @Query to automatically fetch Match objects from your SwiftData container.
    @Query(sort: \Match.date, order: .reverse) var matches: [Match]
    
    var body: some View {
        NavigationView {
            List(matches) { match in
                VStack(alignment: .leading) {
                    Text(match.venue ?? "")
                        .font(.headline)
                    Text(match.date, style: .date)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
            .navigationTitle("Matches")
            .toolbar {
                // NavigationLink to push the create match view.
                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink("New Match", destination: CreateMatchView())
                }
            }
        }
    }
}


struct MatchListView_Previews: PreviewProvider {
    static var previews: some View {
        // Set up an in-memory container for previews.
        let schema = Schema([Match.self, Team.self, Player.self, Event.self])
        let configuration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: true)
        let container = try! ModelContainer(for: schema, configurations: [configuration])
        
        // Access the container's main context.
        let context = container.mainContext
        
        // Insert some test data.
        let testTeam1 = Team(name: "Test Team A")
        let testTeam2 = Team(name: "Test Team B")
        let testMatch = Match(date: Date(), venue: "Test Venue", competition: "", team1: testTeam1, team2: testTeam2, matchType: .football, halfLength: 1800)
        
        context.insert(testTeam1)
        context.insert(testTeam2)
        context.insert(testMatch)
        try? context.save()
        
        return MatchListView()
            .modelContainer(container)
    }
}
