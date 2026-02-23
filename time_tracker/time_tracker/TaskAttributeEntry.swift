import Foundation
import SwiftData

@Model
final class TaskAttributeEntry {
    var attribute: TaskAttribute
    var day: Date
    var value: Double

    init(attribute: TaskAttribute, day: Date, value: Double = 0) {
        self.attribute = attribute
        self.day = day
        self.value = value
    }
}
