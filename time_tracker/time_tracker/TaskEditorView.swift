import SwiftUI

struct TaskEditorView: View {
    @Environment(\.dismiss) private var dismiss
    let onSave: (String, AttributeDraft?) -> Void

    @State private var title = ""
    @State private var includeAttribute = false
    @State private var attributeName = ""
    @State private var attributeKind: AttributeKind = .number
    @State private var hasWeeklyGoal = false
    @State private var weeklyGoalText = ""
    @State private var dailyTargetText = ""

    var body: some View {
        NavigationStack {
            Form {
                Section("Task") {
                    TextField("Title", text: $title)
                }

                Section("Attribute") {
                    Toggle("Add attribute", isOn: $includeAttribute)

                    if includeAttribute {
                        TextField("Attribute name", text: $attributeName)

                        Picker("Type", selection: $attributeKind) {
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

                        if attributeKind == .number {
                            TextField("Daily target (optional)", text: $dailyTargetText)
                                .keyboardType(.decimalPad)
                        }
                    }
                }
            }
            .navigationTitle("New Task")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Add") {
                        let trimmed = title.trimmingCharacters(in: .whitespacesAndNewlines)
                        guard !trimmed.isEmpty else { return }
                        let draft = buildDraft()
                        onSave(trimmed, draft)
                        dismiss()
                    }
                    .disabled(title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                }
            }
        }
    }

    private func buildDraft() -> AttributeDraft? {
        guard includeAttribute else { return nil }
        let trimmed = attributeName.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return nil }
        let weeklyGoal = hasWeeklyGoal ? parse(weeklyGoalText, isPercent: attributeKind == .percent) : nil
        let dailyTarget = attributeKind == .number ? parseOptional(dailyTargetText) : nil
        return AttributeDraft(name: trimmed, kind: attributeKind, weeklyGoal: weeklyGoal, dailyTarget: dailyTarget)
    }

    private func parseOptional(_ text: String) -> Double? {
        let trimmed = text.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return nil }
        return parse(trimmed, isPercent: false)
    }

    private func parse(_ text: String, isPercent: Bool) -> Double {
        let normalized = text.replacingOccurrences(of: ",", with: ".")
        let raw = Double(normalized) ?? 0
        if isPercent {
            return max(0, min(1, raw / 100))
        }
        return raw
    }
}

struct AttributeDraft {
    let name: String
    let kind: AttributeKind
    let weeklyGoal: Double?
    let dailyTarget: Double?
}
