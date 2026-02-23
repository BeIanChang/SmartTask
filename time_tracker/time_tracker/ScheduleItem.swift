import Foundation
import SwiftData

@Model
final class ScheduleItem {
    var title: String
    var startAt: Date
    var endAt: Date
    var note: String
    var createdAt: Date

    init(title: String, startAt: Date, endAt: Date, note: String = "", createdAt: Date = .now) {
        self.title = title
        self.startAt = startAt
        self.endAt = endAt
        self.note = note
        self.createdAt = createdAt
    }
}
