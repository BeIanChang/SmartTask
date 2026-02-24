import SwiftUI

struct TimeEntryEditView: View {
    @Environment(\.dismiss) private var dismiss
    @Bindable var entry: TimeEntry
    let onDelete: () -> Void

    @State private var startAt: Date
    @State private var endAt: Date

    init(entry: TimeEntry, onDelete: @escaping () -> Void) {
        self.entry = entry
        self.onDelete = onDelete
        _startAt = State(initialValue: entry.startedAt)
        _endAt = State(initialValue: entry.endedAt ?? entry.startedAt)
    }

    var body: some View {
        NavigationStack {
            Form {
                Section("Time") {
                    DatePicker("Start", selection: $startAt, displayedComponents: [.date, .hourAndMinute])
                    DatePicker("End", selection: $endAt, displayedComponents: [.date, .hourAndMinute])
                }

                Section("Notes") {
                    TextField("Notes", text: $entry.note, axis: .vertical)
                        .lineLimit(3...6)
                }
            }
            .navigationTitle(entry.task.title)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        entry.startedAt = startAt
                        entry.endedAt = endAt
                        entry.minutes = max(1, Int(endAt.timeIntervalSince(startAt) / 60))
                        dismiss()
                    }
                }
                ToolbarItem(placement: .destructiveAction) {
                    Button("Delete", role: .destructive) {
                        onDelete()
                        dismiss()
                    }
                }
            }
        }
    }
}
