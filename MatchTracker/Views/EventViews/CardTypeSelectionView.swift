//
//  CardTypeSelectionView.swift
//  MatchTracker
//
//  Created by Alan Cullinan on 23/03/2025.
//

import SwiftUI
import SwiftData

struct CardTypeSelectionView: View {
    @Bindable var event: Event
    @Binding var cardType: CardType
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: true) {
            VStack(spacing: 8) {
                CardTypeButton(
                    isSelected: cardType == .yellow,
                    title: "Yellow Card",
                    color: .yellow,
                    action: {
                        cardType = .yellow
                        event.cardType = .yellow
                    }
                )
                
                CardTypeButton(
                    isSelected: cardType == .red,
                    title: "Red Card",
                    color: .red,
                    action: {
                        cardType = .red
                        event.cardType = .red
                    }
                )
                
                CardTypeButton(
                    isSelected: cardType == .black,
                    title: "Black Card",
                    color: .black,
                    action: {
                        cardType = .black
                        event.cardType = .black
                    }
                )
            }
            .padding(.vertical, 6)
        }
        .background(Color(UIColor.tertiarySystemGroupedBackground))
        .cornerRadius(10)
        .frame(maxHeight: .infinity)
    }
}

// Helper component for card type selection buttons
struct CardTypeButton: View {
    let isSelected: Bool
    let title: String
    let color: Color
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack {
                Rectangle()
                    .fill(color)
                    .frame(width: 18, height: 20)
                    .cornerRadius(2)
                
                Text(title)
                    .font(.subheadline)
                    .foregroundColor(isSelected ? .blue : .primary)
                
                Spacer()
                
            }
            .padding(.vertical, 8)
            .padding(.horizontal, 10)
            .background(isSelected ? Color.blue.opacity(0.1) : Color.clear)
            .cornerRadius(8)
            .contentShape(Rectangle())
        }
        .buttonStyle(PlainButtonStyle())
    }
}
