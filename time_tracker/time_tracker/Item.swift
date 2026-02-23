//
//  Item.swift
//  time_tracker
//
//  Created by Ian on 2026-02-16.
//

import Foundation
import SwiftData

@Model
final class TaskModel {
    var title: String
    var createdAt: Date
    var isArchived: Bool
    var lastMinutes: Int
    var runningStartAt: Date?
    @Relationship(deleteRule: .cascade, inverse: \DailyLog.task) var logs: [DailyLog] = []
    @Relationship(deleteRule: .cascade, inverse: \TimeEntry.task) var timeEntries: [TimeEntry] = []
    @Relationship(deleteRule: .cascade, inverse: \TaskAttribute.task) var attributes: [TaskAttribute] = []

    init(title: String, createdAt: Date = .now, isArchived: Bool = false, lastMinutes: Int = 30, runningStartAt: Date? = nil) {
        self.title = title
        self.createdAt = createdAt
        self.isArchived = isArchived
        self.lastMinutes = lastMinutes
        self.runningStartAt = runningStartAt
    }
}
