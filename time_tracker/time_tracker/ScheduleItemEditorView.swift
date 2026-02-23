import SwiftUI

struct ScheduleItemEditorView: View {
    @Environment(\.dismiss) private var dismiss
    let onSave: (String, Date, Date, String) -> Void

    @State private var title = ""
    @State private var startAt = Date()
    @State private var endAt = Calendar.current.date(byAdding: .hour, value: 1, to: Date()) ?? Date()
    @State private var note = ""

    var body: some View {
        NavigationStack {
            Form {
                Section("Schedule") {
                    TextField("Title", text: $title)
                }

                Section("Time") {
                    DatePicker("Start", selection: $startAt, displayedComponents: [.date, .hourAndMinute])
                    DatePicker("End", selection: $endAt, displayedComponents: [.date, .hourAndMinute])
                }

                Section("Notes") {
                    TextField("Notes", text: $note, axis: .vertical)
                        .lineLimit(3...6)
                }
            }
            .navigationTitle("New Schedule")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Add") {
                        let trimmed = title.trimmingCharacters(in: .whitespacesAndNewlines)
                        guard !trimmed.isEmpty else { return }
                        let start = startAt
                        let end = max(endAt, startAt)
                        onSave(trimmed, start, end, note)
                        dismiss()
                    }
                    .disabled(title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                }
            }
        }
    }
}
