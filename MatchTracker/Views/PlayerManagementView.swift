import SwiftUI
import SwiftData

struct PlayerManagementView: View {
    @Bindable var team: Team
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            List {
                // Use a sorted array of players instead of direct access
                ForEach(sortedPlayers) { player in
                    PlayerRow(player: player)
                }
            }
            .navigationTitle("\(team.name) Players")
        }
    }
    
    // Computed property to sort players by jersey number
    private var sortedPlayers: [Player] {
        team.players.sorted { $0.jerseyNumber < $1.jerseyNumber }
    }
}
