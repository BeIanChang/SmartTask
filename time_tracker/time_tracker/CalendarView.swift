import SwiftUI
import SwiftData

struct CalendarView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \TaskModel.createdAt) private var tasks: [TaskModel]
    @Query(sort: \ScheduleItem.startAt) private var scheduleItems: [ScheduleItem]

    @State private var selectedDate = Date().startOfDay
    @State private var isAddingSchedule = false

    private let calendar = Calendar.current

    private var weekDates: [Date] {
        guard let weekStart = calendar.dateInterval(of: .weekOfYear, for: selectedDate)?.start else {
            return [selectedDate]
        }
        return (0..<7).compactMap { offset in
            calendar.date(byAdding: .day, value: offset, to: weekStart)
        }
    }

    private var dayEntries: [TimeEntry] {
        tasks.flatMap { task in
            task.timeEntries.filter { entry in
                entry.startedAt >= selectedDate.startOfDay && entry.startedAt < selectedDate.endOfDay
            }
        }
    }

    private var daySchedules: [ScheduleItem] {
        scheduleItems.filter { item in
            item.startAt < selectedDate.endOfDay && item.endAt >= selectedDate.startOfDay
        }
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    VStack(alignment: .leading, spacing: 8) {
                        Text(selectedDate, format: .dateTime.weekday(.wide).month(.abbreviated).day())
                            .font(.headline)
                        WeekStripView(dates: weekDates, selectedDate: $selectedDate)
                    }

                    TimelineView(day: selectedDate, entries: dayEntries, schedules: daySchedules)
                }
                .padding(.horizontal)
                .padding(.top, 8)
            }
            .navigationTitle("Calendar")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        isAddingSchedule = true
                    } label: {
                        Image(systemName: "calendar.badge.plus")
                    }
                }
            }
            .sheet(isPresented: $isAddingSchedule) {
                ScheduleItemEditorView { title, start, end, note in
                    let item = ScheduleItem(title: title, startAt: start, endAt: end, note: note)
                    modelContext.insert(item)
                }
            }
        }
    }
}
