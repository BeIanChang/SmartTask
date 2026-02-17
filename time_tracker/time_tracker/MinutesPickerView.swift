import SwiftUI

struct MinutesPickerView: View {
    let minutes: Int
    let onSave: (Int) -> Void

    @Environment(\.dismiss) private var dismiss
    @State private var selectedMinutes: Int

    private let presets = [0, 5, 10, 15, 20, 25, 30, 45, 60, 90, 120]

    init(minutes: Int, onSave: @escaping (Int) -> Void) {
        self.minutes = minutes
        self.onSave = onSave
        _selectedMinutes = State(initialValue: minutes)
    }

    var body: some View {
        NavigationStack {
            List {
                Section {
                    Picker("Minutes", selection: $selectedMinutes) {
                        ForEach(presets, id: \.self) { value in
                            Text("\(value) min").tag(value)
                        }
                    }
                    .pickerStyle(.wheel)
                }
            }
            .navigationTitle("Minutes")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        onSave(selectedMinutes)
                        dismiss()
                    }
                }
            }
        }
    }
}
