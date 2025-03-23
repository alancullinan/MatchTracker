//
//  FoulOutcomeSelectionView.swift
//  MatchTracker
//
//  Created by Alan Cullinan on 23/03/2025.
//

import SwiftUI
import SwiftData

struct FoulOutcomeSelectionView: View {
    @Bindable var event: Event
    @Binding var foulOutcome: FoulOutcome
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: true) {
            VStack(spacing: 8) {
                FoulOutcomeButton(
                    isSelected: foulOutcome == .free,
                    title: "Free",
                    icon: "target",
                    action: {
                        foulOutcome = .free
                        event.foulOutcome = .free
                    }
                )
                
                FoulOutcomeButton(
                    isSelected: foulOutcome == .penalty,
                    title: "Penalty",
                    icon: "exclamationmark.triangle",
                    action: {
                        foulOutcome = .penalty
                        event.foulOutcome = .penalty
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

// Helper component for foul outcome selection buttons
struct FoulOutcomeButton: View {
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
                
                if isSelected {
                }
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
