#if canImport(ActivityKit) && !os(macOS)
import ActivityKit
import Foundation

@available(iOS 16.1, *)
struct SmartTaskLiveActivityAttributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable {
        var taskTitle: String
        var startedAt: Date
    }

    var taskId: String
}
#endif
