import SwiftUI

struct ScheduleItemEditView: View {
    @Environment(\.dismiss) private var dismiss
    @Bindable var item: ScheduleItem
    let onDelete: () -> Void

    @State private var startAt: Date
    @State private var endAt: Date

    init(item: ScheduleItem, onDelete: @escaping () -> Void) {
        self.item = item
        self.onDelete = onDelete
        _startAt = State(initialValue: item.startAt)
        _endAt = State(initialValue: item.endAt)
    }

    var body: some View {
        NavigationStack {
            Form {
                Section("Schedule") {
                    TextField("Title", text: $item.title)
                }

                Section("Time") {
                    DatePicker("Start", selection: $startAt, displayedComponents: [.date, .hourAndMinute])
                    DatePicker("End", selection: $endAt, displayedComponents: [.date, .hourAndMinute])
                }

                Section("Notes") {
                    TextField("Notes", text: $item.note, axis: .vertical)
                        .lineLimit(3...6)
                }
            }
            .navigationTitle("Schedule")
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        item.startAt = startAt
                        item.endAt = max(endAt, startAt)
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
