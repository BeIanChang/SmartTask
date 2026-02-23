import SwiftUI
import Charts

struct AttributeTrendView: View {
    let attribute: TaskAttribute

    private var series: [AttributePoint] {
        let sorted = attribute.entries.sorted { $0.day < $1.day }
        return sorted.map { entry in
            AttributePoint(date: entry.day, value: entry.value)
        }
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(attribute.name)
                .font(.headline)

            Chart(series) { point in
                LineMark(
                    x: .value("Day", point.date),
                    y: .value("Value", point.value)
                )
                .interpolationMethod(.catmullRom)
            }
            .frame(height: 120)

            if let goalText {
                HStack {
                    Text("Goal")
                    Spacer()
                    Text(goalText)
                        .foregroundStyle(.secondary)
                }
                .font(.subheadline)
            }
        }
    }

    private var goalText: String? {
        if let weeklyGoal = attribute.weeklyGoal {
            return "Weekly \(formatted(value: weeklyGoal))"
        }
        if let dailyTarget = attribute.dailyTargetValue {
            return "Daily \(formatted(value: dailyTarget))"
        }
        return nil
    }

    private func formatted(value: Double) -> String {
        if attribute.kind == .percent {
            return String(format: "%.0f%%", value * 100)
        }
        if value == floor(value) {
            return String(format: "%.0f", value)
        }
        return String(format: "%.2f", value)
    }
}

private struct AttributePoint: Identifiable {
    let id = UUID()
    let date: Date
    let value: Double
}
