// PlayerSelectionView.swift
import SwiftUI
import SwiftData

struct PlayerSelectionView: View {
    @Bindable var event: Event
    let team: Team?
    
    var body: some View {
        if let team = team, !team.players.isEmpty {
            
            ScrollView(.vertical, showsIndicators: true) {
                VStack(spacing: 8) {
                    // "Not Specified" option
                    PlayerSelectButton(
                        isSelected: event.player1 == nil,
                        number: "--",
                        name: "None",
                        action: { event.player1 = nil }
                    )
                    
                    // Player buttons
                    ForEach(team.sortedPlayers, id: \.id) { player in
                        PlayerSelectButton(
                            isSelected: event.player1?.id == player.id,
                            number: "\(player.jerseyNumber)",
                            name: player.name,
                            action: { event.player1 = player }
                        )
                    }
                }
                .padding(.vertical, 6)
            }
            .background(Color(UIColor.tertiarySystemGroupedBackground))
            .cornerRadius(10)
            .frame(maxHeight: .infinity)
            
        }
    }
}

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
