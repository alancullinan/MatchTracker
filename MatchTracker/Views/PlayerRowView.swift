import SwiftUI
import SwiftData

struct PlayerRow: View {
    @Bindable var player: Player
    
    var body: some View {
        HStack {
            Text("#\(player.jerseyNumber)")
                .font(.headline)
                .frame(width: 40)
            
            TextField("Player Name", text: $player.name)
                .textFieldStyle(RoundedBorderTextFieldStyle())
            
            Spacer()
        }
        .padding(.vertical, 4)
    }
}
