//
//  ShotOutcomeSelectionView.swift
//  MatchTracker
//
//  Created by Alan Cullinan on 23/03/2025.
//
import SwiftUI
import SwiftData

struct ShotOutcomeSelectionView: View {
    @Bindable var match: Match
    @Bindable var event: Event
    @Binding var shotOutcome: ShotOutcome
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: true) {
            VStack(spacing: 8) {
                // Only include missed shot outcomes
                ShotOutcomeButton(
                    isSelected: shotOutcome == .wide,
                    title: "Wide",
                    icon: "xmark",
                    action: {
                        shotOutcome = .wide
                        event.shotOutcome = .wide
                    }
                )
                
                ShotOutcomeButton(
                    isSelected: shotOutcome == .saved,
                    title: "Saved",
                    icon: "hand.raised",
                    action: {
                        shotOutcome = .saved
                        event.shotOutcome = .saved
                    }
                )
                
                ShotOutcomeButton(
                    isSelected: shotOutcome == .droppedShort,
                    title: "Dropped Short",
                    icon: "arrow.down",
                    action: {
                        shotOutcome = .droppedShort
                        event.shotOutcome = .droppedShort
                    }
                )
                
                ShotOutcomeButton(
                    isSelected: shotOutcome == .offPost,
                    title: "Hit Post",
                    icon: "squareshape",
                    action: {
                        shotOutcome = .offPost
                        event.shotOutcome = .offPost
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

// Helper component for shot outcome selection buttons
struct ShotOutcomeButton: View {
    let isSelected: Bool
    let title: String
    let icon: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack {
//                Image(systemName: icon)
//                    .foregroundColor(isSelected ? .blue : .primary)
                
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
