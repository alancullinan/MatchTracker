import SwiftUI
import SwiftData

struct PlayerRow: View {
    @Bindable var player: Player
    
    var body: some View {
        HStack {
            Text("\(player.jerseyNumber)")
                .font(.headline)
                .frame(width: 32, height: 32)
                .background(Color.blue.opacity(0.8))
                .foregroundColor(.white)
                .cornerRadius(16)
                
            TextField("Player Name", text: $player.name)
                .textFieldStyle(RoundedBorderTextFieldStyle())
            
            Spacer()
        }
        .padding(.vertical, 4)
    }
}
