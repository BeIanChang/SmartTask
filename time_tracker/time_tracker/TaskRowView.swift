import SwiftUI
import SwiftData

struct TaskRowView: View {
    @Environment(\.modelContext) private var modelContext
    @Bindable var task: Task
    let day: Date

    @State private var isMinutesPickerPresented = false

    private var log: DailyLog {
        if let existing = taskLog {
            return existing
        }
        let newLog = DailyLog(task: task, day: day.startOfDay)
        modelContext.insert(newLog)
        return newLog
    }

    private var taskLog: DailyLog? {
        task.logs.first { $0.day.startOfDay == day.startOfDay }
    }

    var body: some View {
        HStack(spacing: 12) {
            Button {
                let updated = !log.did
                log.did = updated
                if updated {
                    log.minutes = max(log.minutes, task.lastMinutes)
                    task.lastMinutes = log.minutes
                } else {
                    log.minutes = 0
                }
            } label: {
                Image(systemName: log.did ? "checkmark.circle.fill" : "circle")
                    .foregroundStyle(log.did ? .green : .secondary)
                    .font(.title3)
            }
            .buttonStyle(.plain)

            Text(task.title)
                .font(.body)

            Spacer()

            Button {
                isMinutesPickerPresented = true
            } label: {
                Text("\(log.minutes)")
                    .font(.subheadline.weight(.semibold))
                    .padding(.horizontal, 10)
                    .padding(.vertical, 6)
                    .background(Color(.secondarySystemBackground))
                    .clipShape(Capsule())
            }
            .buttonStyle(.plain)
        }
        .sheet(isPresented: $isMinutesPickerPresented) {
            MinutesPickerView(minutes: log.minutes) { selected in
                log.did = selected > 0
                log.minutes = selected
                task.lastMinutes = max(task.lastMinutes, selected)
            }
            .presentationDetents([.medium])
        }
    }
}
