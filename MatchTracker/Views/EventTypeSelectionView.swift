import SwiftUI
import SwiftData

struct EventTypeSelectionView: View {
    @Bindable var match: Match
    let team: Team
    @Binding var isPresented: Bool
    
    // For navigating to the detail view
    @State private var selectedEventType: EventType? = nil
    @State private var navigationPath = NavigationPath()
    
    var body: some View {
        NavigationStack(path: $navigationPath) {
            List {
                Section(header: Text("Select Event Type")) {
                    // Score events already have dedicated buttons, so exclude them
                    Button(action: {
                        navigationPath.append(EventType.foulConceded)
                    }) {
                        HStack {
                            Image(systemName: "exclamationmark.triangle")
                            Text("Foul")
                        }
                    }
                    
                    Button(action: {
                        navigationPath.append(EventType.card)
                    }) {
                        HStack {
                            Image(systemName: "rectangle.fill")
                                .foregroundColor(.yellow)
                            Text("Card")
                        }
                    }
                    
                    Button(action: {
                        navigationPath.append(EventType.kickout)
                    }) {
                        HStack {
                            Image(systemName: "arrow.up.forward")
                            Text("Kickout")
                        }
                    }
                    
                    Button(action: {
                        navigationPath.append(EventType.substitution)
                    }) {
                        HStack {
                            Image(systemName: "arrow.left.arrow.right")
                            Text("Substitution")
                        }
                    }
                    
                    Button(action: {
                        navigationPath.append(EventType.note)
                    }) {
                        HStack {
                            Image(systemName: "note.text")
                            Text("General Note")
                        }
                    }
                }
            }
            .navigationTitle("Record Event")
            .navigationDestination(for: EventType.self) { eventType in
                EventDetailView(
                    match: match,
                    team: team,
                    eventType: eventType,
                    onSave: {
                        isPresented = false
                    },
                    onCancel: {
                        navigationPath.removeLast()
                    }
                )
            }
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        isPresented = false
                    }
                }
            }
        }
    }
}
