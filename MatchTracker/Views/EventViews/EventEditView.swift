import SwiftUI
import SwiftData

struct EventEditView: View {
    @Bindable var match: Match
    @Bindable var event: Event
    var onSave: () -> Void
    
    // Note: Removed onCancel parameter
    
    var body: some View {
        ZStack {
            // Background color
            Color(UIColor.systemGroupedBackground)
                .edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 16) {
                // Custom title with icon
                HStack {
                    eventTypeIcon
                        .foregroundColor(iconColor)
                        .font(.title)
                    Text(eventTypeTitle)
                        .font(.title)
                        .fontWeight(.bold)
                }
                .padding(.top, 16)
                
                // Team, time and period info
                VStack(alignment: .leading, spacing: 8) {
                    Text(event.team?.name ?? "Unknown Team")
                        .font(.headline)
                    
                    HStack {
                        Text(formatTime(event.timeElapsed))
                            .font(.subheadline)
                        Text("•")
                            .foregroundColor(.secondary)
                        Text(event.period.rawValue)
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
                .background(Color(UIColor.secondarySystemGroupedBackground))
                .cornerRadius(10)
                .padding(.horizontal)
                
                // Event-specific content
                eventSpecificContent
                    .padding(.horizontal)
                
                // Notes section
                if event.type != .note {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Additional Notes")
                            .font(.headline)
                            .padding(.horizontal)
                        
                        let noteBinding = Binding<String>(
                            get: { self.event.noteText ?? "" },
                            set: { self.event.noteText = $0.isEmpty ? nil : $0 }
                        )
                        
                        TextField("Optional notes", text: noteBinding, axis: .vertical)
                            .lineLimit(3...5)
                            .padding()
                            .background(Color(UIColor.secondarySystemGroupedBackground))
                            .cornerRadius(10)
                            .padding(.horizontal)
                    }
                }
                
                Spacer()
            }
        }
        .navigationBarBackButtonHidden(true)
        .toolbar {
            // Only Done button in the toolbar
            ToolbarItem(placement: .confirmationAction) {
                Button("Done") {
                    onSave()
                }
            }
        }
    }
    
    // Move the computed property to the type level (outside of body)
    private var eventSpecificContent: some View {
        VStack(alignment: .leading, spacing: 12) {
            switch event.type {
            case .shot:
                // Differentiate between goal, point, and missed shots
                if let outcome = event.shotOutcome {
                    switch outcome {
                    case .goal:
                        GoalDetailsContent(match: match, event: event)
                    case .point:
                        PointDetailsContent(match: match, event: event)
                    case .twoPointer:
                        TwoPointerDetailsContent(match: match, event: event)
                    default:
                        // For wide, saved, dropped short, off post - use the original shot view
                        ShotDetailsContent(match: match, event: event)
                    }
                } else {
                    // Fallback if no outcome is set
                    ShotDetailsContent(match: match, event: event)
                }
            case .foulConceded:
                FoulDetailsContent(match: match, event: event)
            case .card:
                CardDetailsContent(match: match, event: event)
            case .kickout:
                KickoutDetailsContent(match: match, event: event)
            case .substitution:
                SubstitutionDetailsContent(match: match, event: event)
            case .note:
                NoteDetailsContent(match: match, event: event)
            default:
                EmptyView()
            }
        }
        .padding()
        .background(Color(UIColor.secondarySystemGroupedBackground))
        .cornerRadius(10)
    }
    
    private var eventTypeTitle: String {
        switch event.type {
        case .shot:
            // For shot events, check the outcome to give a more specific title
            if let outcome = event.shotOutcome {
                switch outcome {
                case .goal:
                    return "Goal"
                case .point:
                    return "Point"
                case .twoPointer:
                    return "2-Point"
                case .wide:
                    return "Wide"
                case .saved:
                    return "Saved"
                case .droppedShort:
                    return "Short"
                case .offPost:
                    return "Off Post"
                }
            }
            return "Shot"
        case .foulConceded:
            return "Foul"
        case .card:
            return "Card"
        case .kickout:
            return "Kickout"
        case .substitution:
            return "Substitution"
        case .note:
            return "Note"
        default:
            return "Event"
        }
    }
    
    private var eventTypeIcon: Image {
        switch event.type {
        case .shot:
            if let outcome = event.shotOutcome {
                switch outcome {
                case .goal:
                    return Image(systemName: "flag.fill") // Green flag for goal
                case .point:
                    return Image(systemName: "flag.fill") // White flag for point
                case .twoPointer:
                    return Image(systemName: "flag.fill") // Orange flag for 2-pointer
                default:
                    return Image(systemName: "x.circle") // Keep x.circle for missed shots
                }
            }
            return Image(systemName: "x.circle")
        case .foulConceded:
            return Image(systemName: "exclamationmark.triangle")
        case .card:
            return Image(systemName: "rectangle.fill")
        case .kickout:
            return Image(systemName: "arrow.up.forward")
        case .substitution:
            return Image(systemName: "arrow.left.arrow.right")
        case .note:
            return Image(systemName: "note.text")
        default:
            return Image(systemName: "circle")
        }
    }

    private var iconColor: Color {
        switch event.type {
        case .shot:
            if let outcome = event.shotOutcome {
                switch outcome {
                case .goal:
                    return .green
                case .point:
                    return .white
                case .twoPointer:
                    return .orange
                default:
                    return .red // For missed shots
                }
            }
            return .red
        case .card:
            return .yellow
        default:
            return .primary
        }
    }
    
    private func formatTime(_ seconds: Int) -> String {
        let minutes = seconds / 60
        let remainingSeconds = seconds % 60
        return String(format: "%02d:%02d", minutes, remainingSeconds)
    }
}
