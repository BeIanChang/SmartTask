import SwiftUI
import SwiftData

struct HistoryView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \Task.createdAt) private var tasks: [Task]

    @State private var selectedDate = Date().startOfDay

    private var activeTasks: [Task] {
        tasks.filter { !$0.isArchived }
    }

    var body: some View {
        NavigationStack {
            VStack(spacing: 12) {
                DatePicker("Date", selection: $selectedDate, displayedComponents: .date)
                    .datePickerStyle(.compact)
                    .padding(.horizontal)

                List {
                    if activeTasks.isEmpty {
                        ContentUnavailableView("No Tasks", systemImage: "calendar", description: Text("Create tasks on the Today tab."))
                            .listRowSeparator(.hidden)
                    } else {
                        ForEach(activeTasks) { task in
                            TaskRowView(task: task, day: selectedDate)
                        }
                    }
                }
                .listStyle(.plain)
            }
            .navigationTitle("History")
        }
    }
}
