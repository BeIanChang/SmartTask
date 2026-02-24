import SwiftUI
import SwiftData

struct TaskRowView: View {
    @Environment(\.modelContext) private var modelContext
    @Bindable var task: TaskModel
    let day: Date
    var showsTimer: Bool = false

    @State private var isMinutesPickerPresented = false
    @State private var isAttributeSheetPresented = false
    @State private var noteEntry: TimeEntry?
    @StateObject private var ticker = TimerTicker()

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

    private var runningEntry: TimeEntry? {
        task.timeEntries.first { $0.isRunning }
    }

    private var dailyTimeEntries: [TimeEntry] {
        task.timeEntries.filter { entry in
            entry.startedAt >= day.startOfDay && entry.startedAt < day.endOfDay
        }
    }

    private var totalMinutes: Int {
        let entryMinutes = dailyTimeEntries.reduce(0) { total, entry in
            total + entry.minutes
        }
        return entryMinutes + runningMinutes + log.manualMinutesValue
    }

    private var runningMinutes: Int {
        guard day.startOfDay == Date().startOfDay else { return 0 }
        let start = runningEntry?.startedAt ?? task.runningStartAt
        guard let runningStart = start else { return 0 }
        return max(0, Int(Date().timeIntervalSince(runningStart) / 60))
    }

    private var isRunning: Bool {
        task.runningStartAt != nil
    }

    var body: some View {
        HStack(spacing: 12) {
            Button {
                let updated = !log.did
                log.did = updated
                if updated {
                    log.manualMinutesValue = max(log.manualMinutesValue, task.lastMinutes)
                    task.lastMinutes = log.manualMinutesValue
                } else {
                    log.manualMinutesValue = 0
                }
                presentAttributesForToday()
            } label: {
                Image(systemName: log.did ? "checkmark.circle.fill" : "circle")
                    .foregroundStyle(log.did ? .green : .secondary)
                    .font(.title3)
            }
            .buttonStyle(.plain)

            Button {
                if showsTimer {
                    toggleTimer()
                }
            } label: {
                HStack(spacing: 6) {
                    if showsTimer {
                        Image(systemName: isRunning ? "pause.circle.fill" : "play.circle.fill")
                            .foregroundStyle(isRunning ? .orange : .blue)
                    }
                    Text(task.title)
                        .font(.body)
                        .foregroundStyle(.primary)
                }
            }
            .buttonStyle(.plain)

            Spacer()

            Button {
                isAttributeSheetPresented = true
            } label: {
                Image(systemName: "slider.horizontal.3")
                    .foregroundStyle(.secondary)
            }
            .buttonStyle(.plain)

            Button {
                isMinutesPickerPresented = true
            } label: {
                Text("\(totalMinutes)")
                    .font(.subheadline.weight(.semibold))
                    .padding(.horizontal, 10)
                    .padding(.vertical, 6)
                    .background(Color(.secondarySystemBackground))
                    .clipShape(Capsule())
            }
            .buttonStyle(.plain)
        }
        .sheet(isPresented: $isMinutesPickerPresented) {
            MinutesPickerView(minutes: log.manualMinutesValue) { selected in
                log.did = selected > 0
                log.manualMinutesValue = selected
                task.lastMinutes = max(task.lastMinutes, selected)
                presentAttributesForToday()
            }
            .presentationDetents([.medium])
        }
        .sheet(isPresented: $isAttributeSheetPresented) {
            TaskAttributeEntryView(task: task, day: day)
        }
        .sheet(item: $noteEntry) { entry in
            TimeEntryNoteView(entry: entry)
        }
        .onChange(of: log.did) { _, newValue in
            if newValue {
                presentAttributesForToday()
            }
        }
        .onAppear {
            if showsTimer {
                ticker.start()
            }
        }
        .onDisappear {
            ticker.stop()
        }
    }

    private func toggleTimer() {
        if isRunning {
            stopTimer()
        } else {
            startTimer()
        }
    }

    private func startTimer() {
        guard runningEntry == nil else { return }
        let entry = TimeEntry(task: task, startedAt: Date())
        task.runningStartAt = entry.startedAt
        modelContext.insert(entry)
        NotificationsManager.shared.startTimerActivity(for: task)
    }

    private func stopTimer() {
        guard let entry = runningEntry else { return }
        let end = Date()
        entry.endedAt = end
        entry.minutes = max(1, Int(end.timeIntervalSince(entry.startedAt) / 60))
        task.runningStartAt = nil
        log.did = true
        noteEntry = entry
        NotificationsManager.shared.stopTimerActivity()
        presentAttributesForToday()
    }

    private func presentAttributesForToday() {
        guard day.startOfDay == Date().startOfDay else { return }
        guard !task.attributes.isEmpty else { return }
        isAttributeSheetPresented = true
    }
}
