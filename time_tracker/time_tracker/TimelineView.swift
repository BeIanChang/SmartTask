import SwiftUI

struct TimelineView: View {
    let day: Date
    let entries: [TimeEntry]
    let schedules: [ScheduleItem]
    let onEntryTap: (TimeEntry) -> Void
    let onScheduleTap: (ScheduleItem) -> Void

    private let calendar = Calendar.current

    var body: some View {
        VStack(spacing: 16) {
            ForEach(hourSlots, id: \.self) { hour in
                HStack(alignment: .top, spacing: 12) {
                    Text(hourLabel(for: hour))
                        .font(.caption)
                        .frame(width: 60, alignment: .leading)
                        .foregroundStyle(.secondary)

                    VStack(alignment: .leading, spacing: 8) {
                        ForEach(blocks(for: hour), id: \.id) { block in
                            HStack {
                                Circle()
                                    .fill(block.color)
                                    .frame(width: 8, height: 8)
                                Text(block.title)
                                    .font(.caption)
                                    .foregroundStyle(.primary)
                                Spacer()
                                Text(block.timeRange)
                                    .font(.caption2)
                                    .foregroundStyle(.secondary)
                            }
                            .padding(8)
                            .background(block.color.opacity(0.15))
                            .clipShape(RoundedRectangle(cornerRadius: 8))
                            .onTapGesture {
                                block.onTap()
                            }
                        }
                    }

                    Spacer()
                }
            }
        }
    }

    private var hourSlots: [Int] {
        Array(7...21)
    }

    private func hourLabel(for hour: Int) -> String {
        let date = calendar.date(bySettingHour: hour, minute: 0, second: 0, of: day) ?? day
        let formatter = DateFormatter()
        formatter.dateFormat = "h a"
        return formatter.string(from: date)
    }

    private func blocks(for hour: Int) -> [TimelineBlock] {
        let hourStart = calendar.date(bySettingHour: hour, minute: 0, second: 0, of: day) ?? day
        let hourEnd = calendar.date(byAdding: .hour, value: 1, to: hourStart) ?? day

        let entryBlocks = entries.compactMap { entry -> TimelineBlock? in
            let end = entry.endedAt ?? Date()
            guard entry.startedAt < hourEnd && end > hourStart else { return nil }
            return TimelineBlock(
                title: entry.task.title,
                color: .purple,
                timeRange: timeRange(start: entry.startedAt, end: end),
                onTap: { onEntryTap(entry) }
            )
        }

        let scheduleBlocks = schedules.compactMap { item -> TimelineBlock? in
            guard item.startAt < hourEnd && item.endAt > hourStart else { return nil }
            return TimelineBlock(
                title: item.title,
                color: .teal,
                timeRange: timeRange(start: item.startAt, end: item.endAt),
                onTap: { onScheduleTap(item) }
            )
        }

        return entryBlocks + scheduleBlocks
    }

    private func timeRange(start: Date, end: Date) -> String {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return "\(formatter.string(from: start))–\(formatter.string(from: end))"
    }
}

private struct TimelineBlock: Identifiable {
    let id = UUID()
    let title: String
    let color: Color
    let timeRange: String
    let onTap: () -> Void
}
