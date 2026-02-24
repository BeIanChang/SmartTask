import SwiftUI
import SwiftData

struct TodayView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \TaskModel.createdAt) private var tasks: [TaskModel]
    @Query(sort: \Milestone.createdAt) private var milestones: [Milestone]

    @State private var isAddingTask = false
    @State private var isAddingMilestone = false

    private var activeTasks: [TaskModel] {
        tasks.filter { !$0.isArchived }
    }

    private var activeMilestones: [Milestone] {
        let today = Date()
        let start = Calendar.current.date(byAdding: .day, value: -7, to: today) ?? today
        let end = Calendar.current.date(byAdding: .day, value: 7, to: today) ?? today
        return milestones.filter { milestone in
            guard let deadline = milestone.deadline else { return true }
            return deadline >= start && deadline <= end
        }
    }

    private var weeklyGoalAttributes: [WeeklyGoalItem] {
        activeTasks.flatMap { task in
            task.attributes.filter { attribute in
                attribute.weeklyGoal != nil || attribute.dailyTargetValue != nil
            }.map { attribute in
                WeeklyGoalItem(task: task, attribute: attribute)
            }
        }
    }

    var body: some View {
        NavigationStack {
            List {
                Section("Milestones") {
                    if activeMilestones.isEmpty {
                        ContentUnavailableView("No milestones", systemImage: "flag", description: Text("Add a milestone to track larger goals."))
                            .listRowSeparator(.hidden)
                    } else {
                        ForEach(activeMilestones) { milestone in
                            MilestoneRowView(milestone: milestone)
                        }
                        .onDelete(perform: deleteMilestones)
                    }
                }

                Section("Weekly Goals") {
                    if weeklyGoalAttributes.isEmpty {
                        ContentUnavailableView("No weekly goals", systemImage: "target", description: Text("Add weekly goals in task attributes."))
                            .listRowSeparator(.hidden)
                    } else {
                        ForEach(weeklyGoalAttributes, id: \WeeklyGoalItem.id) { item in
                            WeeklyGoalRowView(task: item.task, attribute: item.attribute)
                        }
                    }
                }

                Section("Daily Tasks") {
                    if activeTasks.isEmpty {
                        ContentUnavailableView("No tasks", systemImage: "checkmark.circle", description: Text("Add your first task to start logging."))
                            .listRowSeparator(.hidden)
                    } else {
                        ForEach(activeTasks) { task in
                            NavigationLink {
                                TaskDetailView(task: task)
                            } label: {
                                TaskRowView(task: task, day: .now, showsTimer: true)
                            }
                        }
                        .onDelete(perform: deleteTasks)
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
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        isAddingMilestone = true
                    } label: {
                        Image(systemName: "flag")
                    }
                }
                ToolbarItem(placement: .navigationBarLeading) {
                    EditButton()
                }
            }
            .sheet(isPresented: $isAddingTask) {
                TaskEditorView { title, draft in
                    let task = TaskModel(title: title)
                    modelContext.insert(task)
                    if let draft {
                        let attribute = TaskAttribute(task: task, name: draft.name, kind: draft.kind, weeklyGoal: draft.weeklyGoal, dailyTarget: draft.dailyTarget)
                        modelContext.insert(attribute)
                    }
                }
            }
            .sheet(isPresented: $isAddingMilestone) {
                MilestoneEditorView { title, deadline in
                    let milestone = Milestone(title: title, deadline: deadline)
                    modelContext.insert(milestone)
                    NotificationsManager.shared.scheduleMilestoneNotification(milestone)
                }
            }
        }
    }

    private func deleteTasks(offsets: IndexSet) {
        for index in offsets {
            modelContext.delete(activeTasks[index])
        }
    }

    private func deleteMilestones(offsets: IndexSet) {
        for index in offsets {
            let milestone = activeMilestones[index]
            NotificationsManager.shared.removeMilestoneNotification(milestone)
            modelContext.delete(milestone)
        }
    }
}

private struct WeeklyGoalItem: Identifiable {
    let id = UUID()
    let task: TaskModel
    let attribute: TaskAttribute
}
