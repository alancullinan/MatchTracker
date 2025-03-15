//
//  SettingsTabView.swift
//  MatchTracker
//
//  Created by Alan Cullinan on 11/03/2025.
//

import SwiftUI
import SwiftData

struct MatchSettingsView: View {
    @Bindable var match: Match
    
    var body: some View {
        MatchFormView(match: match)
    }
}
