import SwiftUI

struct TimeEntryNoteView: View {
    @Bindable var entry: TimeEntry
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            Form {
                Section("Notes") {
                    TextField("Add a note", text: $entry.note, axis: .vertical)
                        .lineLimit(3...6)
                }
            }
            .navigationTitle("Time Entry")
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") { dismiss() }
                }
            }
        }
    }
}
