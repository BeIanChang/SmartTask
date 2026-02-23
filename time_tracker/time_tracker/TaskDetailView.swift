import SwiftUI
import SwiftData
import Charts

struct TaskDetailView: View {
    @Environment(\.modelContext) private var modelContext
    @Bindable var task: TaskModel

    private let calendar = Calendar.current

    private var last14Days: [Date] {
        (0..<14).compactMap { offset in
            calendar.date(byAdding: .day, value: -offset, to: Date().startOfDay)
        }.reversed()
    }

    private var last7Days: [Date] {
        (0..<7).compactMap { offset in
            calendar.date(byAdding: .day, value: -offset, to: Date().startOfDay)
        }
    }

    private var last30Days: [Date] {
        (0..<30).compactMap { offset in
            calendar.date(byAdding: .day, value: -offset, to: Date().startOfDay)
        }
    }

    private var weeklyMinutes: Int {
        last7Days.reduce(0) { total, date in
            total + minutes(for: date)
        }
    }

    private var last7Minutes: Int {
        last7Days.reduce(0) { total, date in
            total + minutes(for: date)
        }
    }

    private var last30Minutes: Int {
        last30Days.reduce(0) { total, date in
            total + minutes(for: date)
        }
    }

    private var timeSeries: [DayValue] {
        last30Days.reversed().map { date in
            DayValue(date: date, value: Double(minutes(for: date)))
        }
    }

    var body: some View {
        List {
            Section("Consistency") {
                HStack(spacing: 6) {
                    ForEach(last14Days, id: \.self) { date in
                        Circle()
                            .fill(minutes(for: date) > 0 ? .green : .gray.opacity(0.3))
                            .frame(width: 12, height: 12)
                    }
                }
                .padding(.vertical, 4)
            }

            Section("Time Trend") {
                Chart(timeSeries) { point in
                    LineMark(
                        x: .value("Day", point.date),
                        y: .value("Minutes", point.value)
                    )
                    .interpolationMethod(.catmullRom)
                }
                .frame(height: 160)
            }

            if !task.attributes.isEmpty {
                Section("Attributes") {
                    ForEach(task.attributes) { attribute in
                        AttributeTrendView(attribute: attribute)
                    }
                }
            }

            Section("Stats") {
                statRow(title: "Weekly Minutes", value: weeklyMinutes)
                statRow(title: "Last 7 Days", value: last7Minutes)
                statRow(title: "Last 30 Days", value: last30Minutes)
            }

            Section("Task") {
                Toggle("Archived", isOn: $task.isArchived)
            }
        }
        .navigationTitle(task.title)
        .navigationBarTitleDisplayMode(.inline)
    }

    private func minutes(for date: Date) -> Int {
        let manual = task.logs.first(where: { $0.day.startOfDay == date.startOfDay })?.manualMinutesValue ?? 0
        let timed = task.timeEntries.reduce(0) { total, entry in
            guard entry.startedAt >= date.startOfDay && entry.startedAt < date.endOfDay else { return total }
            return total + entry.minutes
        }
        return manual + timed
    }

    @ViewBuilder
    private func statRow(title: String, value: Int) -> some View {
        HStack {
            Text(title)
            Spacer()
            Text("\(value) min")
                .foregroundStyle(.secondary)
        }
    }
}

private struct DayValue: Identifiable {
    let id = UUID()
    let date: Date
    let value: Double
}
