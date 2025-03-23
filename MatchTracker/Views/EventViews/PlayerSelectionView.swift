// PlayerSelectionView.swift
import SwiftUI
import SwiftData

struct PlayerSelectionView: View {
    @Bindable var event: Event
    let team: Team  // This is already non-optional
    var isPlayer2: Bool = false  // Parameter to switch between player1 and player2
    
    var body: some View {
        // No need for if let since team is already non-optional
        // Just check if the players array is not empty
        if !team.players.isEmpty {
            ScrollView(.vertical, showsIndicators: true) {
                VStack(spacing: 8) {
                    // "Not Specified" option
                    PlayerSelectButton(
                        isSelected: isPlayer2 ? event.player2 == nil : event.player1 == nil,
                        number: "--",
                        name: "None",
                        action: {
                            if isPlayer2 {
                                event.player2 = nil
                            } else {
                                event.player1 = nil
                            }
                        }
                    )
                    
                    // Player buttons
                    ForEach(team.sortedPlayers, id: \.id) { player in
                        PlayerSelectButton(
                            isSelected: isPlayer2 ? event.player2?.id == player.id : event.player1?.id == player.id,
                            number: "\(player.jerseyNumber)",
                            name: player.name,
                            action: {
                                if isPlayer2 {
                                    event.player2 = player
                                } else {
                                    event.player1 = player
                                }
                            }
                        )
                    }
                }
                .padding(.vertical, 6)
            }
            .background(Color(UIColor.tertiarySystemGroupedBackground))
            .cornerRadius(10)
            .frame(maxHeight: .infinity)
        } else {
            Text("No players available")
                .foregroundColor(.secondary)
                .padding()
        }
    }
}

// Keep the existing PlayerSelectButton as is - no changes needed

// Horizontal player button for vertical scrolling
struct PlayerSelectButton: View {
    let isSelected: Bool
    let number: String
    let name: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 10) {
                Text(number)
                    .font(.subheadline)
                    .fontWeight(.bold)
                    .frame(width: 30, height: 30)
                    .background(isSelected ? Color.blue : Color.gray.opacity(0.2))
                    .foregroundColor(isSelected ? .white : .primary)
                    .clipShape(Circle())
                
                Text(name)
                    .font(.subheadline)
                    .foregroundColor(isSelected ? .blue : .primary)
                
                Spacer()

            }
            .padding(.vertical, 6)
            .padding(.horizontal, 10)
            .background(isSelected ? Color.blue.opacity(0.1) : Color.clear)
            .cornerRadius(8)
            .contentShape(Rectangle())
        }
        .buttonStyle(PlainButtonStyle())
    }
}
