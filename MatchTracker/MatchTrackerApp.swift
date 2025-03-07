//
//  MatchTrackerApp.swift
//  MatchTracker
//
//  Created by Alan Cullinan on 23/02/2025.
//

import SwiftUI
import SwiftData

@main
struct MatchTrackerApp: App {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Match.self,
            Team.self,
            Player.self,
            Event.self
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)
        
        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()
    
    var body: some Scene {
        WindowGroup {
            MatchListView()
        }
        .modelContainer(sharedModelContainer)
    }
}
