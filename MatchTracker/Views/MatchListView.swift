//
//  MatchListView.swift
//  MatchTracker
//
//  Created by Alan Cullinan on 23/02/2025.
//

import SwiftUI
import SwiftData

struct MatchListView: View {
    @Query(sort: \Match.date, order: .reverse) var matches: [Match]
    @Environment(\.modelContext) var context
    @State private var showingNewMatch = false
    
    var body: some View {
        NavigationView {
            List {
                ForEach(matches, id: \.id) { match in
                    NavigationLink {
                        EditMatchView(match: match)
                    } label: {
                        VStack(alignment: .leading) {
                            Text(match.competition.isEmpty ? "Challenge" : match.competition)
                                .font(.headline)
                            HStack {
                                Text(match.team1.name.isEmpty ? "Team 1" : match.team1.name)
                                Text("vs")
                                    .foregroundColor(.secondary)
                                Text(match.team2.name.isEmpty ? "Team 2" : match.team2.name)
                            }
                            .font(.subheadline)
                            
                            Text(match.date, style: .date)
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        .padding(.vertical, 4)
                    }
                }
                .onDelete(perform: deleteMatches)
            }
            .navigationTitle("Matches")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("New Match") {
                        showingNewMatch = true
                    }
                }
                
                ToolbarItem(placement: .navigationBarLeading) {
                    EditButton()
                }
            }
            .sheet(isPresented: $showingNewMatch) {
                NewMatchView(isPresented: $showingNewMatch)
            }
        }
        .preferredColorScheme(.dark)
    }
    
    private func deleteMatches(at offsets: IndexSet) {
        for index in offsets {
            context.delete(matches[index])
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
        let testTeam1 = Team(name: "Commercials")
        let testTeam2 = Team(name: "Newcastle")
        
        let testMatch = Match()
        testMatch.date = Date()
        testMatch.venue = "Test Venue"
        testMatch.competition = "U16 A Championship"
        testMatch.team1 = testTeam1
        testMatch.team2 = testTeam2
        testMatch.matchType = .football
        
        context.insert(testTeam1)
        context.insert(testTeam2)
        context.insert(testMatch)
        try? context.save()
        
        return MatchListView()
            .modelContainer(container)
    }
}
