import Foundation
import SwiftData

@Model
final class Milestone {
    var title: String
    var deadline: Date?
    var isCompleted: Bool
    var createdAt: Date

    init(title: String, deadline: Date? = nil, isCompleted: Bool = false, createdAt: Date = .now) {
        self.title = title
        self.deadline = deadline
        self.isCompleted = isCompleted
        self.createdAt = createdAt
    }
}
