import SwiftUI

struct MilestoneEditorView: View {
    @Environment(\.dismiss) private var dismiss
    let onSave: (String, Date?) -> Void

    @State private var title = ""
    @State private var hasDeadline = false
    @State private var deadline = Date()

    var body: some View {
        NavigationStack {
            Form {
                Section("Milestone") {
                    TextField("Title", text: $title)
                }

                Section("Deadline") {
                    Toggle("Set deadline", isOn: $hasDeadline)

                    if hasDeadline {
                        DatePicker("Date", selection: $deadline, displayedComponents: [.date, .hourAndMinute])
                    }
                }
            }
            .navigationTitle("New Milestone")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Add") {
                        let trimmed = title.trimmingCharacters(in: .whitespacesAndNewlines)
                        guard !trimmed.isEmpty else { return }
                        onSave(trimmed, hasDeadline ? Calendar.current.startOfDay(for: deadline) : nil)
                        dismiss()
                    }
                    .disabled(title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                }
            }
        }
    }
}
