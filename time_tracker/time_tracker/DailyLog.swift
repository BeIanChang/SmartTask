import Foundation
import SwiftData

@Model
final class DailyLog {
    var task: TaskModel
    var day: Date
    var did: Bool
    var manualMinutes: Int?

    init(task: TaskModel, day: Date, did: Bool = false, manualMinutes: Int? = nil) {
        self.task = task
        self.day = day
        self.did = did
        self.manualMinutes = manualMinutes
    }

    var manualMinutesValue: Int {
        get { manualMinutes ?? 0 }
        set { manualMinutes = newValue }
    }
}
