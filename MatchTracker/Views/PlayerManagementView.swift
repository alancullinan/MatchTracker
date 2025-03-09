import SwiftUI
import SwiftData

struct PlayerManagementView: View {
    @Bindable var team: Team
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            List {
                ForEach(team.players) { player in
                    PlayerRow(player: player)
                }
            }
            .navigationTitle("\(team.name) Players")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
    }
}
