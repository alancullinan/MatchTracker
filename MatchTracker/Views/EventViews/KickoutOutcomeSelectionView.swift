//
//  KickoutOutcomeSelectionView.swift
//  MatchTracker
//
//  Created by Alan Cullinan on 23/03/2025.
//
import SwiftUI
import SwiftData

struct KickoutOutcomeSelectionView: View {
    @Bindable var event: Event
    @Binding var wonOwnKickout: Bool
    
    var body: some View {
        VStack(spacing: 8) {
            KickoutOutcomeButton(
                isSelected: wonOwnKickout == true,
                title: "Won Own Kickout",
                icon: "checkmark.circle",
                action: {
                    wonOwnKickout = true
                    event.wonOwnKickout = true
                }
            )
            
            KickoutOutcomeButton(
                isSelected: wonOwnKickout == false,
                title: "Lost Own Kickout",
                icon: "xmark.circle",
                action: {
                    wonOwnKickout = false
                    event.wonOwnKickout = false
                }
            )
        }
        .padding(.vertical, 6)
        .background(Color(UIColor.tertiarySystemGroupedBackground))
        .cornerRadius(10)
        .frame(maxWidth: .infinity)
    }
}

// Helper component for kickout outcome selection buttons
struct KickoutOutcomeButton: View {
    let isSelected: Bool
    let title: String
    let icon: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack {
                Image(systemName: icon)
                    .foregroundColor(isSelected ? .blue : .primary)
                
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
