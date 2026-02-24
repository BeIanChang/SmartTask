import SwiftUI

struct TimeEntryEditorView: View {
    @Environment(\.dismiss) private var dismiss
    let tasks: [TaskModel]
    let onSave: (TaskModel, Date, Date, String) -> Void

    @State private var selectedTaskIndex = 0
    @State private var startAt = Date()
    @State private var endAt = Calendar.current.date(byAdding: .hour, value: 1, to: Date()) ?? Date()
    @State private var note = ""

    var body: some View {
        NavigationStack {
            Form {
                Section("Task") {
                    Picker("Task", selection: $selectedTaskIndex) {
                        ForEach(tasks.indices, id: \.self) { (index: Int) in
                            Text(tasks[index].title).tag(index)
                        }
                    }
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
            .navigationTitle("New Time Block")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Add") {
                        guard !tasks.isEmpty else { return }
                        let task = tasks[selectedTaskIndex]
                        let start = startAt
                        let end = max(endAt, startAt)
                        onSave(task, start, end, note)
                        dismiss()
                    }
                    .disabled(tasks.isEmpty)
                }
            }
        }
    }
}
