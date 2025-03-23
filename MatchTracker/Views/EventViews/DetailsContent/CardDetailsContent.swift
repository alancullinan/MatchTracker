// CardDetailsContent.swift
import SwiftUI
import SwiftData

struct CardDetailsContent: View {
    @Bindable var match: Match
    @Bindable var event: Event
    @State private var cardType: CardType
    
    init(match: Match, event: Event) {
        self.match = match
        self.event = event
        _cardType = State(initialValue: event.cardType ?? .yellow)
    }
    
    var body: some View {
        // Side-by-side layout for card type and player selection
        HStack(alignment: .top, spacing: 16) {
            // Left side: Card Type
            VStack(alignment: .leading) {
//                Text("Card Type")
//                    .font(.subheadline)
//                    .foregroundColor(.secondary)
                
                CardTypeSelectionView(event: event, cardType: $cardType)
                    .frame(maxWidth: .infinity)
            }
            
            // Right side: Player Selection
            if let team = event.team, !team.players.isEmpty {
                VStack(alignment: .leading) {
//                    Text("Player")
//                        .font(.subheadline)
//                        .foregroundColor(.secondary)
                    
                    PlayerSelectionView(event: event, team: team)
                        .frame(maxWidth: .infinity)
                }
            }
        }
    }
}
