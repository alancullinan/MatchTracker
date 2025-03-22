// ShotTypeSelectionView.swift
import SwiftUI
import SwiftData

struct ShotTypeSelectionView: View {
    @Bindable var match: Match
    @Bindable var event: Event
    @Binding var shotType: ShotType
    
    var body: some View {
        
        
        ScrollView(.vertical, showsIndicators: true) {
            VStack(spacing: 8) {
                ShotTypeButton(
                    isSelected: shotType == .fromPlay,
                    title: "From Play",
                    action: {
                        shotType = .fromPlay
                        event.shotType = .fromPlay
                    }
                )
                
                ShotTypeButton(
                    isSelected: shotType == .free,
                    title: "Free",
                    action: {
                        shotType = .free
                        event.shotType = .free
                    }
                )
                
                ShotTypeButton(
                    isSelected: shotType == .penalty,
                    title: "Penalty",
                    action: {
                        shotType = .penalty
                        event.shotType = .penalty
                    }
                )
                
                ShotTypeButton(
                    isSelected: shotType == .fortyFive,
                    title: "45m/65m",
                    action: {
                        shotType = .fortyFive
                        event.shotType = .fortyFive
                    }
                )
                
                ShotTypeButton(
                    isSelected: shotType == .sideline,
                    title: "Sideline",
                    action: {
                        shotType = .sideline
                        event.shotType = .sideline
                    }
                )
                
                if match.matchType == .football || match.matchType == .ladiesFootball {
                    ShotTypeButton(
                        isSelected: shotType == .mark,
                        title: "Mark",
                        action: {
                            shotType = .mark
                            event.shotType = .mark
                        }
                    )
                }
            }
            .padding(.vertical, 6)
        }
        .background(Color(UIColor.tertiarySystemGroupedBackground))
        .cornerRadius(10)
        .frame(maxHeight: .infinity)
        .frame(maxWidth: .infinity)
    }
}

// Helper component for shot type selection buttons
struct ShotTypeButton: View {
    let isSelected: Bool
    let title: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack {
                Text(title)
                    .font(.subheadline)
                    .foregroundColor(isSelected ? .blue : .primary)
                
                Spacer()
            }
            .padding(.vertical, 8)
            .padding(.horizontal, 12)
            .background(isSelected ? Color.blue.opacity(0.1) : Color.clear)
            .cornerRadius(8)
            .contentShape(Rectangle())
        }
        .buttonStyle(PlainButtonStyle())
    }
}
