// NoteDetailsContent.swift
import SwiftUI
import SwiftData

struct NoteDetailsContent: View {
    @Bindable var match: Match
    @Bindable var event: Event
    
    init(match: Match, event: Event) {
        self.match = match
        self.event = event
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
//            Text("Note")
//                .font(.headline)
            
            // We can use a direct binding on the noteText property
            // with a default value for when it's nil
            TextField("Enter note details", text: Binding(
                get: { event.noteText ?? "" },
                set: { event.noteText = $0.isEmpty ? nil : $0 }
            ), axis: .vertical)
                .lineLimit(5...10)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(10)
                .background(Color(UIColor.tertiarySystemGroupedBackground))
                .cornerRadius(10)
        }
    }
}
