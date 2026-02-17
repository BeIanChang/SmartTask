//
//  Item.swift
//  time_tracker
//
//  Created by Ian on 2026-02-16.
//

import Foundation
import SwiftData

@Model
final class Task {
    var title: String
    var createdAt: Date
    var isArchived: Bool
    var lastMinutes: Int
    @Relationship(deleteRule: .cascade, inverse: \DailyLog.task) var logs: [DailyLog] = []

    init(title: String, createdAt: Date = .now, isArchived: Bool = false, lastMinutes: Int = 30) {
        self.title = title
        self.createdAt = createdAt
        self.isArchived = isArchived
        self.lastMinutes = lastMinutes
    }
}
