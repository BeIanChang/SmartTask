import Foundation
import SwiftData

enum AttributeKind: String, Codable, CaseIterable {
    case number
    case percent
}

@Model
final class TaskAttribute {
    var task: TaskModel
    var name: String
    var kindRaw: String
    var weeklyGoal: Double?
    var dailyTarget: Double?
    @Relationship(deleteRule: .cascade, inverse: \TaskAttributeEntry.attribute) var entries: [TaskAttributeEntry] = []

    init(task: TaskModel, name: String, kind: AttributeKind = .number, weeklyGoal: Double? = nil, dailyTarget: Double? = nil) {
        self.task = task
        self.name = name
        self.kindRaw = kind.rawValue
        self.weeklyGoal = weeklyGoal
        self.dailyTarget = dailyTarget
    }

    var kind: AttributeKind {
        get { AttributeKind(rawValue: kindRaw) ?? .number }
        set { kindRaw = newValue.rawValue }
    }

    var dailyTargetValue: Double? {
        if let dailyTarget {
            return dailyTarget
        }
        guard kind == .number, let weeklyGoal else { return nil }
        return weeklyGoal / 7
    }
}
