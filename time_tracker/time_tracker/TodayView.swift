import SwiftUI
import SwiftData

struct TodayView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \Task.createdAt) private var tasks: [Task]

    @State private var isAddingTask = false

    private var activeTasks: [Task] {
        tasks.filter { !$0.isArchived }
    }

    var body: some View {
        NavigationStack {
            List {
                if activeTasks.isEmpty {
                    ContentUnavailableView("No Tasks", systemImage: "checkmark.circle", description: Text("Add your first task to start logging."))
                        .listRowSeparator(.hidden)
                } else {
                    ForEach(activeTasks) { task in
                        NavigationLink {
                            TaskDetailView(task: task)
                        } label: {
                            TaskRowView(task: task, day: .now)
                        }
                    }
                }
            }
            .listStyle(.plain)
            .navigationTitle("Today")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        isAddingTask = true
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $isAddingTask) {
                TaskEditorView { title in
                    let task = Task(title: title)
                    modelContext.insert(task)
                }
            }
        }
    }
}
