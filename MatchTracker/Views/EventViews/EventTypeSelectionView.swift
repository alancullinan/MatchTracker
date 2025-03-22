import SwiftUI
import SwiftData

struct EventTypeSelectionView: View {
    @Bindable var match: Match
    let team: Team
    @Binding var isPresented: Bool
    
    // For navigating to the detail view
    @State private var selectedEvent: Event?
    
    var body: some View {
        List {
            Section(header: Text("Select Event Type")) {
                // Shot event button
                Button {
                    let newEvent = Event(
                        type: .shot,
                        period: match.matchPeriod,
                        timeElapsed: match.elapsedTime,
                        team: team,
                        shotOutcome: .wide,
                        shotType: .fromPlay
                    )
                    match.events.append(newEvent)
                    selectedEvent = newEvent
                } label: {
                    HStack {
                        Image(systemName: "x.circle")
                            .foregroundColor(.red)
                        Text("Missed Shot")
                    }
                }
                
                // Foul button
                Button {
                    let newEvent = Event(
                        type: .foulConceded,
                        period: match.matchPeriod,
                        timeElapsed: match.elapsedTime,
                        team: team,
                        foulOutcome: .free
                    )
                    match.events.append(newEvent)
                    selectedEvent = newEvent
                } label: {
                    HStack {
                        Image(systemName: "exclamationmark.triangle")
                        Text("Foul")
                    }
                }
                
                // Card button
                Button {
                    let newEvent = Event(
                        type: .card,
                        period: match.matchPeriod,
                        timeElapsed: match.elapsedTime,
                        team: team,
                        cardType: .yellow
                    )
                    match.events.append(newEvent)
                    selectedEvent = newEvent
                } label: {
                    HStack {
                        Image(systemName: "rectangle.fill")
                            .foregroundColor(.yellow)
                        Text("Card")
                    }
                }
                
                // Kickout button
                Button {
                    let newEvent = Event(
                        type: .kickout,
                        period: match.matchPeriod,
                        timeElapsed: match.elapsedTime,
                        team: team,
                        wonOwnKickout: true
                    )
                    match.events.append(newEvent)
                    selectedEvent = newEvent
                } label: {
                    HStack {
                        Image(systemName: "arrow.up.forward")
                        Text("Kickout")
                    }
                }
                
                // Substitution button
                Button {
                    let newEvent = Event(
                        type: .substitution,
                        period: match.matchPeriod,
                        timeElapsed: match.elapsedTime,
                        team: team
                    )
                    match.events.append(newEvent)
                    selectedEvent = newEvent
                } label: {
                    HStack {
                        Image(systemName: "arrow.left.arrow.right")
                        Text("Substitution")
                    }
                }
                
                // Note button
                Button {
                    let newEvent = Event(
                        type: .note,
                        period: match.matchPeriod,
                        timeElapsed: match.elapsedTime,
                        team: team
                    )
                    match.events.append(newEvent)
                    selectedEvent = newEvent
                } label: {
                    HStack {
                        Image(systemName: "note.text")
                        Text("General Note")
                    }
                }
            }
        }
        .navigationTitle("Record Event")
        .toolbar {
            ToolbarItem(placement: .cancellationAction) {
                Button("Cancel") {
                    isPresented = false
                }
            }
        }
        .sheet(item: $selectedEvent) { event in
            NavigationView {
                EventEditView(
                    match: match,
                    event: event,
                    onSave: {
                        selectedEvent = nil
                        isPresented = false
                    }
                    // Remove the onCancel parameter and its closure
                )
            }
        }
    }
}
