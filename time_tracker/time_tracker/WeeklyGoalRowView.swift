import SwiftUI

struct WeeklyGoalRowView: View {
    let task: TaskModel
    let attribute: TaskAttribute

    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(task.title)
                    .font(.subheadline.weight(.semibold))
                Text(attribute.name)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }

            Spacer()

            if let dailyTarget = attribute.dailyTargetValue {
                Text("\(formatted(dailyTarget)) / day")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
        }
    }

    private func formatted(_ value: Double) -> String {
        if attribute.kind == .percent {
            return String(format: "%.0f%%", value * 100)
        }
        if value == floor(value) {
            return String(format: "%.0f", value)
        }
        return String(format: "%.2f", value)
    }
}
