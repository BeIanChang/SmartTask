import SwiftUI
import SwiftData

struct TaskAttributeEntryView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss

    @Bindable var task: TaskModel
    let day: Date

    var body: some View {
        NavigationStack {
            Form {
                if task.attributes.isEmpty {
                    Section {
                        Text("No attributes yet. Add one below.")
                            .foregroundStyle(.secondary)
                    }
                } else {
                    Section("Values") {
                        ForEach(task.attributes) { attribute in
                            AttributeEntryRow(attribute: attribute, day: day)
                        }
                    }
                }

                Section("New Attribute") {
                    NewAttributeRow(task: task)
                }
            }
            .navigationTitle("Attributes")
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") { dismiss() }
                }
            }
        }
    }
}

private struct AttributeEntryRow: View {
    @Environment(\.modelContext) private var modelContext

    let attribute: TaskAttribute
    let day: Date

    @State private var valueText = ""

    private var entry: TaskAttributeEntry {
        if let existing = attribute.entries.first(where: { $0.day.startOfDay == day.startOfDay }) {
            return existing
        }
        let created = TaskAttributeEntry(attribute: attribute, day: day.startOfDay, value: 0)
        modelContext.insert(created)
        return created
    }

    var body: some View {
        HStack {
            Text(attribute.name)
            Spacer()
            TextField("0", text: $valueText)
                .keyboardType(.decimalPad)
                .multilineTextAlignment(.trailing)
        }
        .onAppear {
            valueText = formatted(entry.value)
        }
        .onChange(of: valueText) { _, newValue in
            entry.value = parse(newValue)
        }
    }

    private func formatted(_ value: Double) -> String {
        if attribute.kind == .percent {
            return String(format: "%.0f", value * 100)
        }
        if value == floor(value) {
            return String(format: "%.0f", value)
        }
        return String(format: "%.2f", value)
    }

    private func parse(_ text: String) -> Double {
        let normalized = text.replacingOccurrences(of: ",", with: ".")
        let raw = Double(normalized) ?? 0
        if attribute.kind == .percent {
            return max(0, min(1, raw / 100))
        }
        return raw
    }
}

private struct NewAttributeRow: View {
    @Environment(\.modelContext) private var modelContext

    let task: TaskModel

    @State private var name = ""
    @State private var kind: AttributeKind = .number
    @State private var hasWeeklyGoal = false
    @State private var weeklyGoalText = ""
    @State private var dailyTargetText = ""

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            TextField("Attribute name", text: $name)

            Picker("Type", selection: $kind) {
                ForEach(AttributeKind.allCases, id: \.self) { type in
                    Text(type == .percent ? "Percent" : "Number").tag(type)
                }
            }
            .pickerStyle(.segmented)

            Toggle("Weekly goal", isOn: $hasWeeklyGoal)

            if hasWeeklyGoal {
                TextField("Weekly goal", text: $weeklyGoalText)
                    .keyboardType(.decimalPad)
            }

            if kind == .number {
                TextField("Daily target (optional)", text: $dailyTargetText)
                    .keyboardType(.decimalPad)
            }

            Button("Add Attribute") {
                let trimmed = name.trimmingCharacters(in: .whitespacesAndNewlines)
                guard !trimmed.isEmpty else { return }
                let weeklyGoal = hasWeeklyGoal ? parse(weeklyGoalText) : nil
                let dailyTarget = kind == .number ? parseOptional(dailyTargetText) : nil
                let attribute = TaskAttribute(task: task, name: trimmed, kind: kind, weeklyGoal: weeklyGoal, dailyTarget: dailyTarget)
                modelContext.insert(attribute)
                name = ""
                weeklyGoalText = ""
                dailyTargetText = ""
                hasWeeklyGoal = false
            }
            .buttonStyle(.borderedProminent)
            .disabled(name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
        }
    }

    private func parseOptional(_ text: String) -> Double? {
        let trimmed = text.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return nil }
        return parse(trimmed)
    }

    private func parse(_ text: String) -> Double {
        let normalized = text.replacingOccurrences(of: ",", with: ".")
        let raw = Double(normalized) ?? 0
        if kind == .percent {
            return max(0, min(1, raw / 100))
        }
        return raw
    }
}
