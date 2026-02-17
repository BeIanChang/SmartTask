import Foundation
import SwiftData

@Model
final class DailyLog {
    var task: Task
    var day: Date
    var did: Bool
    var minutes: Int

    init(task: Task, day: Date, did: Bool = false, minutes: Int = 0) {
        self.task = task
        self.day = day
        self.did = did
        self.minutes = minutes
    }
}
