import Foundation
import SwiftData

@Model
final class TimeEntry {
    var task: TaskModel
    var startedAt: Date
    var endedAt: Date?
    var minutes: Int
    var note: String

    init(task: TaskModel, startedAt: Date, endedAt: Date? = nil, minutes: Int = 0, note: String = "") {
        self.task = task
        self.startedAt = startedAt
        self.endedAt = endedAt
        self.minutes = minutes
        self.note = note
    }

    var isRunning: Bool {
        endedAt == nil
    }
}
